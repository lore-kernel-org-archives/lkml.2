Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757796Ab0GASs7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Jul 2010 14:48:59 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:59395 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932408Ab0GASst (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Jul 2010 14:48:49 -0400
From: =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: trivial@kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 1/2] trivial: fix typos concerning "sequential"
Date: Thu,  1 Jul 2010 20:48:44 +0200
Message-Id: <1278010125-20191-1-git-send-email-u.kleine-koenig@pengutronix.de>
X-Mailer: git-send-email 1.7.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
---
 drivers/media/video/gspca/sunplus.c |    4 ++--
 include/linux/jffs2.h               |    2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/media/video/gspca/sunplus.c b/drivers/media/video/gspca/sunplus.c
index 0c786e0..d0a133a 100644
--- a/drivers/media/video/gspca/sunplus.c
+++ b/drivers/media/video/gspca/sunplus.c
@@ -805,7 +805,7 @@ static int sd_init(struct gspca_dev *gspca_dev)
 			/* Set AE AWB Banding Type 3-> 50Hz 2-> 60Hz */
 			spca504A_acknowledged_command(gspca_dev, 0x24,
 							8, 3, 0x9e, 1);
-			/* Twice sequencial need status 0xff->0x9e->0x9d */
+			/* Twice sequential need status 0xff->0x9e->0x9d */
 			spca504A_acknowledged_command(gspca_dev, 0x24,
 							8, 3, 0x9e, 0);
 
@@ -880,7 +880,7 @@ static int sd_start(struct gspca_dev *gspca_dev)
 			/* Set AE AWB Banding Type 3-> 50Hz 2-> 60Hz */
 			spca504A_acknowledged_command(gspca_dev, 0x24,
 							8, 3, 0x9e, 1);
-			/* Twice sequencial need status 0xff->0x9e->0x9d */
+			/* Twice sequential need status 0xff->0x9e->0x9d */
 			spca504A_acknowledged_command(gspca_dev, 0x24,
 							8, 3, 0x9e, 0);
 			spca504A_acknowledged_command(gspca_dev, 0x24,
diff --git a/include/linux/jffs2.h b/include/linux/jffs2.h
index 0874ab5..edb9231 100644
--- a/include/linux/jffs2.h
+++ b/include/linux/jffs2.h
@@ -185,7 +185,7 @@ struct jffs2_raw_xref
 	jint32_t hdr_crc;
 	jint32_t ino;		/* inode number */
 	jint32_t xid;		/* XATTR identifier number */
-	jint32_t xseqno;	/* xref sequencial number */
+	jint32_t xseqno;	/* xref sequential number */
 	jint32_t node_crc;
 } __attribute__((packed));
 
-- 
1.7.1

