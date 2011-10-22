Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753828Ab1JVFsI (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Oct 2011 01:48:08 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:42321 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753287Ab1JVFsE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Oct 2011 01:48:04 -0400
From: "Leonid V. Fedorenchik" <leonidsbox@gmail.com>
To: Greg Kroah-Hartman <gregkh@suse.de>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
        Namhyung Kim <namhyung@gmail.com>,
        Palash Bandyopadhyay <palash.bandyopadhyay@conexant.com>,
        Joe Perches <joe@perches.com>, Ilia Mirkin <imirkin@alum.mit.edu>,
        Youquan Song <youquan.song@intel.com>,
        "Leonid V. Fedorenchik" <leonidsbox@gmail.com>,
        devel@linuxdriverproject.org, linux-kernel@vger.kernel.org
Subject: [PATCH 19/36] Staging: cx25821: cx25821-medusa-video.c: Move operators
Date: Sat, 22 Oct 2011 13:43:39 +0800
Message-Id: <1319262236-6498-20-git-send-email-leonidsbox@gmail.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1319262236-6498-1-git-send-email-leonidsbox@gmail.com>
References: <1319262236-6498-1-git-send-email-leonidsbox@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Plase operators in complex expressions at the end of the lines to
preserve consistency.

Signed-off-by: Leonid V. Fedorenchik <leonidsbox@gmail.com>
---
 drivers/staging/cx25821/cx25821-medusa-video.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/cx25821/cx25821-medusa-video.c b/drivers/staging/cx25821/cx25821-medusa-video.c
index 48c62c9..1ae0e8a 100644
--- a/drivers/staging/cx25821/cx25821-medusa-video.c
+++ b/drivers/staging/cx25821/cx25821-medusa-video.c
@@ -654,8 +654,8 @@ int medusa_set_brightness(struct cx25821_dev *dev, int brightness, int decoder)
 	u32 val = 0, tmp = 0;
 
 	mutex_lock(&dev->lock);
-	if ((brightness > VIDEO_PROCAMP_MAX)
-	    || (brightness < VIDEO_PROCAMP_MIN)) {
+	if ((brightness > VIDEO_PROCAMP_MAX) ||
+	    (brightness < VIDEO_PROCAMP_MIN)) {
 		mutex_unlock(&dev->lock);
 		return -1;
 	}
@@ -743,8 +743,8 @@ int medusa_set_saturation(struct cx25821_dev *dev, int saturation, int decoder)
 
 	mutex_lock(&dev->lock);
 
-	if ((saturation > VIDEO_PROCAMP_MAX)
-	    || (saturation < VIDEO_PROCAMP_MIN)) {
+	if ((saturation > VIDEO_PROCAMP_MAX) ||
+	    (saturation < VIDEO_PROCAMP_MIN)) {
 		mutex_unlock(&dev->lock);
 		return -1;
 	}
-- 
1.7.0.4

