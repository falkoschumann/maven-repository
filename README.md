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
