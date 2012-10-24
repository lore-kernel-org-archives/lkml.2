Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965279Ab2JXPez (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2012 11:34:55 -0400
Received: from eusmtp01.atmel.com ([212.144.249.242]:11219 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935160Ab2JXPeu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2012 11:34:50 -0400
From: Nicolas Ferre <nicolas.ferre@atmel.com>
To: <plagnioj@jcrosoft.com>, <ludovic.desroches@atmel.com>
CC: <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        <nicolas.ferre@atmel.com>, <voice.shen@atmel.com>,
        <marek.belisko@open-nandra.com>, <ivan.shugov@gmail.com>,
        <josh.wu@atmel.com>
Subject: [PATCH 8/8] ARM: at91: drop duplicated config SOC_AT91SAM9 entry
Date: Wed, 24 Oct 2012 17:33:57 +0200
Message-ID: <08bd4ab3897a5b06b4eb5cf3c00532ba38305be4.1351092432.git.nicolas.ferre@atmel.com>
X-Mailer: git-send-email 1.7.11.3
In-Reply-To: <cover.1351092432.git.nicolas.ferre@atmel.com>
References: <cover.1351092432.git.nicolas.ferre@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>

Signed-off-by: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
Acked-by: Nicolas Ferre <nicolas.ferre@atmel.com>
---
 arch/arm/mach-at91/Kconfig | 10 ++--------
 1 file changed, 2 insertions(+), 8 deletions(-)

diff --git a/arch/arm/mach-at91/Kconfig b/arch/arm/mach-at91/Kconfig
index b142071..0436242 100644
--- a/arch/arm/mach-at91/Kconfig
+++ b/arch/arm/mach-at91/Kconfig
@@ -21,19 +21,13 @@ config SOC_AT91SAM9
 	bool
 	select CPU_ARM926T
 	select GENERIC_CLOCKEVENTS
+	select MULTI_IRQ_HANDLER
+	select SPARSE_IRQ
 
 menu "Atmel AT91 System-on-Chip"
 
 comment "Atmel AT91 Processor"
 
-config SOC_AT91SAM9
-	bool
-	select AT91_SAM9_SMC
-	select AT91_SAM9_TIME
-	select CPU_ARM926T
-	select MULTI_IRQ_HANDLER
-	select SPARSE_IRQ
-
 config SOC_AT91RM9200
 	bool "AT91RM9200"
 	select CPU_ARM920T
-- 
1.7.11.3

