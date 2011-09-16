Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752853Ab1IPG02 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Sep 2011 02:26:28 -0400
Received: from mail-pz0-f42.google.com ([209.85.210.42]:50274 "EHLO
	mail-pz0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752449Ab1IPGQp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Sep 2011 02:16:45 -0400
From: "Leonid V. Fedorenchik" <leonidsbox@gmail.com>
To: Greg Kroah-Hartman <gregkh@suse.de>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
        Hans Verkuil <hverkuil@xs4all.nl>, Joe Perches <joe@perches.com>,
        devel@linuxdriverproject.org, linux-kernel@vger.kernel.org,
        "Leonid V. Fedorenchik" <leonidsbox@gmail.com>
Subject: [PATCH 03/44] Staging: cx25821: Fix obscure line endings
Date: Fri, 16 Sep 2011 14:14:36 +0800
Message-Id: <1316153717-7272-4-git-send-email-leonidsbox@gmail.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1316153717-7272-1-git-send-email-leonidsbox@gmail.com>
References: <1316153717-7272-1-git-send-email-leonidsbox@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix obscure line endings to less obscure ones. Rationale: readability.

Signed-off-by: Leonid V. Fedorenchik <leonidsbox@gmail.com>
---
 drivers/staging/cx25821/cx25821-video.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/cx25821/cx25821-video.c b/drivers/staging/cx25821/cx25821-video.c
index 4a365bb..1aebc99 100644
--- a/drivers/staging/cx25821/cx25821-video.c
+++ b/drivers/staging/cx25821/cx25821-video.c
@@ -162,8 +162,7 @@ void cx25821_video_wakeup(struct cx25821_dev *dev, struct cx25821_dmaqueue *q,
 	else
 		mod_timer(&q->timeout, jiffies + BUFFER_TIMEOUT);
 	if (bc != 1)
-		pr_err("%s: %d buffers handled (should be 1)\n",
-		       __func__, bc);
+		pr_err("%s: %d buffers handled (should be 1)\n", __func__, bc);
 }
 
 #ifdef TUNER_FLAG
-- 
1.7.0.4

