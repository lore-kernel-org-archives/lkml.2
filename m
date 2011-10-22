Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754295Ab1JVFtu (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Oct 2011 01:49:50 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:42321 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754263Ab1JVFts (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Oct 2011 01:49:48 -0400
From: "Leonid V. Fedorenchik" <leonidsbox@gmail.com>
To: Greg Kroah-Hartman <gregkh@suse.de>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
        Namhyung Kim <namhyung@gmail.com>,
        Palash Bandyopadhyay <palash.bandyopadhyay@conexant.com>,
        Joe Perches <joe@perches.com>, Ilia Mirkin <imirkin@alum.mit.edu>,
        Youquan Song <youquan.song@intel.com>,
        "Leonid V. Fedorenchik" <leonidsbox@gmail.com>,
        devel@linuxdriverproject.org, linux-kernel@vger.kernel.org
Subject: [PATCH 33/36] Staging: cx25821: cx25821-video.c: Move operators
Date: Sat, 22 Oct 2011 13:43:53 +0800
Message-Id: <1319262236-6498-34-git-send-email-leonidsbox@gmail.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1319262236-6498-1-git-send-email-leonidsbox@gmail.com>
References: <1319262236-6498-1-git-send-email-leonidsbox@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Move operator in complex expression to the end of the line to preserve
consistency.

Signed-off-by: Leonid V. Fedorenchik <leonidsbox@gmail.com>
---
 drivers/staging/cx25821/cx25821-video.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/cx25821/cx25821-video.c b/drivers/staging/cx25821/cx25821-video.c
index 0ba4f43..1f9309b 100644
--- a/drivers/staging/cx25821/cx25821-video.c
+++ b/drivers/staging/cx25821/cx25821-video.c
@@ -616,8 +616,8 @@ int cx25821_buffer_prepare(struct videobuf_queue *q, struct videobuf_buffer *vb,
 			if (channel_opened >= 0 && channel_opened <= 7) {
 				if (dev->channels[channel_opened]
 						.use_cif_resolution) {
-					if (dev->tvnorm & V4L2_STD_PAL_BG
-					    || dev->tvnorm & V4L2_STD_PAL_DK)
+					if (dev->tvnorm & V4L2_STD_PAL_BG ||
+					    dev->tvnorm & V4L2_STD_PAL_DK)
 						bpl_local = 352 << 1;
 					else
 						bpl_local =
-- 
1.7.0.4

