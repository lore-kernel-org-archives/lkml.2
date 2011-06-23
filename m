Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934618Ab1FWXN2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jun 2011 19:13:28 -0400
Received: from swampdragon.chaosbits.net ([90.184.90.115]:38472 "EHLO
	swampdragon.chaosbits.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934558Ab1FWXNN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jun 2011 19:13:13 -0400
Date: Fri, 24 Jun 2011 01:04:19 +0200 (CEST)
From: Jesper Juhl <jj@chaosbits.net>
To: LKML <linux-kernel@vger.kernel.org>
cc: trivial@kernel.org, Greg Kroah-Hartman <gregkh@suse.de>,
        Mauro Carvalho Chehab <mchehab@redhat.com>,
        Stefan Ringel <stefan.ringel@arcor.de>,
        "Beholder Intl. Ltd. Dmitry Belimov" <d.belimov@gmail.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Ruslan Pisarev <ruslan@rpisarev.org.ua>,
        Hans Verkuil <hverkuil@xs4all.nl>, devel@driverdev.osuosl.org
Subject: [PATCH 34/37] Remove unneeded version.h includes (and add where
 needed) for drivers/tm6000/
In-Reply-To: <alpine.LNX.2.00.1106232344480.17688@swampdragon.chaosbits.net>
Message-ID: <alpine.LNX.2.00.1106240102570.17688@swampdragon.chaosbits.net>
References: <alpine.LNX.2.00.1106232344480.17688@swampdragon.chaosbits.net>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It was pointed out by 'make versioncheck' that linux/version.h was not
always being included where needed and sometimes included needlessly
in drivers/staging/tm6000/.
This patch fixes up the includes.

Signed-off-by: Jesper Juhl <jj@chaosbits.net>
---
 drivers/staging/tm6000/tm6000-cards.c |    1 -
 drivers/staging/tm6000/tm6000-video.c |    1 -
 drivers/staging/tm6000/tm6000.h       |    3 +--
 3 files changed, 1 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/tm6000/tm6000-cards.c b/drivers/staging/tm6000/tm6000-cards.c
index a69c82e..be4b0e3 100644
--- a/drivers/staging/tm6000/tm6000-cards.c
+++ b/drivers/staging/tm6000/tm6000-cards.c
@@ -23,7 +23,6 @@
 #include <linux/delay.h>
 #include <linux/i2c.h>
 #include <linux/usb.h>
-#include <linux/version.h>
 #include <linux/slab.h>
 #include <media/v4l2-common.h>
 #include <media/tuner.h>
diff --git a/drivers/staging/tm6000/tm6000-video.c b/drivers/staging/tm6000/tm6000-video.c
index 4264064..576f136 100644
--- a/drivers/staging/tm6000/tm6000-video.c
+++ b/drivers/staging/tm6000/tm6000-video.c
@@ -30,7 +30,6 @@
 #include <linux/init.h>
 #include <linux/sched.h>
 #include <linux/random.h>
-#include <linux/version.h>
 #include <linux/usb.h>
 #include <linux/videodev2.h>
 #include <media/v4l2-ioctl.h>
diff --git a/drivers/staging/tm6000/tm6000.h b/drivers/staging/tm6000/tm6000.h
index ae6369b..c56da62 100644
--- a/drivers/staging/tm6000/tm6000.h
+++ b/drivers/staging/tm6000/tm6000.h
@@ -30,8 +30,7 @@
 #include <linux/i2c.h>
 #include <linux/mutex.h>
 #include <media/v4l2-device.h>
-
-
+#include <linux/version.h>
 #include <linux/dvb/frontend.h>
 #include "dvb_demux.h"
 #include "dvb_frontend.h"
-- 
1.7.5.2


-- 
Jesper Juhl <jj@chaosbits.net>       http://www.chaosbits.net/
Don't top-post http://www.catb.org/jargon/html/T/top-post.html
Plain text mails only, please.

