Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755712Ab2JTNcD (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Oct 2012 09:32:03 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:53737 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755537Ab2JTNcA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Oct 2012 09:32:00 -0400
From: Prabhakar Lad <prabhakar.csengg@gmail.com>
To: LAK <linux-arm-kernel@lists.infradead.org>
Cc: Manjunath Hadli <manjunath.hadli@ti.com>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        LMML <linux-media@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        DLOS <davinci-linux-open-source@linux-davincidsp.com>,
        "Lad, Prabhakar" <prabhakar.lad@ti.com>, Sekhar Nori <nsekhar@ti.com>
Subject: [PATCH] ARM: dm365: replace V4L2_OUT_CAP_CUSTOM_TIMINGS with V4L2_OUT_CAP_DV_TIMINGS
Date: Sat, 20 Oct 2012 19:01:40 +0530
Message-Id: <1350739900-25065-1-git-send-email-prabhakar.lad@ti.com>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Lad, Prabhakar <prabhakar.lad@ti.com>

This patch replaces V4L2_OUT_CAP_CUSTOM_TIMINGS macro with
V4L2_OUT_CAP_DV_TIMINGS. As V4L2_OUT_CAP_CUSTOM_TIMINGS is being phased
out.

Signed-off-by: Lad, Prabhakar <prabhakar.lad@ti.com>
Signed-off-by: Manjunath Hadli <manjunath.hadli@ti.com>
Cc: Sekhar Nori <nsekhar@ti.com>
---
 This patch is based on the following patch series,
 ARM: davinci: dm365 EVM: add support for VPBE display
 (https://patchwork.kernel.org/patch/1295071/)

 arch/arm/mach-davinci/board-dm365-evm.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/arm/mach-davinci/board-dm365-evm.c b/arch/arm/mach-davinci/board-dm365-evm.c
index 2924d61..771abb5 100644
--- a/arch/arm/mach-davinci/board-dm365-evm.c
+++ b/arch/arm/mach-davinci/board-dm365-evm.c
@@ -514,7 +514,7 @@ static struct vpbe_output dm365evm_vpbe_outputs[] = {
 			.index		= 1,
 			.name		= "Component",
 			.type		= V4L2_OUTPUT_TYPE_ANALOG,
-			.capabilities	= V4L2_OUT_CAP_CUSTOM_TIMINGS,
+			.capabilities	=  V4L2_OUT_CAP_DV_TIMINGS,
 		},
 		.subdev_name	= VPBE_VENC_SUBDEV_NAME,
 		.default_mode	= "480p59_94",
-- 
1.7.4.1

