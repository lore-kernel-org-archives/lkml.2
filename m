Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755248Ab2IXH5M (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Sep 2012 03:57:12 -0400
Received: from na3sys009aog112.obsmtp.com ([74.125.149.207]:59759 "EHLO
	na3sys009aog112.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752932Ab2IXH5K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Sep 2012 03:57:10 -0400
From: Peter Ujfalusi <peter.ujfalusi@ti.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@ti.com>, Takashi Iwai <tiwai@suse.de>
Cc: alsa-devel@alsa-project.org, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, Vinod Koul <vinod.koul@intel.com>,
        Kukjin Kim <kgene.kim@samsung.com>
Subject: [PATCH 0/2] dmaengine: Fix compillation issues in device_prep_dma_cyclic()
Date: Mon, 24 Sep 2012 10:58:03 +0300
Message-Id: <1348473485-5081-1-git-send-email-peter.ujfalusi@ti.com>
X-Mailer: git-send-email 1.7.12
In-Reply-To: <20120924133923.130c4db72aa8105cb5647d7a@canb.auug.org.au>
References: <20120924133923.130c4db72aa8105cb5647d7a@canb.auug.org.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

The reason for the breakage is the patch 1 got lost somewhere in the process.
I also greped the whole tree for device_prep_dma_cyclic() and the second patch
is the result of that.

PS: I did build tested the series on ARM (OMAP), x86_32, x86_64 but not for ppc
for sure.

Regards,
Peter
---
Peter Ujfalusi (2):
  dmaengine: Add flags parameter to dmaengine_prep_dma_cyclic()
  ARM: SAMSUNG: dma-ops: Fix dmaengine_prep_dma_cyclic() parameter list

 arch/arm/plat-samsung/dma-ops.c | 3 ++-
 include/linux/dmaengine.h       | 3 ++-
 sound/soc/soc-dmaengine-pcm.c   | 6 +++++-
 3 files changed, 9 insertions(+), 3 deletions(-)

-- 
1.7.12

