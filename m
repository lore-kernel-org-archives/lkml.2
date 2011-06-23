Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934546Ab1FWXDt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jun 2011 19:03:49 -0400
Received: from swampdragon.chaosbits.net ([90.184.90.115]:48638 "EHLO
	swampdragon.chaosbits.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934141Ab1FWXDr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jun 2011 19:03:47 -0400
Date: Fri, 24 Jun 2011 00:54:52 +0200 (CEST)
From: Jesper Juhl <jj@chaosbits.net>
To: LKML <linux-kernel@vger.kernel.org>
cc: trivial@kernel.org, Greg Kroah-Hartman <gregkh@suse.de>,
        Tomas Winkler <tomas.winkler@intel.com>,
        Oren Weil <oren.jer.weil@intel.com>,
        Randy Dunlap <randy.dunlap@oracle.com>, devel@driverdev.osuosl.org
Subject: [PATCH 28/37] Remove unneeded version.h include from
 drivers/staging/mei/main.c
In-Reply-To: <alpine.LNX.2.00.1106232344480.17688@swampdragon.chaosbits.net>
Message-ID: <alpine.LNX.2.00.1106240053330.17688@swampdragon.chaosbits.net>
References: <alpine.LNX.2.00.1106232344480.17688@swampdragon.chaosbits.net>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It was pointed out by 'make versioncheck' that include of 
linux/version.h is not needed in drivers/staging/mei/main.c .
This patch removes it.

Signed-off-by: Jesper Juhl <jj@chaosbits.net>
---
 drivers/staging/mei/main.c |    3 ---
 1 files changed, 0 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/mei/main.c b/drivers/staging/mei/main.c
index bfd1b46..fb918ae 100644
--- a/drivers/staging/mei/main.c
+++ b/drivers/staging/mei/main.c
@@ -14,8 +14,6 @@
  *
  */
 
-
-
 #include <linux/module.h>
 #include <linux/moduleparam.h>
 #include <linux/kernel.h>
@@ -30,7 +28,6 @@
 #include <linux/init.h>
 #include <linux/ioctl.h>
 #include <linux/cdev.h>
-#include <linux/version.h>
 #include <linux/sched.h>
 #include <linux/uuid.h>
 #include <linux/compat.h>
-- 
1.7.5.2


-- 
Jesper Juhl <jj@chaosbits.net>       http://www.chaosbits.net/
Don't top-post http://www.catb.org/jargon/html/T/top-post.html
Plain text mails only, please.

