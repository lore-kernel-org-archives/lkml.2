Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753896Ab1JVFsX (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Oct 2011 01:48:23 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:42321 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753031Ab1JVFsT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Oct 2011 01:48:19 -0400
From: "Leonid V. Fedorenchik" <leonidsbox@gmail.com>
To: Greg Kroah-Hartman <gregkh@suse.de>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
        Namhyung Kim <namhyung@gmail.com>,
        Palash Bandyopadhyay <palash.bandyopadhyay@conexant.com>,
        Joe Perches <joe@perches.com>, Ilia Mirkin <imirkin@alum.mit.edu>,
        Youquan Song <youquan.song@intel.com>,
        "Leonid V. Fedorenchik" <leonidsbox@gmail.com>,
        devel@linuxdriverproject.org, linux-kernel@vger.kernel.org
Subject: [PATCH 21/36] Staging: cx25821: cx25821-video-upstream-ch2.c: Line up comments
Date: Sat, 22 Oct 2011 13:43:41 +0800
Message-Id: <1319262236-6498-22-git-send-email-leonidsbox@gmail.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1319262236-6498-1-git-send-email-leonidsbox@gmail.com>
References: <1319262236-6498-1-git-send-email-leonidsbox@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Line up comments to match indent of surrounding statements.

Signed-off-by: Leonid V. Fedorenchik <leonidsbox@gmail.com>
---
 .../staging/cx25821/cx25821-video-upstream-ch2.c   |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/cx25821/cx25821-video-upstream-ch2.c b/drivers/staging/cx25821/cx25821-video-upstream-ch2.c
index 08ac7c1..e5bc68a 100644
--- a/drivers/staging/cx25821/cx25821-video-upstream-ch2.c
+++ b/drivers/staging/cx25821/cx25821-video-upstream-ch2.c
@@ -173,7 +173,7 @@ int cx25821_risc_buffer_upstream_ch2(struct cx25821_dev *dev,
 
 		fifo_enable = FIFO_DISABLE;
 
-	       /* Even field */
+		/* Even field */
 		rp = cx25821_risc_field_upstream_ch2(dev, rp,
 				dev->_data_buf_phys_addr_ch2 + databuf_offset,
 				bottom_offset, 0x200, bpl, singlefield_lines,
@@ -189,9 +189,9 @@ int cx25821_risc_buffer_upstream_ch2(struct cx25821_dev *dev,
 		}
 
 	       /*
-		  Loop to 2ndFrameRISC or to Start of
-		  Risc program & generate IRQ
-	       */
+		* Loop to 2ndFrameRISC or to Start of
+		* Risc program & generate IRQ
+		*/
 		*(rp++) = cpu_to_le32(RISC_JUMP | RISC_IRQ1 | risc_flag);
 		*(rp++) = cpu_to_le32(risc_phys_jump_addr);
 		*(rp++) = cpu_to_le32(0);
-- 
1.7.0.4

