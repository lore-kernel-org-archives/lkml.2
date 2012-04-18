Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751668Ab2DREeL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Apr 2012 00:34:11 -0400
Received: from mail-gx0-f174.google.com ([209.85.161.174]:60385 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750975Ab2DREeI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Apr 2012 00:34:08 -0400
From: Marcos Paulo de Souza <marcos.souza.org@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Marcos Paulo de Souza <marcos.souza.org@gmail.com>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Huang Shijie <shijie8@gmail.com>, Kang Yong <kangyong@telegent.com>,
        Zhang Xiaobing <xbzhang@telegent.com>, <linux-media@vger.kernel.org>
Subject: [PATCH 06/12] drivers: media: video: tlg2300: pd-video.c: Include version.h header
Date: Wed, 18 Apr 2012 01:30:06 -0300
Message-Id: <1334723412-5034-7-git-send-email-marcos.souza.org@gmail.com>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <1334723412-5034-1-git-send-email-marcos.souza.org@gmail.com>
References: <1334723412-5034-1-git-send-email-marcos.souza.org@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The output of "make versioncheck" told us that:

drivers/media/video/tlg2300/pd-video.c: 1669: need linux/version.h

If we take a look at the code, we can see that this file uses the macro
KERNEL_VERSION. So, we need this include.

Cc: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: Huang Shijie <shijie8@gmail.com>
Cc: Kang Yong <kangyong@telegent.com>
Cc: Zhang Xiaobing <xbzhang@telegent.com>
Cc: <linux-media@vger.kernel.org>
Signed-off-by: Marcos Paulo de Souza <marcos.souza.org@gmail.com>
---
 drivers/media/video/tlg2300/pd-video.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/media/video/tlg2300/pd-video.c b/drivers/media/video/tlg2300/pd-video.c
index a794ae6..069db9a 100644
--- a/drivers/media/video/tlg2300/pd-video.c
+++ b/drivers/media/video/tlg2300/pd-video.c
@@ -5,6 +5,7 @@
 #include <linux/mm.h>
 #include <linux/sched.h>
 #include <linux/slab.h>
+#include <linux/version.h>
 
 #include <media/v4l2-ioctl.h>
 #include <media/v4l2-dev.h>
-- 
1.7.7.6

