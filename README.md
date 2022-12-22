# jenkins-cicd-static-website
Bootcamp Devops mimi-projet Jenkins-CICD

## Etapes

**Github :** https://github.com/juliosISTY/jenkins-cicd-static-website

**Shared library :** https://github.com/juliosISTY/shared-library

**login et password jenkins**
- user : jules
- password : root

**credentials a créer**
- dockerhub_password :  secret 
- heroku_api_key : secret text

**Configuration des share libraries**

	Nom : juliosISTY-slack-share-library
	Mange Jenkins >  Configure system > Global Pipeline Libraries (Sharable) 
		> On donne un nom a la librairie (juliosISTY-slack-share-library), la branche (eventuellement), et on specifie qu'il prend le code sur github
		> Default version : main


**Conf de slack**

	on créé un channel privé dans slack
	ON va dans les application slack et on cherche jenkins puis on installe plugin jenkins-ci
	On va dans la partie seetings, on click  sur add to slack, on selectionne le channel, on rajoute la jenkins ci, 
	On va dans jenkins et on installe le plugin "slack Notification"   
		> redémarrage requis
	On créé un nouveau secret pour slack de 
		> type secret text (la valeur est celle récupére dans slack)
	On va dans Mange Jenkins >  Configure system > slack, 
		> on fournit le workspace (pozosworkspace), les credentials le nom du channel "#test_notif_jenkins" ensuite on
	click pour tester la connectivité