Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753088Ab1H3ETp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Aug 2011 00:19:45 -0400
Received: from mail-pz0-f42.google.com ([209.85.210.42]:49060 "EHLO
	mail-pz0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752362Ab1H3ETi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Aug 2011 00:19:38 -0400
From: "Leonid V. Fedorenchik" <leonidsbox@gmail.com>
To: Greg Kroah-Hartman <gregkh@suse.de>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
        Ruslan Pisarev <ruslan@rpisarev.org.ua>,
        Ilia Mirkin <imirkin@alum.mit.edu>, Ilya Gorskin <Revent82@gmail.com>,
        Joe Perches <joe@perches.com>,
        Palash Bandyopadhyay <palash.bandyopadhyay@conexant.com>,
        Hans Verkuil <hverkuil@xs4all.nl>, Arnd Bergmann <arnd@arndb.de>,
        Youquan Song <youquan.song@intel.com>, linux-kernel@vger.kernel.org,
        devel@linuxdriverproject.org,
        "Leonid V. Fedorenchik" <leonidsbox@gmail.com>
Subject: [PATCH v3 15/18] Staging: cx25821: Fix long lines in cx25821-video-upstream-ch2.c
Date: Tue, 30 Aug 2011 12:17:10 +0800
Message-Id: <1314677833-4689-16-git-send-email-leonidsbox@gmail.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1314677833-4689-1-git-send-email-leonidsbox@gmail.com>
References: <1314677833-4689-1-git-send-email-leonidsbox@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix long lines in cx25821-video-upstream-ch2.c

Signed-off-by: Leonid V. Fedorenchik <leonidsbox@gmail.com>
---
 .../staging/cx25821/cx25821-video-upstream-ch2.c   |   26 +++++++-------------
 1 files changed, 9 insertions(+), 17 deletions(-)

diff --git a/drivers/staging/cx25821/cx25821-video-upstream-ch2.c b/drivers/staging/cx25821/cx25821-video-upstream-ch2.c
index b281ced..08ac7c1 100644
--- a/drivers/staging/cx25821/cx25821-video-upstream-ch2.c
+++ b/drivers/staging/cx25821/cx25821-video-upstream-ch2.c
@@ -40,8 +40,8 @@ MODULE_DESCRIPTION("v4l2 driver module for cx25821 based TV cards");
 MODULE_AUTHOR("Hiep Huynh <hiep.huynh@conexant.com>");
 MODULE_LICENSE("GPL");
 
-static int _intr_msk =
-	FLD_VID_SRC_RISC1 | FLD_VID_SRC_UF | FLD_VID_SRC_SYNC | FLD_VID_SRC_OPC_ERR;
+static int _intr_msk = FLD_VID_SRC_RISC1 | FLD_VID_SRC_UF | FLD_VID_SRC_SYNC |
+			FLD_VID_SRC_OPC_ERR;
 
 static __le32 *cx25821_update_riscprogram_ch2(struct cx25821_dev *dev,
 					      __le32 *rp, unsigned int offset,
@@ -166,13 +166,9 @@ int cx25821_risc_buffer_upstream_ch2(struct cx25821_dev *dev,
 		if (UNSET != top_offset) {
 			fifo_enable = (frame == 0) ? FIFO_ENABLE : FIFO_DISABLE;
 			rp = cx25821_risc_field_upstream_ch2(dev, rp,
-							     dev->
-							     _data_buf_phys_addr_ch2
-							     + databuf_offset,
-							     top_offset, 0, bpl,
-							     odd_num_lines,
-							     fifo_enable,
-							     ODD_FIELD);
+				dev->_data_buf_phys_addr_ch2 + databuf_offset,
+				top_offset, 0, bpl, odd_num_lines, fifo_enable,
+				ODD_FIELD);
 		}
 
 		fifo_enable = FIFO_DISABLE;
@@ -571,14 +567,10 @@ int cx25821_video_upstream_irq_ch2(struct cx25821_dev *dev, int chan_num,
 				    odd_risc_prog_size;
 
 				rp = cx25821_update_riscprogram_ch2(dev,
-								    dev->
-								    _dma_virt_start_addr_ch2,
-								    TOP_OFFSET,
-								    line_size_in_bytes,
-								    0x0,
-								    singlefield_lines,
-								    FIFO_DISABLE,
-								    ODD_FIELD);
+						dev->_dma_virt_start_addr_ch2,
+						TOP_OFFSET, line_size_in_bytes,
+						0x0, singlefield_lines,
+						FIFO_DISABLE, ODD_FIELD);
 
 			       /* Jump to Even Risc program of 1st Frame */
 				*(rp++) = cpu_to_le32(RISC_JUMP);
-- 
1.7.0.4

