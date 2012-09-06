Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932282Ab2IFQJt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Sep 2012 12:09:49 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:36004 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758821Ab2IFQJp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Sep 2012 12:09:45 -0400
From: Peter Senna Tschudin <peter.senna@gmail.com>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: kernel-janitors@vger.kernel.org,
        Peter Senna Tschudin <peter.senna@gmail.com>,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 6/10] drivers/media/pci/cx88/cx88-blackbird.c: removes unnecessary semicolon
Date: Thu,  6 Sep 2012 18:09:14 +0200
Message-Id: <1346947757-10481-7-git-send-email-peter.senna@gmail.com>
X-Mailer: git-send-email 1.7.11.4
In-Reply-To: <1346947757-10481-1-git-send-email-peter.senna@gmail.com>
References: <1346947757-10481-1-git-send-email-peter.senna@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Peter Senna Tschudin <peter.senna@gmail.com>

removes unnecessary semicolon

Found by Coccinelle: http://coccinelle.lip6.fr/

Signed-off-by: Peter Senna Tschudin <peter.senna@gmail.com>

---
 drivers/media/pci/cx88/cx88-blackbird.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff -u -p a/drivers/media/pci/cx88/cx88-blackbird.c b/drivers/media/pci/cx88/cx88-blackbird.c
--- a/drivers/media/pci/cx88/cx88-blackbird.c
+++ b/drivers/media/pci/cx88/cx88-blackbird.c
@@ -721,7 +721,7 @@ static int vidioc_g_fmt_vid_cap (struct
 
 	f->fmt.pix.pixelformat  = V4L2_PIX_FMT_MPEG;
 	f->fmt.pix.bytesperline = 0;
-	f->fmt.pix.sizeimage    = 188 * 4 * mpegbufs; /* 188 * 4 * 1024; */;
+	f->fmt.pix.sizeimage    = 188 * 4 * mpegbufs; /* 188 * 4 * 1024; */
 	f->fmt.pix.colorspace   = V4L2_COLORSPACE_SMPTE170M;
 	f->fmt.pix.width        = dev->width;
 	f->fmt.pix.height       = dev->height;
@@ -739,7 +739,7 @@ static int vidioc_try_fmt_vid_cap (struc
 
 	f->fmt.pix.pixelformat  = V4L2_PIX_FMT_MPEG;
 	f->fmt.pix.bytesperline = 0;
-	f->fmt.pix.sizeimage    = 188 * 4 * mpegbufs; /* 188 * 4 * 1024; */;
+	f->fmt.pix.sizeimage    = 188 * 4 * mpegbufs; /* 188 * 4 * 1024; */
 	f->fmt.pix.colorspace   = V4L2_COLORSPACE_SMPTE170M;
 	dprintk(1, "VIDIOC_TRY_FMT: w: %d, h: %d, f: %d\n",
 		dev->width, dev->height, fh->mpegq.field );
@@ -755,7 +755,7 @@ static int vidioc_s_fmt_vid_cap (struct
 
 	f->fmt.pix.pixelformat  = V4L2_PIX_FMT_MPEG;
 	f->fmt.pix.bytesperline = 0;
-	f->fmt.pix.sizeimage    = 188 * 4 * mpegbufs; /* 188 * 4 * 1024; */;
+	f->fmt.pix.sizeimage    = 188 * 4 * mpegbufs; /* 188 * 4 * 1024; */
 	f->fmt.pix.colorspace   = V4L2_COLORSPACE_SMPTE170M;
 	dev->width              = f->fmt.pix.width;
 	dev->height             = f->fmt.pix.height;

