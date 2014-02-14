Maven Repository
================

Der Branch *gh-pages* enthält zwei Maven-Repositories: *releases* und *snapshots* mit meinen Projekten.

Um das Releases-Repository zu nutzen muss in der pom.xml des Projekts folgendes hinzugefügt werden:

    <repositories>
        <repository>
            <id>github-falkoschumann</id>
            <url>http://falkoschumann.github.io/maven-repository/releases/</url>
        </repository>
    </repositories>
    
Um das Snapshots-Repository zu nutzen muss in der pom.xml des Projekts folgendes hinzugefügt werden:

    <repositories>
        <repository>
            <id>github-falkoschumann</id>
            <url>http://falkoschumann.github.io/maven-repository/snapshots/</url>
        </repository>
    </repositories>


Neue Artefakte deployen
-----------------------

Um in das Maven Repository neue Artefakte zu deployen muss als erstes das Git Repository des Maven Repository lokal ausgecheckt werden. Aus dem zu bauenden Projekt heraus kann dann mit dem folgendem Befehl deployt werden:

    mvn -DaltDeploymentRepository=repository::default::file:../maven-repository/releases/ clean deploy

Der Pfad zum lokal ausgecheckten Maven Repository muss gegebenenfalls angepasst werden.
