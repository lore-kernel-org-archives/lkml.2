Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757153Ab0IIXBT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Sep 2010 19:01:19 -0400
Received: from mail-px0-f174.google.com ([209.85.212.174]:48051 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932522Ab0IIWgi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Sep 2010 18:36:38 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=J9O/IGBEINCOJVSQOdb3PHun3VO4n1DZF2Z1Kb1KtTtqnoT5NA1rVcX/91AOxuVcov
         g8T8sKenJhR0Blex7tvAUlc4sxzzIlSjJpzOuBBd2Eg7dUvy2KwGzuVi0hP/6dDGKTCf
         5LessIYSk2KX1X1JwxlJ3lbB+sYTrpKDLE/Og=
From: "Justin P. Mattock" <justinmattock@gmail.com>
To: trivial@kernel.org
Cc: linux-kernel@vger.kernel.org,
        "Justin P. Mattock" <justinmattock@gmail.com>
Subject: [PATCH 112/223]drivers/net/wan/Kconfig Update broken web addresses.
Date: Thu,  9 Sep 2010 15:36:41 -0700
Message-Id: <1284071809-8149-7-git-send-email-justinmattock@gmail.com>
X-Mailer: git-send-email 1.7.2.1
In-Reply-To: <1284071809-8149-1-git-send-email-justinmattock@gmail.com>
References: <1284071809-8149-1-git-send-email-justinmattock@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Below you will find an Update to a broken web address.
Please let me know if this needs to be changed.

Signed-off-by: Justin P. Mattock <justinmattock@gmail.com>

---
 drivers/net/wan/Kconfig |   14 +++++++-------
 1 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/net/wan/Kconfig b/drivers/net/wan/Kconfig
index d08ce6a..c19f166 100644
--- a/drivers/net/wan/Kconfig
+++ b/drivers/net/wan/Kconfig
@@ -305,7 +305,7 @@ config DSCC4
 	  DSCC4 chipset.
 
 	  This is supposed to work with the four port card. Take a look at
-	  <http://www.cogenit.fr/dscc4/> for further information about the
+	  <http://www.cogenit.fr/> for further information about the
 	  driver.
 
 	  To compile this driver as a module, choose M here: the
@@ -409,15 +409,15 @@ config CYCLADES_SYNC
 	tristate "Cyclom 2X(tm) cards (EXPERIMENTAL)"
 	depends on WAN_ROUTER_DRIVERS && (PCI || ISA)
 	---help---
-	  Cyclom 2X from Cyclades Corporation <http://www.cyclades.com/> is an
+	  Cyclom 2X from Cyclades Corporation <http://www.avocent.com/> is an
 	  intelligent multiprotocol WAN adapter with data transfer rates up to
 	  512 Kbps. These cards support the X.25 and SNA related protocols.
 
 	  While no documentation is available at this time please grab the
 	  wanconfig tarball in
-	  <http://www.conectiva.com.br/~acme/cycsyn-devel/> (with minor changes
-	  to make it compile with the current wanrouter include files; efforts
-	  are being made to use the original package available at
+	  <http://web.archive.org/web/*/http://www.conectiva.com.br/~acme/cycsyn-devel/> 
+	  (with minor changes to make it compile with the current wanrouter include files;
+	  efforts are being made to use the original package available at
 	  <ftp://ftp.sangoma.com/>).
 
 	  Feel free to contact me or the cycsyn-devel mailing list at
@@ -481,8 +481,8 @@ config SBNI
 	  leased line modems.
 
 	  You can find more information and last versions of drivers and
-	  utilities at <http://www.granch.ru/>. If you have any question you
-	  can send email to <sbni@granch.ru>.
+	  utilities at <http://web.archive.org/web/*/http://www.granch.ru>.
+	  If you have any question you can send email to <sbni@granch.ru>.
 
 	  To compile this driver as a module, choose M here: the
 	  module will be called sbni.
-- 
1.7.2.1

