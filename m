Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753967Ab1JVFsf (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Oct 2011 01:48:35 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:42321 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753031Ab1JVFsc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Oct 2011 01:48:32 -0400
From: "Leonid V. Fedorenchik" <leonidsbox@gmail.com>
To: Greg Kroah-Hartman <gregkh@suse.de>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
        Namhyung Kim <namhyung@gmail.com>,
        Palash Bandyopadhyay <palash.bandyopadhyay@conexant.com>,
        Joe Perches <joe@perches.com>, Ilia Mirkin <imirkin@alum.mit.edu>,
        Youquan Song <youquan.song@intel.com>,
        "Leonid V. Fedorenchik" <leonidsbox@gmail.com>,
        devel@linuxdriverproject.org, linux-kernel@vger.kernel.org
Subject: [PATCH 23/36] Staging: cx25821: cx25821-video-upsstream-ch2.c: Move operators
Date: Sat, 22 Oct 2011 13:43:43 +0800
Message-Id: <1319262236-6498-24-git-send-email-leonidsbox@gmail.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1319262236-6498-1-git-send-email-leonidsbox@gmail.com>
References: <1319262236-6498-1-git-send-email-leonidsbox@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Move operators in complex expressions to the end of the lines to
preserve consistency.

Signed-off-by: Leonid V. Fedorenchik <leonidsbox@gmail.com>
---
 .../staging/cx25821/cx25821-video-upstream-ch2.c   |   16 +++++++---------
 1 files changed, 7 insertions(+), 9 deletions(-)

diff --git a/drivers/staging/cx25821/cx25821-video-upstream-ch2.c b/drivers/staging/cx25821/cx25821-video-upstream-ch2.c
index 63cc26c..42f7ba5 100644
--- a/drivers/staging/cx25821/cx25821-video-upstream-ch2.c
+++ b/drivers/staging/cx25821/cx25821-video-upstream-ch2.c
@@ -65,9 +65,8 @@ static __le32 *cx25821_update_riscprogram_ch2(struct cx25821_dev *dev,
 		*(rp++) = cpu_to_le32(dev->_data_buf_phys_addr_ch2 + offset);
 		*(rp++) = cpu_to_le32(0);	/* bits 63-32 */
 
-		if ((lines <= NTSC_FIELD_HEIGHT)
-		    || (line < (NTSC_FIELD_HEIGHT - 1))
-		    || !(dev->_isNTSC_ch2)) {
+		if ((lines <= NTSC_FIELD_HEIGHT) ||
+		    (line < (NTSC_FIELD_HEIGHT - 1)) || !(dev->_isNTSC_ch2)) {
 			offset += dist_betwn_starts;
 		}
 	}
@@ -103,9 +102,8 @@ static __le32 *cx25821_risc_field_upstream_ch2(struct cx25821_dev *dev,
 		*(rp++) = cpu_to_le32(databuf_phys_addr + offset);
 		*(rp++) = cpu_to_le32(0);	/* bits 63-32 */
 
-		if ((lines <= NTSC_FIELD_HEIGHT)
-		    || (line < (NTSC_FIELD_HEIGHT - 1))
-		    || !(dev->_isNTSC_ch2)) {
+		if ((lines <= NTSC_FIELD_HEIGHT) ||
+		    (line < (NTSC_FIELD_HEIGHT - 1)) || !(dev->_isNTSC_ch2)) {
 			offset += dist_betwn_starts;
 		}
 
@@ -413,9 +411,9 @@ int cx25821_openfile_ch2(struct cx25821_dev *dev, struct sram_channel *sram_ch)
 				vfs_read_retval =
 				    vfs_read(myfile, mybuf, line_size, &pos);
 
-				if (vfs_read_retval > 0
-				    && vfs_read_retval == line_size
-				    && dev->_data_buf_virt_addr_ch2 != NULL) {
+				if (vfs_read_retval > 0 &&
+				    vfs_read_retval == line_size &&
+				    dev->_data_buf_virt_addr_ch2 != NULL) {
 					memcpy((void *)(dev->
 							_data_buf_virt_addr_ch2
 							+ offset / 4), mybuf,
-- 
1.7.0.4

