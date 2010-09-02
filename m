Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758099Ab0IBVWg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Sep 2010 17:22:36 -0400
Received: from mail-qy0-f174.google.com ([209.85.216.174]:60848 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757508Ab0IBVIO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Sep 2010 17:08:14 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=SJf2nhFMj7t5tvMuG41iUR3ITb4v/ME8tUR1Xq0fj2lcfORgZ4xoY+SuU0pZhTkE8O
         x6RhFWxvGp1WrTLf6jOWEpeo0gGK3L1UmxeMduHpUJ8VxuXoXfKbvIIMvWOLzUYHGBu7
         k25s5V+3H+OiMJ7yWFIQYjFrd/WdFIQuLPbkk=
From: "Justin P. Mattock" <justinmattock@gmail.com>
To: trivial@kernel.org
Cc: linux-alpha@vger.kernel.org, linux-kernel@vger.kernel.org, jkosina@suse.cz,
        "Justin P. Mattock" <justinmattock@gmail.com>
Subject: [PATCH 25/91] arch/h8300/Kconfig.cpu Update broken web addresses in the arch directory.
Date: Thu,  2 Sep 2010 14:07:54 -0700
Message-Id: <1283461679-7851-10-git-send-email-justinmattock@gmail.com>
X-Mailer: git-send-email 1.7.2.1
In-Reply-To: <1283461679-7851-1-git-send-email-justinmattock@gmail.com>
References: <1283461679-7851-1-git-send-email-justinmattock@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The below patch updates a broken web address that is no longer
working due to company buyout, and/or change of location.
(Please have a look through, and let me know if any of them
need to be changed, and I'll resend an updated patch).

Signed-off-by: Justin P. Mattock <justinmattock@gmail.com>

---
 arch/h8300/Kconfig.cpu |   14 +++++++-------
 1 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/arch/h8300/Kconfig.cpu b/arch/h8300/Kconfig.cpu
index 6e2ecff..d69fc26 100644
--- a/arch/h8300/Kconfig.cpu
+++ b/arch/h8300/Kconfig.cpu
@@ -17,10 +17,10 @@ config H8300H_AKI3068NET
 	help
 	  AKI-H8/3068F / AKI-H8/3069F Flashmicom LAN Board Support
 	  More Information. (Japanese Only)
-	  <http://akizukidensi.com/catalog/h8.html>
+	  <http://akizukidenshi.com/catalog/default.aspx>
 	  AE-3068/69 Evaluation Board Support
 	  More Information.
-	  <http://www.microtronique.com/ae3069lan.htm>
+	  <http://www.microtronique.com/>
 
 config H8300H_H8MAX
 	bool "H8MAX"
@@ -28,7 +28,7 @@ config H8300H_H8MAX
 	help
 	  H8MAX Evaluation Board Support
 	  More Information. (Japanese Only)
-	  <http://strawberry-linux.com/h8/index.html>
+	  <http://strawberry-linux.com/h8/>
 
 config H8300H_SIM
 	bool "H8/300H Simulator"
@@ -36,7 +36,7 @@ config H8300H_SIM
 	help
 	  GDB Simulator Support
 	  More Information.
-	  arch/h8300/Doc/simulator.txt
+	  <http://www.gnu.org/software/gdb/> 
 
 config H8S_GENERIC
 	bool "H8S Generic"
@@ -49,15 +49,15 @@ config H8S_EDOSK2674
 	help
 	  Renesas EDOSK-2674 Evaluation Board Support
 	  More Information.
-	  <http://www.azpower.com/H8-uClinux/index.html>
- 	  <http://www.eu.renesas.com/tools/edk/support/edosk2674.html>
+	  <http://h8-uclinux.sourceforge.net/>
+ 	  <http://www.renesas.eu/>
 
 config H8S_SIM
 	bool "H8S Simulator"
 	help
 	  GDB Simulator Support
 	  More Information.
-	  arch/h8300/Doc/simulator.txt
+	  http://www.gnu.org/software/gdb/ 
 
 endchoice
 
-- 
1.7.2.1

