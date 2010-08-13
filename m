Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761333Ab0HMDhF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Aug 2010 23:37:05 -0400
Received: from mail-qy0-f174.google.com ([209.85.216.174]:53295 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751448Ab0HMDhC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Aug 2010 23:37:02 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version
         :x-mailer:content-transfer-encoding;
        b=kdiNTM1QEtR0utesRksbXCk6xfqW0H0JHo+RO8SEWfhUdSgy8bhiRG7Wh9WLpaPsKI
         6B/gVdQcBXxQyYwQbU2x+VVv4h5fPhpNBCyDy40lIxC91rkHK8f8w+7LYn5c0ZcGhPiO
         jIpDSQN6b6gXxl0mEafj6/OH2rEsIJzUn5H1I=
Subject: [PATCH] pxa: fix CI_HSYNC and CI_VSYNC MFP defines
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel <linux-kernel@vger.kernel.org>
Cc: Eric Miao <eric.y.miao@gmail.com>, Russell King <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org
Content-Type: text/plain
Date: Fri, 13 Aug 2010 11:39:07 +0800
Message-Id: <1281670747.13407.2.camel@mola>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

According to PXA3xx Processor Family Developer Manuall Vol1. section
"Pin Descriptions and Control", PXA30x and PXA31x Processor Alternate Function
Table shows the Alt FN 0 for GPIO51 is CI_HSYNC and for GPIO52 is CI_VSYNC.
This patch fixes the MFP defines and also corrects the order of MFD defines.

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 arch/arm/mach-pxa/include/mach/mfp-pxa300.h |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm/mach-pxa/include/mach/mfp-pxa300.h b/arch/arm/mach-pxa/include/mach/mfp-pxa300.h
index 7139e0d..4e12870 100644
--- a/arch/arm/mach-pxa/include/mach/mfp-pxa300.h
+++ b/arch/arm/mach-pxa/include/mach/mfp-pxa300.h
@@ -71,10 +71,10 @@
 #define GPIO46_CI_DD_7		MFP_CFG_DRV(GPIO46, AF0, DS04X)
 #define GPIO47_CI_DD_8		MFP_CFG_DRV(GPIO47, AF1, DS04X)
 #define GPIO48_CI_DD_9		MFP_CFG_DRV(GPIO48, AF1, DS04X)
-#define GPIO52_CI_HSYNC		MFP_CFG_DRV(GPIO52, AF0, DS04X)
-#define GPIO51_CI_VSYNC		MFP_CFG_DRV(GPIO51, AF0, DS04X)
 #define GPIO49_CI_MCLK		MFP_CFG_DRV(GPIO49, AF0, DS04X)
 #define GPIO50_CI_PCLK		MFP_CFG_DRV(GPIO50, AF0, DS04X)
+#define GPIO51_CI_HSYNC		MFP_CFG_DRV(GPIO51, AF0, DS04X)
+#define GPIO52_CI_VSYNC		MFP_CFG_DRV(GPIO52, AF0, DS04X)
 
 /* KEYPAD */
 #define GPIO3_KP_DKIN_6		MFP_CFG_LPM(GPIO3,   AF2, FLOAT)
-- 
1.7.2



