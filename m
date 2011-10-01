Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755249Ab1JAAeO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Sep 2011 20:34:14 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:55153 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753147Ab1JAAeA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Sep 2011 20:34:00 -0400
From: Javier Martinez Canillas <martinez.javier@gmail.com>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Javier Martinez Canillas <martinez.javier@gmail.com>
Subject: [PATCH 1/3] [media] tvp5150: Add constants for PAL and NTSC video standards
Date: Sat,  1 Oct 2011 02:33:49 +0200
Message-Id: <1317429231-11359-2-git-send-email-martinez.javier@gmail.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1317429231-11359-1-git-send-email-martinez.javier@gmail.com>
References: <1317429231-11359-1-git-send-email-martinez.javier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Javier Martinez Canillas <martinez.javier@gmail.com>
---
 include/media/tvp5150.h |    6 ++++++
 1 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/include/media/tvp5150.h b/include/media/tvp5150.h
index 72bd2a2..ccd4ed0 100644
--- a/include/media/tvp5150.h
+++ b/include/media/tvp5150.h
@@ -30,5 +30,11 @@
 #define TVP5150_NORMAL       0
 #define TVP5150_BLACK_SCREEN 1
 
+/* Number of pixels and number of lines per frame for different standards */
+#define NTSC_NUM_ACTIVE_PIXELS		(720)
+#define NTSC_NUM_ACTIVE_LINES		(480)
+#define PAL_NUM_ACTIVE_PIXELS		(720)
+#define PAL_NUM_ACTIVE_LINES		(576)
+
 #endif
 
-- 
1.7.4.1

