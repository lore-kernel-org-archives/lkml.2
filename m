Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752769Ab1BYGJ5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Feb 2011 01:09:57 -0500
Received: from mail-px0-f174.google.com ([209.85.212.174]:44551 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751899Ab1BYGJ4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Feb 2011 01:09:56 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=ZUg+9GmZ3swXiinpYKPHD16Oy3IR6c5k9ZhlpmupZCt8fZ2hgQ5PxCW/OYmK+txuyi
         +OidOmMBbsiMPchKOZXVCJapGAxCNc8Hl7bkqjMX2zcUQPJH8aXKZlvtxeRHF5zLEqyo
         pe184+7YLepBdN4ZsUwmk8LwBXHz9llvQwntA=
From: "Justin P. Mattock" <justinmattock@gmail.com>
To: trivial@kernel.org
Cc: tony@atomide.com, linux@arm.linux.org.uk, linux-kernel@vger.kernel.org,
        "Justin P. Mattock" <justinmattock@gmail.com>
Subject: [PATCH 01/21]arch:arm:Kconfig remove one to many l's in the word.
Date: Thu, 24 Feb 2011 22:09:35 -0800
Message-Id: <1298614175-3456-1-git-send-email-justinmattock@gmail.com>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The patch below removes an extra "l" in the word.

Signed-off-by: Justin P. Mattock <justinmattock@gmail.com>

---
 arch/arm/plat-omap/Kconfig |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/arm/plat-omap/Kconfig b/arch/arm/plat-omap/Kconfig
index b6333ae..cd5f993 100644
--- a/arch/arm/plat-omap/Kconfig
+++ b/arch/arm/plat-omap/Kconfig
@@ -54,7 +54,7 @@ config OMAP_SMARTREFLEX
 	  user must write 1 to
 		/debug/voltage/vdd_<X>/smartreflex/autocomp,
 	  where X is mpu or core for OMAP3.
-	  Optionallly autocompensation can be enabled in the kernel
+	  Optionally autocompensation can be enabled in the kernel
 	  by default during system init via the enable_on_init flag
 	  which an be passed as platform data to the smartreflex driver.
 
-- 
1.7.4.1

