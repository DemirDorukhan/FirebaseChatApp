
import SwiftUI
import Firebase

struct AuthView : View {
    
    let db = Firestore.firestore()
    @ObservedObject var userStore = UserStore()
    @State var ref: DocumentReference? = nil
    @State var useremail = ""
    @State var password = ""
    @State var username = ""
    @State var showAuthView = true
    
    var body: some View {
        
        NavigationView{
        if showAuthView{
        List {
            Text("WhatzApp")
            .font(.largeTitle)
            .bold()

            Section{
                VStack(alignment:.leading){
                    SectionSubTitle(subtitle: "User E-mail")
                    TextField(" ",text: $useremail)
                }
            }
            
            Section{
                VStack(alignment:.leading){
                    SectionSubTitle(subtitle: "Password")
                    TextField(" ",text:$password)
                }
            }
            
            Section{
                VStack(alignment:.leading){
                    SectionSubTitle(subtitle: "Username")
                    TextField(" ",text:$username)
                }
            }
            
            Section{
                HStack{
                    Spacer()
                Button(action: {
                    //sign in
                    Auth.auth().signIn(withEmail: self.useremail, password: self.password) { (result, error) in
                        if error != nil {
                            print(error?.localizedDescription ?? "Couldn't Sign In")
                        } else {
                            //User signed in
                            self.showAuthView = false
                        }
                    }
                }) {
                    Text("Sign In")
                }
                    Spacer()
                }
            }
            Section{
                HStack{
                    Spacer()
                    Button(action: {
                        Auth.auth().createUser(withEmail: self.useremail, password: self.password) { (result, error) in
                            if error != nil {
                                print(error?.localizedDescription ?? "Could'nt Created")
                            } else {
                               //User created
                                let myUserDictionary: [String : Any] = ["username": self.username,"useremail":self.useremail,"useruidfromfirebase":result!.user.uid]
                                ref = self.db.collection("Users").addDocument(data: myUserDictionary, completion: { (error) in
                                    if error != nil {
                                    }})
                               //User View
                                self.showAuthView = false
                            }
                        }
                    }) { Text("Sign Up") }
                    Spacer()
                }
            }
        }//AUTH VIEW END
            } else {
                //USER VIEW
                NavigationView {
                    List(userStore.userArray) { user in
                        NavigationLink(destination: ChatView(userToChat: user)) {
                            Text(user.name)
                        }
                    }
                }.navigationBarTitle(Text("Chat With Users!"))
                    .navigationBarItems(leading: Button(action: {
                        //log out
                        do {
                            try Auth.auth().signOut()
                        } catch {
                        }
                        self.showAuthView = true
                    }, label: {
                        Text("Log Out")
                }))
            }
        }
    }
}

struct ContentView_Previews : PreviewProvider {
    static var previews: some View {
        Group{
            AuthView(showAuthView:false)
            AuthView(showAuthView:true)
        }
    }
}

struct SectionSubTitle: View{
    var subtitle: String
    
    var body: some View {
        return Text(subtitle).font(.subheadline).foregroundColor(.black)
    }
}
