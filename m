Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753161Ab1GUQIV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jul 2011 12:08:21 -0400
Received: from mail-fx0-f52.google.com ([209.85.161.52]:61766 "EHLO
	mail-fx0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752762Ab1GUQIT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jul 2011 12:08:19 -0400
From: Marek Vasut <marek.vasut@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org, kernel@pengutronix.de,
        Marek Vasut <marek.vasut@gmail.com>
Subject: [PATCH] iMX28: Fix emi_ddr_open pinmux
Date: Thu, 21 Jul 2011 18:08:10 +0200
Message-Id: <1311264490-5485-1-git-send-email-marek.vasut@gmail.com>
X-Mailer: git-send-email 1.7.5.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Marek Vasut <marek.vasut@gmail.com>
---
 arch/arm/mach-mxs/include/mach/iomux-mx28.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/arm/mach-mxs/include/mach/iomux-mx28.h b/arch/arm/mach-mxs/include/mach/iomux-mx28.h
index f50fefd..1a95ecd 100644
--- a/arch/arm/mach-mxs/include/mach/iomux-mx28.h
+++ b/arch/arm/mach-mxs/include/mach/iomux-mx28.h
@@ -203,7 +203,7 @@
 #define MX28_PAD_EMI_WEN__EMI_WEN			MXS_IOMUX_PAD_NAKED(6, 21, PAD_MUXSEL_0)
 #define MX28_PAD_EMI_CE0N__EMI_CE0N			MXS_IOMUX_PAD_NAKED(6, 22, PAD_MUXSEL_0)
 #define MX28_PAD_EMI_CE1N__EMI_CE1N			MXS_IOMUX_PAD_NAKED(6, 23, PAD_MUXSEL_0)
-#define MX28_PAD_EMI_CKE__EMI_CKE			MXS_IOMUX_PAD_NAKED(6, 24, PAD_MUXSEL_0)
+#define MX28_PAD_EMI_CKE__EMI_CKE			MXS_IOMUX_PAD_NAKED(6, 26, PAD_MUXSEL_0)
 
 /* MUXSEL_1 */
 #define MX28_PAD_GPMI_D00__SSP1_D0			MXS_IOMUX_PAD_NAKED(0,  0, PAD_MUXSEL_1)
-- 
1.7.5.3

