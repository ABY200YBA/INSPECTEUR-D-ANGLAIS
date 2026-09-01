import Foundation

enum CoachEngine {
    static func answer(to question: String) -> String {
        let query = question.folding(options: .diacriticInsensitive, locale: .current).lowercased()
        if query.contains("iems") || query.contains("inspection") || query.contains("mission") {
            return """
            Missions de l'IEMS et conduite d'une inspection

            L'IEMS ne se limite ni à contrôler ni à sanctionner. Dans le corpus de préparation sénégalais, ses fonctions articulent contrôle, animation, formation et encadrement pédagogique et technique. Une visite sérieuse commence par le contexte de l'établissement, les résultats, la progression et l'objectif de la visite. Pendant la séance, l'inspecteur recueille des faits : objectif annoncé, activités, interaction, différenciation, évaluation et réponses des élèves.

            L'entretien transforme ces données en analyse partagée. Il met en valeur les acquis, définit des priorités réalistes, prévoit un accompagnement et fixe un suivi mesurable.

            Réponse d'oral : « Je diagnostique à partir de preuves ; je rappelle le cadre ; j'analyse avec l'enseignant ; je propose un accompagnement ; je fixe des indicateurs et une échéance de suivi. »
            """
        }
        if query.contains("loi") || query.contains("91-22") || query.contains("2004-37") || query.contains("obligatoire") {
            return """
            Cadre de l'éducation au Sénégal

            La loi n°91-22 du 16 février 1991 porte orientation de l'Éducation nationale. Au concours, ne récitez pas seulement la référence : présentez le principe concerné et montrez sa conséquence pour l'accès, la qualité ou le pilotage de l'école. La loi n°2004-37 introduit notamment l'article 3 bis : scolarité obligatoire de six à seize ans, gratuité dans le public, obligation d'inscription et d'assiduité.

            Pour l'inspecteur, cette norme conduit à interroger les absences, le maintien des élèves, les conditions d'apprentissage, les résultats et la mobilisation des acteurs.
            """
        }
        if query.contains("task") || query.contains("tblt") || query.contains("communicative") || query.contains("clil") || query.contains("tache") {
            return """
            Analyse d'une pédagogie communicative ou par tâches

            Le PDF Techniques and Principles in Language Teaching présente les méthodes comme des ensembles cohérents de principes, techniques et procédures, non comme des recettes. En Task-Based Language Teaching, l'élève mobilise la langue pour accomplir une tâche porteuse de sens. L'inspecteur examine l'objectif communicatif, la clarté des consignes, les ressources linguistiques, la qualité des interactions, le temps de parole des élèves et le retour sur la langue.

            En CLIL ou content-based instruction, langue et contenu disciplinaire se soutiennent mutuellement. Il faut donc observer à la fois la compréhension du contenu et les progrès linguistiques.
            """
        }
        if query.contains("vygotsky") || query.contains("etayage") || query.contains("zpd") {
            return """
            Vygotsky et l'étayage en classe d'anglais

            La zone proximale de développement correspond à ce que l'apprenant peut réussir avec une médiation appropriée avant de pouvoir le réaliser seul. En inspection, on analyse la qualité des aides : modèles, exemples, supports visuels, travail en binômes, reformulations et questionnement progressif. L'aide doit ensuite diminuer pour que l'élève prenne la responsabilité de sa production.
            """
        }
        if query.contains("dissertation") || query.contains("problematique") || query.contains("plan") {
            return """
            Construire une dissertation IEMS

            Définissez les termes et identifiez la tension réelle du sujet. Formulez une problématique qui appelle une démonstration. Un plan efficace peut partir du diagnostic des enjeux, étudier les conditions de réussite puis proposer les leviers de pilotage. Chaque partie doit être argumentée, illustrée par un contexte éducatif pertinent et reliée à l'action de l'inspecteur.

            Méthode : définition - tension - problématique - axes démontrés - exemples contextualisés - réponse opérationnelle.
            """
        }
        return """
        Coach IEMS Anglais

        Je peux fournir une réponse structurée sur les missions IEMS, le cadre éducatif sénégalais, l'observation d'un cours d'anglais, les méthodes du PDF, la didactique, l'évaluation, la dissertation ou l'étude de cas.

        Indiquez votre thème et le format souhaité : fiche de révision, réponse orale de 90 secondes, plan détaillé ou étude de cas.
        """
    }

    static func review(_ response: String) -> [String] {
        let text = response.folding(options: .diacriticInsensitive, locale: .current).lowercased()
        let checks = [
            ("Diagnostic", ["diagnostic", "constat", "fait", "probleme"]),
            ("Cadre ou référence", ["loi", "decret", "cadre", "reference", "programme"]),
            ("Analyse didactique", ["objectif", "competence", "eleve", "apprentissage", "evaluation"]),
            ("Proposition d'action", ["propose", "action", "formation", "accompagne", "recommande"]),
            ("Suivi mesurable", ["suivi", "indicateur", "echeance", "resultat"])
        ]
        return checks.map { label, terms in
            terms.contains(where: text.contains) ? "✓ " + label : "○ À renforcer : " + label
        }
    }
}
