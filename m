Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755516Ab1AaMQf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Jan 2011 07:16:35 -0500
Received: from moutng.kundenserver.de ([212.227.126.171]:64869 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752322Ab1AaMQe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Jan 2011 07:16:34 -0500
From: Thomas Weber <weber@corscience.de>
To: linux-omap@vger.kernel.org
Cc: Thomas Weber <weber@corscience.de>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] video: omap24xxcam: Fix compilation
Date: Mon, 31 Jan 2011 13:16:09 +0100
Message-Id: <1296476169-10862-1-git-send-email-weber@corscience.de>
X-Mailer: git-send-email 1.7.4.rc3
X-Provags-ID: V02:K0:c+NQv/N8hZDoUKd5gj3GEW5fC3Z95wLQsdBWDT3/CF7
 7KsyuZZm3pLJs4v+Zzf+Taz795BJh1mPHypzYK1sfOdE1nKWyD
 fd0+Jtt0BX+EmBfHYupKZ7fziTBuhCot1z1WoKX5VYN45kGuYG
 9/wsFu8YuNGvntlAB6OUbXHU0IBLUBdeeeesjSXGCD16ez0LBD
 L4ROc00yZ4kzxZ4V4iarA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add linux/sched.h because of missing declaration of TASK_NORMAL.

This patch fixes the following error:

drivers/media/video/omap24xxcam.c: In function
'omap24xxcam_vbq_complete':
drivers/media/video/omap24xxcam.c:415: error: 'TASK_NORMAL' undeclared
(first use in this function)
drivers/media/video/omap24xxcam.c:415: error: (Each undeclared
identifier is reported only once
drivers/media/video/omap24xxcam.c:415: error: for each function it
appears in.)

Signed-off-by: Thomas Weber <weber@corscience.de>
---
 drivers/media/video/omap24xxcam.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/media/video/omap24xxcam.c b/drivers/media/video/omap24xxcam.c
index 0175527..f6626e8 100644
--- a/drivers/media/video/omap24xxcam.c
+++ b/drivers/media/video/omap24xxcam.c
@@ -36,6 +36,7 @@
 #include <linux/clk.h>
 #include <linux/io.h>
 #include <linux/slab.h>
+#include <linux/sched.h>
 
 #include <media/v4l2-common.h>
 #include <media/v4l2-ioctl.h>
-- 
1.7.4.rc3

