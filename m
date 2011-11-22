Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755944Ab1KVOLn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Nov 2011 09:11:43 -0500
Received: from mail176c2.megamailservers.com ([69.49.111.76]:57474 "EHLO
	mail176c2.megamailservers.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755831Ab1KVOLj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Nov 2011 09:11:39 -0500
X-Authenticated-User: konrad.gaisler.com
From: Konrad Eisele <konrad@gaisler.com>
To: linux-kernel@vger.kernel.org
Cc: lacombar@gmail.com, mmarek@suse.cz, yann.morin.1998@anciens.enib.fr,
        linux-config@vger.kernel.org, konrad@gaisler.com
Subject: [PATCH 3/3] kconfig: gconfig save button should be greyed if no changes present
Date: Tue, 22 Nov 2011 15:03:46 +0100
Message-Id: <1321970626-12615-4-git-send-email-konrad@gaisler.com>
X-Mailer: git-send-email 1.6.4.1
In-Reply-To: <CACqU3MXPWvfThDmLMrK+ne+_hDXOU=atJpC98hUHL04DXUPAxw@mail.gmail.com>
References: <CACqU3MXPWvfThDmLMrK+ne+_hDXOU=atJpC98hUHL04DXUPAxw@mail.gmail.com>
X-CSC: 0
X-CHA: v=1.1 cv=vjffymXyDtjo34N5cbiAavWp8ckkCSHNaVzdIDazEXU= c=1 sm=1
		a=4NSfvREV-F8A:10 a=U62ajLuCel8A:10 a=jXKJviUpWSOlMmIvGrHOfw==:17
		a=ebG-ZW-8AAAA:8 a=o6g9dvYOGX0ePB6bRkQA:9 a=cCYF7-FHeg4A:10
		a=jXKJviUpWSOlMmIvGrHOfw==:117
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Call config_changed to check weather changes are present and grey
save button if not.

Signed-off-by: Konrad Eisele <konrad@gaisler.com>
---
 scripts/kconfig/gconf.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/scripts/kconfig/gconf.c b/scripts/kconfig/gconf.c
index 39dd257..993cc31 100644
--- a/scripts/kconfig/gconf.c
+++ b/scripts/kconfig/gconf.c
@@ -1532,6 +1532,7 @@ int main(int ac, char *av[])
 		break;
 	}
 
+	conf_changed();
 	gtk_main();
 
 	return 0;
-- 
1.6.4.1

