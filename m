Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757344Ab0IBV0E (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Sep 2010 17:26:04 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:39302 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757224Ab0IBVGp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Sep 2010 17:06:45 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=vvOcHngJrWZt8ZpIU7nBCLwPIEdYZZF+DNXLWSsf8xORL4U63W6rD5dqk8pFqaRoxu
         RTL8TLkcB4mkk1VT86y04B5HolEx2iG6XsmcFaj/cPO2beJ17dxrH3PtSEkitcjvWnTE
         0ZujJsPk5ydm5tstBZZfF5YBlXfkWu70GKIy8=
From: "Justin P. Mattock" <justinmattock@gmail.com>
To: trivial@kernel.org
Cc: linux-alpha@vger.kernel.org, linux-kernel@vger.kernel.org, jkosina@suse.cz,
        "Justin P. Mattock" <justinmattock@gmail.com>
Subject: [PATCH 04/91] arch/arm/mach-omap1/Kconfig Update broken web addresses in the arch directory.
Date: Thu,  2 Sep 2010 14:06:35 -0700
Message-Id: <1283461606-7803-5-git-send-email-justinmattock@gmail.com>
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
 arch/arm/mach-omap1/Kconfig |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/arm/mach-omap1/Kconfig b/arch/arm/mach-omap1/Kconfig
index 3b02d3b..4ec4c2e 100644
--- a/arch/arm/mach-omap1/Kconfig
+++ b/arch/arm/mach-omap1/Kconfig
@@ -119,8 +119,8 @@ config MACH_OMAP_PALMZ71
 	help
 	 Support for the Palm Zire71 PDA. To boot the kernel,
 	 you'll need a PalmOS compatible bootloader; check out
-	 http://hackndev.com/palm/z71 for more information.
-	 Say Y here if you have such a PDA, say N otherwise.
+	 http://web.archive.org/web/*/http://old.hackndev.com/palm/z71
+	 for more information. Say Y here if you have such a PDA, say N otherwise.
 
 config MACH_OMAP_PALMTT
 	bool "Palm Tungsten|T"
@@ -128,7 +128,7 @@ config MACH_OMAP_PALMTT
 	help
 	  Support for the Palm Tungsten|T PDA. To boot the kernel, you'll
 	  need a PalmOS compatible bootloader (Garux); check out
-	  http://www.hackndev.com/palm/tt/ for more information.
+	  http://garux.sourceforge.net/ for more information.
 	  Say Y here if you have this PDA model, say N otherwise.
 
 config MACH_SX1
-- 
1.7.2.1

