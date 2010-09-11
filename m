Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752594Ab0IKFpg (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Sep 2010 01:45:36 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:56070 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751476Ab0IKFpf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Sep 2010 01:45:35 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=RKeoby+MBMM6Th+3VXtSs9mTudHyDeBilJzkzLmJYG8KAT5CP/YHEfh667AmLMkPAY
         Tgwv0McqWrNCChlgmDQNI5A6fyoP+cBB5nmqy7jH15E/x3KOLQ/BQrvFa3foLPIQE1yW
         0AsZQpF5+YBmBNbxJOtdz++KqwOVdJKqHGOY8=
From: "Justin P. Mattock" <justinmattock@gmail.com>
To: trivial@kernel.org
Cc: linux-kernel@vger.kernel.org,
        "Justin P. Mattock" <justinmattock@gmail.com>
Subject: [PATCH 01/11]net/ax25/Kconfig Update broken web addresses.
Date: Fri, 10 Sep 2010 22:45:53 -0700
Message-Id: <1284183963-8474-1-git-send-email-justinmattock@gmail.com>
X-Mailer: git-send-email 1.7.2.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Below you will find an Update to a broken web address.
Please let me know if this needs to be changed.

Signed-off-by: Justin P. Mattock <justinmattock@gmail.com>

---
 net/ax25/Kconfig |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/net/ax25/Kconfig b/net/ax25/Kconfig
index 2a72aa9..705e53e 100644
--- a/net/ax25/Kconfig
+++ b/net/ax25/Kconfig
@@ -7,7 +7,7 @@ menuconfig HAMRADIO
 	bool "Amateur Radio support"
 	help
 	  If you want to connect your Linux box to an amateur radio, answer Y
-	  here. You want to read <http://www.tapr.org/tapr/html/pkthome.html>
+	  here. You want to read <http://www.tapr.org/>
 	  and more specifically about AX.25 on Linux
 	  <http://www.linux-ax25.org/>.
 
@@ -42,7 +42,7 @@ config AX25
 	  check out the file <file:Documentation/networking/ax25.txt> in the
 	  kernel source. More information about digital amateur radio in
 	  general is on the WWW at
-	  <http://www.tapr.org/tapr/html/pkthome.html>.
+	  <http://www.tapr.org/>.
 
 	  To compile this driver as a module, choose M here: the
 	  module will be called ax25.
@@ -89,7 +89,7 @@ config NETROM
 	  <http://www.linux-ax25.org>. You also might want to check out the
 	  file <file:Documentation/networking/ax25.txt>. More information about
 	  digital amateur radio in general is on the WWW at
-	  <http://www.tapr.org/tapr/html/pkthome.html>.
+	  <http://www.tapr.org/>.
 
 	  To compile this driver as a module, choose M here: the
 	  module will be called netrom.
@@ -108,7 +108,7 @@ config ROSE
 	  <http://www.linux-ax25.org>.  You also might want to check out the
 	  file <file:Documentation/networking/ax25.txt>. More information about
 	  digital amateur radio in general is on the WWW at
-	  <http://www.tapr.org/tapr/html/pkthome.html>.
+	  <http://www.tapr.org/>.
 
 	  To compile this driver as a module, choose M here: the
 	  module will be called rose.
-- 
1.7.2.1

