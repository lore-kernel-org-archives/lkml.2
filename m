Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762445Ab0GUFHJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jul 2010 01:07:09 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:39306 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762272Ab0GUE57 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jul 2010 00:57:59 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=mHn6oECiB3rIj9+ARty4djJnIM75udZQOv5XfVxtH+JCrxglsb/AlXo3QwSqmJkzZ0
         nhU4q89NsX1qFIwjAMentraPNkiSFANkJy/VdDboVFd1hN/3YaRakgwybLTkQ70tiDdW
         42C8G4H0zM8OmmpY3kT1Ub95TNJ9QQlqu9A9A=
From: "Justin P. Mattock" <justinmattock@gmail.com>
To: trivial@kernel.org
Cc: linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Justin P. Mattock" <justinmattock@gmail.com>
Subject: [PATCH 110/110]Documentation/sound/alsa/ALSA-Configuration.txt update web address.
Date: Tue, 20 Jul 2010 21:57:49 -0700
Message-Id: <1279688279-29683-5-git-send-email-justinmattock@gmail.com>
X-Mailer: git-send-email 1.7.1.rc1.21.gf3bd6
In-Reply-To: <1279688279-29683-1-git-send-email-justinmattock@gmail.com>
References: <1279688279-29683-1-git-send-email-justinmattock@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The patch below updates a broken web address to the comany
site due to me not knowing where this ones at.

Signed-off-by: Justin P. Mattock <justinmattock@gmail.com>

---
 Documentation/sound/alsa/ALSA-Configuration.txt |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/Documentation/sound/alsa/ALSA-Configuration.txt b/Documentation/sound/alsa/ALSA-Configuration.txt
index 2075bbb..7f4dceb 100644
--- a/Documentation/sound/alsa/ALSA-Configuration.txt
+++ b/Documentation/sound/alsa/ALSA-Configuration.txt
@@ -1285,7 +1285,7 @@ Prior to version 0.9.0rc4 options had a 'snd_' prefix. This was removed.
     about this driver.  Note that it has been discontinued, but the 
     Voyetra Turtle Beach knowledge base entry for it is still available
     at
-	http://www.turtlebeach.com/site/kb_ftp/790.asp
+	http://www.turtlebeach.com
 
   Module snd-msnd-pinnacle
   ------------------------
-- 
1.7.1.rc1.21.gf3bd6

