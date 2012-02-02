Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757403Ab2BBVOp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Feb 2012 16:14:45 -0500
Received: from swampdragon.chaosbits.net ([90.184.90.115]:12333 "EHLO
	swampdragon.chaosbits.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757371Ab2BBVOo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Feb 2012 16:14:44 -0500
Date: Thu, 2 Feb 2012 22:15:06 +0100 (CET)
From: Jesper Juhl <jj@chaosbits.net>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
cc: Sakari Ailus <sakari.ailus@iki.fi>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>,
        Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>,
        Tuukka Toivonen <tuukkat76@gmail.com>
Subject: [PATCH] media, adp1653: Remove unneeded include of version.h from
 drivers/media/video/adp1653.c
Message-ID: <alpine.LNX.2.00.1202022212550.16813@swampdragon.chaosbits.net>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Jesper Juhl <jj@chaosbits.net>
---
 drivers/media/video/adp1653.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

  compile tested only.

diff --git a/drivers/media/video/adp1653.c b/drivers/media/video/adp1653.c
index 12eedf4..badbdb6 100644
--- a/drivers/media/video/adp1653.c
+++ b/drivers/media/video/adp1653.c
@@ -35,7 +35,6 @@
 #include <linux/i2c.h>
 #include <linux/module.h>
 #include <linux/slab.h>
-#include <linux/version.h>
 #include <media/adp1653.h>
 #include <media/v4l2-device.h>
 
-- 
1.7.9


-- 
Jesper Juhl <jj@chaosbits.net>       http://www.chaosbits.net/
Don't top-post http://www.catb.org/jargon/html/T/top-post.html
Plain text mails only, please.

