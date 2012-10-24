Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933383Ab2JXMcO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2012 08:32:14 -0400
Received: from mail-da0-f46.google.com ([209.85.210.46]:46716 "EHLO
	mail-da0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755645Ab2JXMcM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2012 08:32:12 -0400
From: Prabhakar Lad <prabhakar.csengg@gmail.com>
To: DLOS <davinci-linux-open-source@linux.davincidsp.com>,
        LAK <linux-arm-kernel@lists.infradead.org>
Cc: LKML <linux-kernel@vger.kernel.org>, LMML <linux-media@vger.kernel.org>,
        "Lad, Prabhakar" <prabhakar.lad@ti.com>,
        Manjunath Hadli <manjunath.hadli@ti.com>, Sekhar Nori <nsekhar@ti.com>,
        Sergei Shtylyov <sshtylyov@mvista.com>
Subject: [PATCH v3] ARM: davinci: dm365 evm: replace V4L2_OUT_CAP_CUSTOM_TIMINGS with V4L2_OUT_CAP_DV_TIMINGS
Date: Wed, 24 Oct 2012 18:00:47 +0530
Message-Id: <1351081847-4061-1-git-send-email-prabhakar.lad@ti.com>
X-Mailer: git-send-email 1.7.0.4
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
Cc: Sergei Shtylyov <sshtylyov@mvista.com>
---
 This patch is based on the following patch series,
 ARM: davinci: dm365 EVM: add support for VPBE display
 (https://patchwork.kernel.org/patch/1295071/)

 Changes for v3:
 1: Changed the commit header appropriately as pointed by
    Sekhar and Sergei.
 Changes for v2:
 1: Fixed code alignment as pointed by Sergei.

 arch/arm/mach-davinci/board-dm365-evm.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/arm/mach-davinci/board-dm365-evm.c b/arch/arm/mach-davinci/board-dm365-evm.c
index 2924d61..8519d2d 100644
--- a/arch/arm/mach-davinci/board-dm365-evm.c
+++ b/arch/arm/mach-davinci/board-dm365-evm.c
@@ -514,7 +514,7 @@ static struct vpbe_output dm365evm_vpbe_outputs[] = {
 			.index		= 1,
 			.name		= "Component",
 			.type		= V4L2_OUTPUT_TYPE_ANALOG,
-			.capabilities	= V4L2_OUT_CAP_CUSTOM_TIMINGS,
+			.capabilities	= V4L2_OUT_CAP_DV_TIMINGS,
 		},
 		.subdev_name	= VPBE_VENC_SUBDEV_NAME,
 		.default_mode	= "480p59_94",
-- 
1.7.0.4

