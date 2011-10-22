Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754097Ab1JVFtF (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Oct 2011 01:49:05 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:42321 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752911Ab1JVFtB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Oct 2011 01:49:01 -0400
From: "Leonid V. Fedorenchik" <leonidsbox@gmail.com>
To: Greg Kroah-Hartman <gregkh@suse.de>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
        Namhyung Kim <namhyung@gmail.com>,
        Palash Bandyopadhyay <palash.bandyopadhyay@conexant.com>,
        Joe Perches <joe@perches.com>, Ilia Mirkin <imirkin@alum.mit.edu>,
        Youquan Song <youquan.song@intel.com>,
        "Leonid V. Fedorenchik" <leonidsbox@gmail.com>,
        devel@linuxdriverproject.org, linux-kernel@vger.kernel.org
Subject: [PATCH 27/36] Staging: cx25821: cx25821-video-upstream.c: Fix indent
Date: Sat, 22 Oct 2011 13:43:47 +0800
Message-Id: <1319262236-6498-28-git-send-email-leonidsbox@gmail.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1319262236-6498-1-git-send-email-leonidsbox@gmail.com>
References: <1319262236-6498-1-git-send-email-leonidsbox@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Change indent of statements to use tabs and to improve readability.

Signed-off-by: Leonid V. Fedorenchik <leonidsbox@gmail.com>
---
 drivers/staging/cx25821/cx25821-video-upstream.c |   24 ++++++++-------------
 1 files changed, 9 insertions(+), 15 deletions(-)

diff --git a/drivers/staging/cx25821/cx25821-video-upstream.c b/drivers/staging/cx25821/cx25821-video-upstream.c
index 5daa4d5..0cf2179 100644
--- a/drivers/staging/cx25821/cx25821-video-upstream.c
+++ b/drivers/staging/cx25821/cx25821-video-upstream.c
@@ -136,7 +136,7 @@ static __le32 *cx25821_risc_field_upstream(struct cx25821_dev *dev, __le32 * rp,
 {
 	unsigned int line, i;
 	struct sram_channel *sram_ch =
-	   dev->channels[dev->_channel_upstream_select].sram_channels;
+		dev->channels[dev->_channel_upstream_select].sram_channels;
 	int dist_betwn_starts = bpl * 2;
 
 	/* sync instruction */
@@ -214,13 +214,9 @@ int cx25821_risc_buffer_upstream(struct cx25821_dev *dev,
 		if (UNSET != top_offset) {
 			fifo_enable = (frame == 0) ? FIFO_ENABLE : FIFO_DISABLE;
 			rp = cx25821_risc_field_upstream(dev, rp,
-							 dev->
-							 _data_buf_phys_addr +
-							 databuf_offset,
-							 top_offset, 0, bpl,
-							 odd_num_lines,
-							 fifo_enable,
-							 ODD_FIELD);
+					dev->_data_buf_phys_addr +
+					databuf_offset, top_offset, 0, bpl,
+					odd_num_lines, fifo_enable, ODD_FIELD);
 		}
 
 		fifo_enable = FIFO_DISABLE;
@@ -255,7 +251,7 @@ int cx25821_risc_buffer_upstream(struct cx25821_dev *dev,
 void cx25821_stop_upstream_video_ch1(struct cx25821_dev *dev)
 {
 	struct sram_channel *sram_ch =
-	   dev->channels[VID_UPSTREAM_SRAM_CHANNEL_I].sram_channels;
+		dev->channels[VID_UPSTREAM_SRAM_CHANNEL_I].sram_channels;
 	u32 tmp = 0;
 
 	if (!dev->_is_running) {
@@ -829,14 +825,12 @@ int cx25821_vidupstream_init_ch1(struct cx25821_dev *dev, int channel_select,
 	if (strcmp(dev->input_filename, "") == 0) {
 		if (dev->_isNTSC) {
 			dev->_filename =
-			    (dev->_pixel_format ==
-			     PIXEL_FRMT_411) ? "/root/vid411.yuv" :
-			    "/root/vidtest.yuv";
+				(dev->_pixel_format == PIXEL_FRMT_411) ?
+				"/root/vid411.yuv" : "/root/vidtest.yuv";
 		} else {
 			dev->_filename =
-			    (dev->_pixel_format ==
-			     PIXEL_FRMT_411) ? "/root/pal411.yuv" :
-			    "/root/pal422.yuv";
+				(dev->_pixel_format == PIXEL_FRMT_411) ?
+				"/root/pal411.yuv" : "/root/pal422.yuv";
 		}
 	}
 
-- 
1.7.0.4

