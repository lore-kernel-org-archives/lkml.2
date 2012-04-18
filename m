Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752417Ab2DREeR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Apr 2012 00:34:17 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:42250 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752218Ab2DREeN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Apr 2012 00:34:13 -0400
From: Marcos Paulo de Souza <marcos.souza.org@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Marcos Paulo de Souza <marcos.souza.org@gmail.com>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        <linux-media@vger.kernel.org>
Subject: [PATCH 07/12] drivers: media: video: tm6000: tm6000.h: Include version.h header
Date: Wed, 18 Apr 2012 01:30:07 -0300
Message-Id: <1334723412-5034-8-git-send-email-marcos.souza.org@gmail.com>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <1334723412-5034-1-git-send-email-marcos.souza.org@gmail.com>
References: <1334723412-5034-1-git-send-email-marcos.souza.org@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The output of "make versioncheck" told us that:

drivers/media/video/tm6000/tm6000.h: 401: need linux/version.h

If we take a look at the code, we can see the use of the macro
KERNEL_VERSION. So, we need this include.

In this patch too, the headers of the file were reordered in alphabetic
order. No functional changes here.

Cc: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: <linux-media@vger.kernel.org >
Signed-off-by: Marcos Paulo de Souza <marcos.souza.org@gmail.com>
---
 drivers/media/video/tm6000/tm6000.h |   13 +++++++------
 1 files changed, 7 insertions(+), 6 deletions(-)

diff --git a/drivers/media/video/tm6000/tm6000.h b/drivers/media/video/tm6000/tm6000.h
index 27ba659..e984cf2 100644
--- a/drivers/media/video/tm6000/tm6000.h
+++ b/drivers/media/video/tm6000/tm6000.h
@@ -20,18 +20,19 @@
  *  Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
  */
 
-#include <linux/videodev2.h>
-#include <media/v4l2-common.h>
-#include <media/videobuf-vmalloc.h>
-#include "tm6000-usb-isoc.h"
+#include <linux/dvb/frontend.h>
 #include <linux/i2c.h>
 #include <linux/mutex.h>
+#include <linux/version.h>
+#include <linux/videodev2.h>
+#include <media/videobuf-vmalloc.h>
+#include <media/v4l2-common.h>
 #include <media/v4l2-device.h>
 
-#include <linux/dvb/frontend.h>
+#include "dmxdev.h"
 #include "dvb_demux.h"
 #include "dvb_frontend.h"
-#include "dmxdev.h"
+#include "tm6000-usb-isoc.h"
 
 #define TM6000_VERSION KERNEL_VERSION(0, 0, 2)
 
-- 
1.7.7.6

