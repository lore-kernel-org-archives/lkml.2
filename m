Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933286Ab1IBD6r (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Sep 2011 23:58:47 -0400
Received: from mail-yi0-f46.google.com ([209.85.218.46]:43802 "EHLO
	mail-yi0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933168Ab1IBD6m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Sep 2011 23:58:42 -0400
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
Subject: [PATCH v4 15/19] Staging: cx25821: Fix wrong line endings in cx25821-video-upstream-ch2.c
Date: Fri,  2 Sep 2011 11:55:43 +0800
Message-Id: <1314935747-6881-16-git-send-email-leonidsbox@gmail.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1314935747-6881-1-git-send-email-leonidsbox@gmail.com>
References: <1314935747-6881-1-git-send-email-leonidsbox@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Change obscure line endings to less obscure ones. Rationale: improve
readability.

Signed-off-by: Leonid V. Fedorenchik <leonidsbox@gmail.com>
---
 .../staging/cx25821/cx25821-video-upstream-ch2.c   |   24 +++++++------------
 1 files changed, 9 insertions(+), 15 deletions(-)

diff --git a/drivers/staging/cx25821/cx25821-video-upstream-ch2.c b/drivers/staging/cx25821/cx25821-video-upstream-ch2.c
index b02dbe0..b281ced 100644
--- a/drivers/staging/cx25821/cx25821-video-upstream-ch2.c
+++ b/drivers/staging/cx25821/cx25821-video-upstream-ch2.c
@@ -179,17 +179,14 @@ int cx25821_risc_buffer_upstream_ch2(struct cx25821_dev *dev,
 
 	       /* Even field */
 		rp = cx25821_risc_field_upstream_ch2(dev, rp,
-						     dev->
-						     _data_buf_phys_addr_ch2 +
-						     databuf_offset,
-						     bottom_offset, 0x200, bpl,
-						     singlefield_lines,
-						     fifo_enable, EVEN_FIELD);
+				dev->_data_buf_phys_addr_ch2 + databuf_offset,
+				bottom_offset, 0x200, bpl, singlefield_lines,
+				fifo_enable, EVEN_FIELD);
 
 		if (frame == 0) {
 			risc_flag = RISC_CNT_RESET;
-			risc_phys_jump_addr =
-			    dev->_dma_phys_start_addr_ch2 + risc_program_size;
+			risc_phys_jump_addr = dev->_dma_phys_start_addr_ch2 +
+					risc_program_size;
 		} else {
 			risc_flag = RISC_CNT_INC;
 			risc_phys_jump_addr = dev->_dma_phys_start_addr_ch2;
@@ -511,9 +508,8 @@ static int cx25821_upstream_buffer_prepare_ch2(struct cx25821_dev *dev,
 		return ret;
 
 	/* Creating RISC programs */
-	ret =
-	    cx25821_risc_buffer_upstream_ch2(dev, dev->pci, 0, bpl,
-					     dev->_lines_count_ch2);
+	ret = cx25821_risc_buffer_upstream_ch2(dev, dev->pci, 0, bpl,
+						dev->_lines_count_ch2);
 	if (ret < 0) {
 		pr_info("Failed creating Video Upstream Risc programs!\n");
 		goto error;
@@ -806,8 +802,7 @@ int cx25821_vidupstream_init_ch2(struct cx25821_dev *dev, int channel_select,
 		}
 	}
 
-	retval =
-	    cx25821_sram_channel_setup_upstream(dev, sram_ch,
+	retval = cx25821_sram_channel_setup_upstream(dev, sram_ch,
 						dev->_line_size_ch2, 0);
 
 	/* setup fifo + format */
@@ -817,8 +812,7 @@ int cx25821_vidupstream_init_ch2(struct cx25821_dev *dev, int channel_select,
 	dev->upstream_databuf_size_ch2 = data_frame_size * 2;
 
 	/* Allocating buffers and prepare RISC program */
-	retval =
-	    cx25821_upstream_buffer_prepare_ch2(dev, sram_ch,
+	retval = cx25821_upstream_buffer_prepare_ch2(dev, sram_ch,
 						dev->_line_size_ch2);
 	if (retval < 0) {
 		pr_err("%s: Failed to set up Video upstream buffers!\n",
-- 
1.7.0.4

