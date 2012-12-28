Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754862Ab2L1TXx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Dec 2012 14:23:53 -0500
Received: from juliette.telenet-ops.be ([195.130.137.74]:38044 "EHLO
	juliette.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754843Ab2L1TXt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Dec 2012 14:23:49 -0500
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: linux-arch@vger.kernel.org, Marek Szyprowski <m.szyprowski@samsung.com>,
        linux-kernel@vger.kernel.org, linux-media@vger.kernel.org
Cc: linux-m68k@vger.kernel.org, Geert Uytterhoeven <geert@linux-m68k.org>,
        Chen Liqin <liqin.chen@sunplusct.com>, Lennox Wu <lennox.wu@gmail.com>
Subject: [PATCH 2/4] score: Remove unneeded <asm/dma-mapping.h>
Date: Fri, 28 Dec 2012 20:23:32 +0100
Message-Id: <1356722614-18224-3-git-send-email-geert@linux-m68k.org>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <CAMuHMdVPBUzN8fsNHFzrEqev9BsvVCVR2fWySCOecjVA-J1qjg@mail.gmail.com>
References: <CAMuHMdVPBUzN8fsNHFzrEqev9BsvVCVR2fWySCOecjVA-J1qjg@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It just includes <asm-generic/dma-mapping-broken.h>, which is already
handled by <linux/dma-mapping.h> for the !CONFIG_HAS_DMA case (score sets
CONFIG_NO_DMA=y).

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Chen Liqin <liqin.chen@sunplusct.com>
Cc: Lennox Wu <lennox.wu@gmail.com>
---
 arch/score/include/asm/dma-mapping.h |    6 ------
 1 files changed, 0 insertions(+), 6 deletions(-)
 delete mode 100644 arch/score/include/asm/dma-mapping.h

diff --git a/arch/score/include/asm/dma-mapping.h b/arch/score/include/asm/dma-mapping.h
deleted file mode 100644
index f9c0193..0000000
--- a/arch/score/include/asm/dma-mapping.h
+++ /dev/null
@@ -1,6 +0,0 @@
-#ifndef _ASM_SCORE_DMA_MAPPING_H
-#define _ASM_SCORE_DMA_MAPPING_H
-
-#include <asm-generic/dma-mapping-broken.h>
-
-#endif /* _ASM_SCORE_DMA_MAPPING_H */
-- 
1.7.0.4

