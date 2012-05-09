Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759389Ab2EINQr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2012 09:16:47 -0400
Received: from mail-wi0-f178.google.com ([209.85.212.178]:65017 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759379Ab2EINQo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2012 09:16:44 -0400
Date: Wed, 9 May 2012 15:16:38 +0200
From: Christoph Fritz <chf.fritz@googlemail.com>
To: Sascha Hauer <kernel@pengutronix.de>,
        Russell King <linux@arm.linux.org.uk>,
        Fabio Estevam <fabio.estevam@freescale.com>
Cc: Christian Hemp <c.hemp@phytec.de>, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, "Hans J. Koch" <hjk@hansjkoch.de>
Subject: [PATCH] ARM: mx35: add WEIM register addresses
Message-ID: <20120509131638.GA2057@lovely.krouter>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


This patch adds WEIM register addresses to mx35 platform header file.

Signed-off-by: Christoph Fritz <chf.fritz@googlemail.com>
Signed-off-by: Christian Hemp <c.hemp@phytec.de>
---
 arch/arm/plat-mxc/include/mach/mx35.h |    5 +++++
 1 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/arch/arm/plat-mxc/include/mach/mx35.h b/arch/arm/plat-mxc/include/mach/mx35.h
index 80965a9..8b8f424 100644
--- a/arch/arm/plat-mxc/include/mach/mx35.h
+++ b/arch/arm/plat-mxc/include/mach/mx35.h
@@ -111,6 +111,11 @@
 #define MX35_EMI_CTL_BASE_ADDR			(MX35_X_MEMC_BASE_ADDR + 0x4000)
 #define MX35_PCMCIA_CTL_BASE_ADDR		MX35_EMI_CTL_BASE_ADDR
 
+#define MX35_WEIM_CSCRx_BASE_ADDR(cs)	(MX35_WEIM_BASE_ADDR + (cs) * 0x10)
+#define MX35_WEIM_CSCRxU(cs)		(MX35_WEIM_CSCRx_BASE_ADDR(cs))
+#define MX35_WEIM_CSCRxL(cs)		(MX35_WEIM_CSCRx_BASE_ADDR(cs) + 0x4)
+#define MX35_WEIM_CSCRxA(cs)		(MX35_WEIM_CSCRx_BASE_ADDR(cs) + 0x8)
+
 #define MX35_NFC_BASE_ADDR		0xbb000000
 #define MX35_PCMCIA_MEM_BASE_ADDR	0xbc000000
 
-- 
1.7.2.5


