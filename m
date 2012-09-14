Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756540Ab2INOGg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Sep 2012 10:06:36 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:61667 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755754Ab2INOGe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Sep 2012 10:06:34 -0400
From: Prabhakar Lad <prabhakar.csengg@gmail.com>
To: LMML <linux-media@vger.kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        DLOS <davinci-linux-open-source@linux.davincidsp.com>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        "Lad, Prabhakar" <prabhakar.lad@ti.com>
Subject: [PATCH] davinci: vpif: remove unwanted header file inclusion
Date: Fri, 14 Sep 2012 19:35:52 +0530
Message-Id: <1347631552-9324-1-git-send-email-prabhakar.lad@ti.com>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Hans Verkuil <hans.verkuil@cisco.com>

Remove old videobuf-core.h includes.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
Signed-off-by: Lad, Prabhakar <prabhakar.lad@ti.com>
---
 drivers/media/platform/davinci/vpif_capture.h |    1 -
 drivers/media/platform/davinci/vpif_display.h |    1 -
 2 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/drivers/media/platform/davinci/vpif_capture.h b/drivers/media/platform/davinci/vpif_capture.h
index 3511510..15a06dc 100644
--- a/drivers/media/platform/davinci/vpif_capture.h
+++ b/drivers/media/platform/davinci/vpif_capture.h
@@ -25,7 +25,6 @@
 #include <linux/videodev2.h>
 #include <media/v4l2-common.h>
 #include <media/v4l2-device.h>
-#include <media/videobuf-core.h>
 #include <media/videobuf2-dma-contig.h>
 #include <media/davinci/vpif_types.h>
 
diff --git a/drivers/media/platform/davinci/vpif_display.h b/drivers/media/platform/davinci/vpif_display.h
index 8967ffb..dfda5bd 100644
--- a/drivers/media/platform/davinci/vpif_display.h
+++ b/drivers/media/platform/davinci/vpif_display.h
@@ -20,7 +20,6 @@
 #include <linux/videodev2.h>
 #include <media/v4l2-common.h>
 #include <media/v4l2-device.h>
-#include <media/videobuf-core.h>
 #include <media/videobuf2-dma-contig.h>
 #include <media/davinci/vpif_types.h>
 
-- 
1.7.4.1

