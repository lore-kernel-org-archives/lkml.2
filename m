Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755539Ab0LTKsz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Dec 2010 05:48:55 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:38927 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754683Ab0LTKsv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Dec 2010 05:48:51 -0500
From: Sascha Hauer <s.hauer@pengutronix.de>
To: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, Samuel Ortiz <sameo@linux.intel.com>,
        liu.y.victor@gmail.com, B02280@freescale.com,
        Sascha Hauer <s.hauer@pengutronix.de>
Subject: [PATCH 2/9] ARM i.MX51: rename IPU irqs
Date: Mon, 20 Dec 2010 11:48:40 +0100
Message-Id: <1292842127-21406-3-git-send-email-s.hauer@pengutronix.de>
X-Mailer: git-send-email 1.7.2.3
In-Reply-To: <1292842127-21406-1-git-send-email-s.hauer@pengutronix.de>
References: <1292842127-21406-1-git-send-email-s.hauer@pengutronix.de>
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: sha@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Sascha Hauer <s.hauer@pengutronix.de>
---
 arch/arm/plat-mxc/include/mach/mx51.h |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm/plat-mxc/include/mach/mx51.h b/arch/arm/plat-mxc/include/mach/mx51.h
index fa3a2a5..873807f 100644
--- a/arch/arm/plat-mxc/include/mach/mx51.h
+++ b/arch/arm/plat-mxc/include/mach/mx51.h
@@ -251,8 +251,8 @@
 #define MX51_MXC_INT_IOMUX		7
 #define MX51_INT_NFC			8
 #define MX51_MXC_INT_VPU		9
-#define MX51_MXC_INT_IPU_ERR		10
-#define MX51_MXC_INT_IPU_SYN		11
+#define MX51_INT_IPU_ERR		10
+#define MX51_INT_IPU_SYN		11
 #define MX51_MXC_INT_GPU		12
 #define MX51_MXC_INT_RESV13		13
 #define MX51_MXC_INT_USB_H1		14
-- 
1.7.2.3

