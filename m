Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760085Ab1FWWXQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jun 2011 18:23:16 -0400
Received: from swampdragon.chaosbits.net ([90.184.90.115]:24159 "EHLO
	swampdragon.chaosbits.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760037Ab1FWWXP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jun 2011 18:23:15 -0400
Date: Fri, 24 Jun 2011 00:14:19 +0200 (CEST)
From: Jesper Juhl <jj@chaosbits.net>
To: LKML <linux-kernel@vger.kernel.org>
cc: trivial@kernel.org, Mauro Carvalho Chehab <mchehab@infradead.org>,
        linux-media@vger.kernel.org, Joonyoung Shim <jy0922.shim@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Hans Verkuil <hverkuil@xs4all.nl>, Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH 11/37] Remove unneeded version.h includes (and add where
 needed) for drivers/media/radio/
In-Reply-To: <alpine.LNX.2.00.1106232344480.17688@swampdragon.chaosbits.net>
Message-ID: <alpine.LNX.2.00.1106240011510.17688@swampdragon.chaosbits.net>
References: <alpine.LNX.2.00.1106232344480.17688@swampdragon.chaosbits.net>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It was pointed out by 'make versioncheck' that linux/version.h was not
always being included where needed and sometimes included needlessly
in drivers/media/radio/.
This patch fixes up the includes.

Signed-off-by: Jesper Juhl <jj@chaosbits.net>
---
 drivers/media/radio/si470x/radio-si470x-i2c.c |    1 +
 drivers/media/radio/si470x/radio-si470x-usb.c |    1 +
 drivers/media/radio/si470x/radio-si470x.h     |    1 -
 3 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/drivers/media/radio/si470x/radio-si470x-i2c.c b/drivers/media/radio/si470x/radio-si470x-i2c.c
index a2a6777..2c7700f 100644
--- a/drivers/media/radio/si470x/radio-si470x-i2c.c
+++ b/drivers/media/radio/si470x/radio-si470x-i2c.c
@@ -23,6 +23,7 @@
 
 
 /* driver definitions */
+#include <linux/version.h>
 #define DRIVER_AUTHOR "Joonyoung Shim <jy0922.shim@samsung.com>";
 #define DRIVER_KERNEL_VERSION KERNEL_VERSION(1, 0, 1)
 #define DRIVER_CARD "Silicon Labs Si470x FM Radio Receiver"
diff --git a/drivers/media/radio/si470x/radio-si470x-usb.c b/drivers/media/radio/si470x/radio-si470x-usb.c
index 392e84f..653384d 100644
--- a/drivers/media/radio/si470x/radio-si470x-usb.c
+++ b/drivers/media/radio/si470x/radio-si470x-usb.c
@@ -28,6 +28,7 @@
 
 
 /* driver definitions */
+#include <linux/version.h>
 #define DRIVER_AUTHOR "Tobias Lorenz <tobias.lorenz@gmx.net>"
 #define DRIVER_KERNEL_VERSION KERNEL_VERSION(1, 0, 10)
 #define DRIVER_CARD "Silicon Labs Si470x FM Radio Receiver"
diff --git a/drivers/media/radio/si470x/radio-si470x.h b/drivers/media/radio/si470x/radio-si470x.h
index 68da001..f300a55 100644
--- a/drivers/media/radio/si470x/radio-si470x.h
+++ b/drivers/media/radio/si470x/radio-si470x.h
@@ -32,7 +32,6 @@
 #include <linux/sched.h>
 #include <linux/slab.h>
 #include <linux/input.h>
-#include <linux/version.h>
 #include <linux/videodev2.h>
 #include <linux/mutex.h>
 #include <media/v4l2-common.h>
-- 
1.7.5.2


-- 
Jesper Juhl <jj@chaosbits.net>       http://www.chaosbits.net/
Don't top-post http://www.catb.org/jargon/html/T/top-post.html
Plain text mails only, please.

