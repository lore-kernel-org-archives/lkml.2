Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757304Ab0IBVG6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Sep 2010 17:06:58 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:57119 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757243Ab0IBVGy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Sep 2010 17:06:54 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=Fx+g/JeN1uZLW4SLlOf519HMGfs02QF0Qm6Nt+wJg48JMQlU/dZkEkjV6TnSaQblrZ
         MmKrWjRfhE7hUend95LVDMCorb7bQki71mmKQp4+Ln3jY6G6cjG637Xc+rQcuFQ22U0o
         8C34tDyONJARKTnsruI3jKl585Masfwh9Mex0=
From: "Justin P. Mattock" <justinmattock@gmail.com>
To: trivial@kernel.org
Cc: linux-alpha@vger.kernel.org, linux-kernel@vger.kernel.org, jkosina@suse.cz,
        "Justin P. Mattock" <justinmattock@gmail.com>
Subject: [PATCH 05/91] arch/arm/mach-sa1100/Kconfig Update broken web addresses in the arch directory.
Date: Thu,  2 Sep 2010 14:06:36 -0700
Message-Id: <1283461606-7803-6-git-send-email-justinmattock@gmail.com>
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
 arch/arm/mach-sa1100/Kconfig |    7 ++++---
 1 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/arch/arm/mach-sa1100/Kconfig b/arch/arm/mach-sa1100/Kconfig
index fd4c52b..264ee98 100644
--- a/arch/arm/mach-sa1100/Kconfig
+++ b/arch/arm/mach-sa1100/Kconfig
@@ -90,7 +90,8 @@ config SA1100_JORNADA720
 	# FIXME: select CPU_FREQ_SA11x0
 	help
 	  Say Y here if you want to build a kernel for the HP Jornada 720
-	  handheld computer.  See <http://www.hp.com/jornada/products/720>
+	  handheld computer.  See <http://h10025.www1.hp.com/ewfrf/wc/
+	  product?product=61677&cc=us&lc=en&dlc=en&product=61677#>
 	  for details.
 
 config SA1100_JORNADA720_SSP
@@ -108,7 +109,7 @@ config SA1100_HACKKIT
 	select CPU_FREQ_SA1100
 	help
 	  Say Y here to support the HackKit Core CPU Board
-	  <http://hackkit.eletztrick.de>;
+	  <http://web.archive.org/web/*/http://hackkit.eletztrick.de>;
 
 config SA1100_LART
 	bool "LART"
@@ -145,7 +146,7 @@ config SA1100_SIMPAD
 	  FLASH. The SL4 version got 64 MB RAM and 32 MB FLASH and a
 	  PCMCIA-Slot. The version for the Germany Telecom (DTAG) is the same
 	  like CL4 in additional it has a PCMCIA-Slot. For more information
-	  visit <http://www.my-siemens.com/> or <http://www.siemens.ch/>.
+	  visit <http://www.siemens.ch/>.
 
 config SA1100_SSP
 	tristate "Generic PIO SSP"
-- 
1.7.2.1

