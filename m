Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753935Ab1JVFs2 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Oct 2011 01:48:28 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:42321 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753031Ab1JVFsZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Oct 2011 01:48:25 -0400
From: "Leonid V. Fedorenchik" <leonidsbox@gmail.com>
To: Greg Kroah-Hartman <gregkh@suse.de>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
        Namhyung Kim <namhyung@gmail.com>,
        Palash Bandyopadhyay <palash.bandyopadhyay@conexant.com>,
        Joe Perches <joe@perches.com>, Ilia Mirkin <imirkin@alum.mit.edu>,
        Youquan Song <youquan.song@intel.com>,
        "Leonid V. Fedorenchik" <leonidsbox@gmail.com>,
        devel@linuxdriverproject.org, linux-kernel@vger.kernel.org
Subject: [PATCH 22/36] Staging: cx25821: cx25821-video-upstream-ch2.c: Fix indent
Date: Sat, 22 Oct 2011 13:43:42 +0800
Message-Id: <1319262236-6498-23-git-send-email-leonidsbox@gmail.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1319262236-6498-1-git-send-email-leonidsbox@gmail.com>
References: <1319262236-6498-1-git-send-email-leonidsbox@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Change indent of statements with (less than 8) spaces to indent with
tabs.

Signed-off-by: Leonid V. Fedorenchik <leonidsbox@gmail.com>
---
 .../staging/cx25821/cx25821-video-upstream-ch2.c   |   12 ++++++------
 1 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/staging/cx25821/cx25821-video-upstream-ch2.c b/drivers/staging/cx25821/cx25821-video-upstream-ch2.c
index e5bc68a..63cc26c 100644
--- a/drivers/staging/cx25821/cx25821-video-upstream-ch2.c
+++ b/drivers/staging/cx25821/cx25821-video-upstream-ch2.c
@@ -85,7 +85,7 @@ static __le32 *cx25821_risc_field_upstream_ch2(struct cx25821_dev *dev,
 {
 	unsigned int line, i;
 	struct sram_channel *sram_ch =
-	   dev->channels[dev->_channel2_upstream_select].sram_channels;
+		dev->channels[dev->_channel2_upstream_select].sram_channels;
 	int dist_betwn_starts = bpl * 2;
 
 	/* sync instruction */
@@ -203,7 +203,7 @@ int cx25821_risc_buffer_upstream_ch2(struct cx25821_dev *dev,
 void cx25821_stop_upstream_video_ch2(struct cx25821_dev *dev)
 {
 	struct sram_channel *sram_ch =
-	   dev->channels[VID_UPSTREAM_SRAM_CHANNEL_J].sram_channels;
+		dev->channels[VID_UPSTREAM_SRAM_CHANNEL_J].sram_channels;
 	u32 tmp = 0;
 
 	if (!dev->_is_running_ch2) {
@@ -325,7 +325,7 @@ int cx25821_get_frame_ch2(struct cx25821_dev *dev, struct sram_channel *sram_ch)
 			    && dev->_data_buf_virt_addr_ch2 != NULL) {
 				memcpy((void *)(dev->_data_buf_virt_addr_ch2 +
 						frame_offset / 4), mybuf,
-				       vfs_read_retval);
+						vfs_read_retval);
 			}
 
 			file_offset += vfs_read_retval;
@@ -419,7 +419,7 @@ int cx25821_openfile_ch2(struct cx25821_dev *dev, struct sram_channel *sram_ch)
 					memcpy((void *)(dev->
 							_data_buf_virt_addr_ch2
 							+ offset / 4), mybuf,
-					       vfs_read_retval);
+							vfs_read_retval);
 				}
 
 				offset += vfs_read_retval;
@@ -563,8 +563,8 @@ int cx25821_video_upstream_irq_ch2(struct cx25821_dev *dev, int chan_num,
 				else
 					line_size_in_bytes = Y422_LINE_SZ;
 				risc_phys_jump_addr =
-				    dev->_dma_phys_start_addr_ch2 +
-				    odd_risc_prog_size;
+					dev->_dma_phys_start_addr_ch2 +
+					odd_risc_prog_size;
 
 				rp = cx25821_update_riscprogram_ch2(dev,
 						dev->_dma_virt_start_addr_ch2,
-- 
1.7.0.4

