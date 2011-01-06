Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754029Ab1AFR0B (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jan 2011 12:26:01 -0500
Received: from liberdade2.minaslivre.org ([74.50.53.203]:59059 "EHLO
	liberdade.minaslivre.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753794Ab1AFR0A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jan 2011 12:26:00 -0500
From: Thadeu Lima de Souza Cascardo <cascardo@holoscopio.com>
To: linux-media@vger.kernel.org
Cc: Thadeu Lima de Souza Cascardo <cascardo@holoscopio.com>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Devin Heitmueller <dheitmueller@hauppauge.com>,
        Sri Deevi <Srinivasa.Deevi@conexant.com>,
        =?UTF-8?q?M=C3=A1rton=20N=C3=A9meth?= <nm127@freemail.hu>,
        Palash Bandyopadhyay <palash.bandyopadhyay@conexant.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH] DVB: cx231xx drivers does not use dummy frontend anymore
Date: Thu,  6 Jan 2011 15:25:44 -0200
Message-Id: <1294334745-13461-1-git-send-email-cascardo@holoscopio.com>
X-Mailer: git-send-email 1.7.2.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Thadeu Lima de Souza Cascardo <cascardo@holoscopio.com>
---
 drivers/media/video/cx231xx/cx231xx-dvb.c |    5 ++---
 1 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/media/video/cx231xx/cx231xx-dvb.c b/drivers/media/video/cx231xx/cx231xx-dvb.c
index 5feb3ee..227d0dc 100644
--- a/drivers/media/video/cx231xx/cx231xx-dvb.c
+++ b/drivers/media/video/cx231xx/cx231xx-dvb.c
@@ -28,7 +28,6 @@
 #include <media/videobuf-vmalloc.h>
 
 #include "xc5000.h"
-#include "dvb_dummy_fe.h"
 #include "s5h1432.h"
 #include "tda18271.h"
 #include "s5h1411.h"
@@ -602,7 +601,7 @@ static int dvb_init(struct cx231xx *dev)
 
 		if (dev->dvb->frontend == NULL) {
 			printk(DRIVER_NAME
-			       ": Failed to attach dummy front end\n");
+			       ": Failed to attach s5h1411 front end\n");
 			result = -EINVAL;
 			goto out_free;
 		}
@@ -648,7 +647,7 @@ static int dvb_init(struct cx231xx *dev)
 
 		if (dev->dvb->frontend == NULL) {
 			printk(DRIVER_NAME
-			       ": Failed to attach dummy front end\n");
+			       ": Failed to attach s5h1411 front end\n");
 			result = -EINVAL;
 			goto out_free;
 		}
-- 
1.7.2.3

