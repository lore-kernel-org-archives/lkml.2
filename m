Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754863Ab0C1Rnr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Mar 2010 13:43:47 -0400
Received: from mail-gw0-f46.google.com ([74.125.83.46]:58711 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754837Ab0C1Rnq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Mar 2010 13:43:46 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=Ua+T4ED1axdVl7v8RAj8GFdGXPOg1DVC6wizcFbBlPLTqlaLpRIgigW6SHqc3huC5W
         dx14M7cGJXKFyLO/vteixzF9/161jd2j0VY+ofixjUvrv36uKMLzzOW9G7IKIHq7ZyMD
         92weRKZxiRZnh31HFztXFhgJk6Ylf7ayvGdOE=
From: "Justin P. Mattock" <justinmattock@gmail.com>
To: linux-fbdev@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
       "Justin P. Mattock" <justinmattock@gmail.com>
Subject: [PATCH] Rename imacfb.txt to efifb.txt and change imacfb to efifb.
Date: Sun, 28 Mar 2010 10:43:30 -0700
Message-Id: <1269798210-8664-1-git-send-email-justinmattock@gmail.com>
X-Mailer: git-send-email 1.6.5.GIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rename imacfb.txt to efifb.txt since imacfb was moved to
efifb,and change imacfb to efifb. 
Note:I used git rm for imacfb.txt, but
git renamed this file to efifb.txt after everything was said and
done, not sure if this is correct or not.


Signed-off-by: Justin P. Mattock <justinmattock@gmail.com>
---
 Documentation/fb/efifb.txt  |   31 +++++++++++++++++++++++++++++++
 Documentation/fb/imacfb.txt |   31 -------------------------------
 2 files changed, 31 insertions(+), 31 deletions(-)
 create mode 100644 Documentation/fb/efifb.txt
 delete mode 100644 Documentation/fb/imacfb.txt

diff --git a/Documentation/fb/efifb.txt b/Documentation/fb/efifb.txt
new file mode 100644
index 0000000..a59916c
--- /dev/null
+++ b/Documentation/fb/efifb.txt
@@ -0,0 +1,31 @@
+
+What is efifb?
+===============
+
+This is a generic EFI platform driver for Intel based Apple computers.
+efifb is only for EFI booted Intel Macs.
+
+Supported Hardware
+==================
+
+iMac 17"/20"
+Macbook
+Macbook Pro 15"/17"
+MacMini
+
+How to use it?
+==============
+
+efifb does not have any kind of autodetection of your machine.
+You have to add the following kernel parameters in your elilo.conf:
+	Macbook :
+		video=efifb:macbook
+	MacMini :
+		video=efifb:mini
+	Macbook Pro 15", iMac 17" :
+		video=efifb:i17
+	Macbook Pro 17", iMac 20" :
+		video=efifb:i20
+
+--
+Edgar Hucek <gimli@dark-green.com>
diff --git a/Documentation/fb/imacfb.txt b/Documentation/fb/imacfb.txt
deleted file mode 100644
index 316ec9b..0000000
--- a/Documentation/fb/imacfb.txt
+++ /dev/null
@@ -1,31 +0,0 @@
-
-What is imacfb?
-===============
-
-This is a generic EFI platform driver for Intel based Apple computers.
-Imacfb is only for EFI booted Intel Macs.
-
-Supported Hardware
-==================
-
-iMac 17"/20"
-Macbook
-Macbook Pro 15"/17"
-MacMini
-
-How to use it?
-==============
-
-Imacfb does not have any kind of autodetection of your machine.
-You have to add the following kernel parameters in your elilo.conf:
-	Macbook :
-		video=imacfb:macbook
-	MacMini :
-		video=imacfb:mini
-	Macbook Pro 15", iMac 17" :
-		video=imacfb:i17
-	Macbook Pro 17", iMac 20" :
-		video=imacfb:i20
-
---
-Edgar Hucek <gimli@dark-green.com>
-- 
1.6.5.GIT

