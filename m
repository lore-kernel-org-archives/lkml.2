Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933318Ab1IBD7G (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Sep 2011 23:59:06 -0400
Received: from mail-pz0-f42.google.com ([209.85.210.42]:55209 "EHLO
	mail-pz0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933164Ab1IBD66 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Sep 2011 23:58:58 -0400
From: "Leonid V. Fedorenchik" <leonidsbox@gmail.com>
To: Greg Kroah-Hartman <gregkh@suse.de>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
        Ruslan Pisarev <ruslan@rpisarev.org.ua>,
        Ilia Mirkin <imirkin@alum.mit.edu>, Joe Perches <joe@perches.com>,
        Palash Bandyopadhyay <palash.bandyopadhyay@conexant.com>,
        Hans Verkuil <hverkuil@xs4all.nl>, Arnd Bergmann <arnd@arndb.de>,
        Youquan Song <youquan.song@intel.com>, linux-kernel@vger.kernel.org,
        devel@linuxdriverproject.org,
        "Leonid V. Fedorenchik" <leonidsbox@gmail.com>
Subject: [PATCH v4 18/19] Staging: cx25821: Fix long lines in cx25821-video-upstream.c
Date: Fri,  2 Sep 2011 11:55:46 +0800
Message-Id: <1314935747-6881-19-git-send-email-leonidsbox@gmail.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1314935747-6881-1-git-send-email-leonidsbox@gmail.com>
References: <1314935747-6881-1-git-send-email-leonidsbox@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix long lines in cx25821-video-upstream.c

Signed-off-by: Leonid V. Fedorenchik <leonidsbox@gmail.com>
---
 drivers/staging/cx25821/cx25821-video-upstream.c |   16 ++++++----------
 1 files changed, 6 insertions(+), 10 deletions(-)

diff --git a/drivers/staging/cx25821/cx25821-video-upstream.c b/drivers/staging/cx25821/cx25821-video-upstream.c
index eb0172b..14a6a6c 100644
--- a/drivers/staging/cx25821/cx25821-video-upstream.c
+++ b/drivers/staging/cx25821/cx25821-video-upstream.c
@@ -40,8 +40,8 @@ MODULE_DESCRIPTION("v4l2 driver module for cx25821 based TV cards");
 MODULE_AUTHOR("Hiep Huynh <hiep.huynh@conexant.com>");
 MODULE_LICENSE("GPL");
 
-static int _intr_msk =
-	FLD_VID_SRC_RISC1 | FLD_VID_SRC_UF | FLD_VID_SRC_SYNC | FLD_VID_SRC_OPC_ERR;
+static int _intr_msk = FLD_VID_SRC_RISC1 | FLD_VID_SRC_UF | FLD_VID_SRC_SYNC |
+			FLD_VID_SRC_OPC_ERR;
 
 int cx25821_sram_channel_setup_upstream(struct cx25821_dev *dev,
 					struct sram_channel *ch,
@@ -615,14 +615,10 @@ int cx25821_video_upstream_irq(struct cx25821_dev *dev, int chan_num,
 				    odd_risc_prog_size;
 
 				rp = cx25821_update_riscprogram(dev,
-								dev->
-								_dma_virt_start_addr,
-								TOP_OFFSET,
-								line_size_in_bytes,
-								0x0,
-								singlefield_lines,
-								FIFO_DISABLE,
-								ODD_FIELD);
+					dev->_dma_virt_start_addr, TOP_OFFSET,
+					line_size_in_bytes, 0x0,
+					singlefield_lines, FIFO_DISABLE,
+					ODD_FIELD);
 
 				/* Jump to Even Risc program of 1st Frame */
 				*(rp++) = cpu_to_le32(RISC_JUMP);
-- 
1.7.0.4

