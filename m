Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755165Ab2BOTU5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Feb 2012 14:20:57 -0500
Received: from wp188.webpack.hosteurope.de ([80.237.132.195]:60171 "EHLO
	wp188.webpack.hosteurope.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755018Ab2BOTUx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Feb 2012 14:20:53 -0500
From: Danny Kukawka <danny.kukawka@bisect.de>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: Danny Kukawka <dkukawka@suse.de>, Sakari Ailus <sakari.ailus@iki.fi>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] adp1653: included linux/module.h twice
Date: Wed, 15 Feb 2012 20:20:44 +0100
Message-Id: <1329333644-32048-1-git-send-email-danny.kukawka@bisect.de>
X-Mailer: git-send-email 1.7.8.3
X-bounce-key: webpack.hosteurope.de;danny.kukawka@bisect.de;1329333653;03321d87;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

drivers/media/video/adp1653.c included 'linux/module.h' twice,
remove the duplicate.

Signed-off-by: Danny Kukawka <danny.kukawka@bisect.de>
---
 drivers/media/video/adp1653.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/drivers/media/video/adp1653.c b/drivers/media/video/adp1653.c
index 12eedf4..6e7d094 100644
--- a/drivers/media/video/adp1653.c
+++ b/drivers/media/video/adp1653.c
@@ -33,7 +33,6 @@
 #include <linux/delay.h>
 #include <linux/module.h>
 #include <linux/i2c.h>
-#include <linux/module.h>
 #include <linux/slab.h>
 #include <linux/version.h>
 #include <media/adp1653.h>
-- 
1.7.8.3

