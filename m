Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934573Ab1FWXRB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jun 2011 19:17:01 -0400
Received: from swampdragon.chaosbits.net ([90.184.90.115]:25605 "EHLO
	swampdragon.chaosbits.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933959Ab1FWXQ7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jun 2011 19:16:59 -0400
Date: Fri, 24 Jun 2011 01:08:05 +0200 (CEST)
From: Jesper Juhl <jj@chaosbits.net>
To: LKML <linux-kernel@vger.kernel.org>
cc: trivial@kernel.org, Greg Kroah-Hartman <gregkh@suse.de>,
        Aaro Koskinen <aaro.koskinen@iki.fi>,
        Javier Martinez Canillas <martinez.javier@gmail.com>,
        "Prashant P. Shah" <pshah.mumbai@gmail.com>,
        Randy Dunlap <randy.dunlap@oracle.com>, devel@driverdev.osuosl.org
Subject: [PATCH 37/37] Remove unneeded version.h includes from drivers/staging/xgifb/
In-Reply-To: <alpine.LNX.2.00.1106232344480.17688@swampdragon.chaosbits.net>
Message-ID: <alpine.LNX.2.00.1106240106500.17688@swampdragon.chaosbits.net>
References: <alpine.LNX.2.00.1106232344480.17688@swampdragon.chaosbits.net>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It was pointed out by 'make versioncheck' that some includes of
linux/version.h are not needed in drivers/staging/xgifb/.
This patch removes them.

Signed-off-by: Jesper Juhl <jj@chaosbits.net>
---
 drivers/staging/xgifb/XGI_main_26.c |    1 -
 drivers/staging/xgifb/vb_ext.c      |    1 -
 drivers/staging/xgifb/vb_init.c     |    1 -
 drivers/staging/xgifb/vb_setmode.c  |    1 -
 4 files changed, 0 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/xgifb/XGI_main_26.c b/drivers/staging/xgifb/XGI_main_26.c
index cadec2a..4403e5f 100644
--- a/drivers/staging/xgifb/XGI_main_26.c
+++ b/drivers/staging/xgifb/XGI_main_26.c
@@ -5,7 +5,6 @@
  */
 
 /* #include <linux/config.h> */
-#include <linux/version.h>
 #include <linux/module.h>
 #include <linux/moduleparam.h>
 #include <linux/kernel.h>
diff --git a/drivers/staging/xgifb/vb_ext.c b/drivers/staging/xgifb/vb_ext.c
index 7e1f76a..b1a2573 100644
--- a/drivers/staging/xgifb/vb_ext.c
+++ b/drivers/staging/xgifb/vb_ext.c
@@ -1,4 +1,3 @@
-#include <linux/version.h>
 #include <linux/io.h>
 #include <linux/types.h>
 #include "XGIfb.h"
diff --git a/drivers/staging/xgifb/vb_init.c b/drivers/staging/xgifb/vb_init.c
index 33c6876..493b532 100644
--- a/drivers/staging/xgifb/vb_init.c
+++ b/drivers/staging/xgifb/vb_init.c
@@ -1,6 +1,5 @@
 #include "vgatypes.h"
 
-#include <linux/version.h>
 #include <linux/types.h>
 #include <linux/delay.h> /* udelay */
 #include "XGIfb.h"
diff --git a/drivers/staging/xgifb/vb_setmode.c b/drivers/staging/xgifb/vb_setmode.c
index 2669b1b..dc4d6e6 100644
--- a/drivers/staging/xgifb/vb_setmode.c
+++ b/drivers/staging/xgifb/vb_setmode.c
@@ -2,7 +2,6 @@
 #include <linux/io.h>
 #include <linux/delay.h>
 #include <linux/types.h>
-#include <linux/version.h>
 #include "XGIfb.h"
 
 
-- 
1.7.5.2


-- 
Jesper Juhl <jj@chaosbits.net>       http://www.chaosbits.net/
Don't top-post http://www.catb.org/jargon/html/T/top-post.html
Plain text mails only, please.

