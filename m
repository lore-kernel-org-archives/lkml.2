Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757402Ab0IBVH2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Sep 2010 17:07:28 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:54119 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757348Ab0IBVHY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Sep 2010 17:07:24 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=XDbLuvIZ4BIiYq0TNWWBhIqgwKovhmw4kR4oLhZnSS5ac2OzvT5SvitCPUV9J2ACVt
         Ln0dP3GGOOLONSQmAnGw9ZfPBn5fbhA1xO18WnpnzxRFQZMZCIk1nrqcKVdfkosJtB1V
         q3kn0sBxduiSZyC9dvkr8BQSauGgs/8mAGMOY=
From: "Justin P. Mattock" <justinmattock@gmail.com>
To: trivial@kernel.org
Cc: linux-alpha@vger.kernel.org, linux-kernel@vger.kernel.org, jkosina@suse.cz,
        "Justin P. Mattock" <justinmattock@gmail.com>
Subject: [PATCH 15/91] arch/arm/mach-at91/Kconfig Update broken web addresses in the arch directory.
Date: Thu,  2 Sep 2010 14:06:46 -0700
Message-Id: <1283461606-7803-16-git-send-email-justinmattock@gmail.com>
X-Mailer: git-send-email 1.7.2.1
In-Reply-To: <1283461606-7803-1-git-send-email-justinmattock@gmail.com>
References: <1283461606-7803-1-git-send-email-justinmattock@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The below patch updates a broken web address that is no longer
working due to company buyout, and/or change of location.
(Please have a look through, and let me know if any of them
need to be changed, and I'll resend an updated patch).

Signed-off-by: Justin P. Mattock <justinmattock@gmail.com>

---
 arch/arm/mach-at91/Kconfig |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/arm/mach-at91/Kconfig b/arch/arm/mach-at91/Kconfig
index 939bccd..c0bcfb8 100644
--- a/arch/arm/mach-at91/Kconfig
+++ b/arch/arm/mach-at91/Kconfig
@@ -105,7 +105,7 @@ config MACH_ONEARM
 	bool "Ajeco 1ARM Single Board Computer"
 	help
 	  Select this if you are using Ajeco's 1ARM Single Board Computer.
-	  <http://www.ajeco.fi/products.htm>
+	  <http://www.ajeco.fi/index.php?language=fin>
 
 config ARCH_AT91RM9200DK
 	bool "Atmel AT91RM9200-DK Development board"
@@ -137,7 +137,7 @@ config MACH_CARMEVA
 	bool "Conitec ARM&EVA"
 	help
 	  Select this if you are using Conitec's AT91RM9200-MCU-Module.
-	  <http://www.conitec.net/english/linuxboard.htm>
+	  <http://www.conitec.net/english/linuxboard.php>
 
 config MACH_ATEB9200
 	bool "Embest ATEB9200"
@@ -149,7 +149,7 @@ config MACH_KB9200
 	bool "KwikByte KB920x"
 	help
 	  Select this if you are using KwikByte's KB920x board.
-	  <http://kwikbyte.com/KB9202_description_new.htm>
+	  <http://www.kwikbyte.com/KB9202.html>
 
 config MACH_PICOTUX2XX
 	bool "picotux 200"
-- 
1.7.2.1

