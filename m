Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756038Ab2LNOO6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Dec 2012 09:14:58 -0500
Received: from co9ehsobe003.messaging.microsoft.com ([207.46.163.26]:37778
	"EHLO co9outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755790Ab2LNOO4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Dec 2012 09:14:56 -0500
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: 0
X-BigFish: VS0(zzzz1de0h1202h1e76h1d1ah1d2ahzz8275bhz2dh2a8h668h839he5bhf0ah1288h12a5h12a9h12bdh12e5h137ah139eh13b6h1441h1504h1537h162dh1631h1758h1155h)
From: Varun Sethi <Varun.Sethi@freescale.com>
To: <joerg.roedel@amd.com>, <iommu@lists.linux-foundation.org>,
        <linuxppc-dev@lists.ozlabs.org>, <linux-kernel@vger.kernel.org>,
        <timur@freescale.com>, <scottwood@freescale.com>
CC: Varun Sethi <Varun.Sethi@freescale.com>
Subject: [PATCH 2/4] iommu/fsl: Add PAMU bypass enable register to ccsr_guts structure.
Date: Fri, 14 Dec 2012 19:23:52 +0530
Message-ID: <1355493232-21821-1-git-send-email-Varun.Sethi@freescale.com>
X-Mailer: git-send-email 1.7.4.1
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

PAMU bypass enable register added to the ccsr_guts structure.

(This patch has already been applied by Kumar Gala in the linuxppc tree next branch)

Signed-off-by: Timur Tabi <timur@freescale.com>
Signed-off-by: Varun Sethi <Varun.Sethi@freescale.com>
---
 arch/powerpc/include/asm/fsl_guts.h |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/arch/powerpc/include/asm/fsl_guts.h b/arch/powerpc/include/asm/fsl_guts.h
index dd5ba2c..77ced0b 100644
--- a/arch/powerpc/include/asm/fsl_guts.h
+++ b/arch/powerpc/include/asm/fsl_guts.h
@@ -71,7 +71,9 @@ struct ccsr_guts {
 	u8	res0c4[0x224 - 0xc4];
 	__be32  iodelay1;	/* 0x.0224 - IO delay control register 1 */
 	__be32  iodelay2;	/* 0x.0228 - IO delay control register 2 */
-	u8	res22c[0x800 - 0x22c];
+	u8	res22c[0x604 - 0x22c];
+	__be32	pamubypenr; 	/* 0x.604 - PAMU bypass enable register */
+	u8	res608[0x800 - 0x608];
 	__be32	clkdvdr;	/* 0x.0800 - Clock Divide Register */
 	u8	res804[0x900 - 0x804];
 	__be32	ircr;		/* 0x.0900 - Infrared Control Register */
-- 
1.7.4.1


