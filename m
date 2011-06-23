Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760073Ab1FWWSN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jun 2011 18:18:13 -0400
Received: from swampdragon.chaosbits.net ([90.184.90.115]:24040 "EHLO
	swampdragon.chaosbits.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759849Ab1FWWSM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jun 2011 18:18:12 -0400
Date: Fri, 24 Jun 2011 00:09:17 +0200 (CEST)
From: Jesper Juhl <jj@chaosbits.net>
To: LKML <linux-kernel@vger.kernel.org>
cc: trivial@kernel.org, Lars Ellenberg <drbd-dev@lists.linbit.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        drbd-user@lists.linbit.com
Subject: [PATCH 08/37] Remove unneeded version.h includes from
 drivers/block/
In-Reply-To: <alpine.LNX.2.00.1106232344480.17688@swampdragon.chaosbits.net>
Message-ID: <alpine.LNX.2.00.1106240008200.17688@swampdragon.chaosbits.net>
References: <alpine.LNX.2.00.1106232344480.17688@swampdragon.chaosbits.net>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It was pointed out by 'make versioncheck' that some includes of
linux/version.h are not needed in drivers/block/.
This patch removes them.

Signed-off-by: Jesper Juhl <jj@chaosbits.net>
---
 drivers/block/drbd/drbd_int.h      |    1 -
 drivers/block/xen-blkback/common.h |    1 -
 2 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/drivers/block/drbd/drbd_int.h b/drivers/block/drbd/drbd_int.h
index ef2ceed..1c3194d 100644
--- a/drivers/block/drbd/drbd_int.h
+++ b/drivers/block/drbd/drbd_int.h
@@ -28,7 +28,6 @@
 
 #include <linux/compiler.h>
 #include <linux/types.h>
-#include <linux/version.h>
 #include <linux/list.h>
 #include <linux/sched.h>
 #include <linux/bitops.h>
diff --git a/drivers/block/xen-blkback/common.h b/drivers/block/xen-blkback/common.h
index 9e40b28..0d04c7f 100644
--- a/drivers/block/xen-blkback/common.h
+++ b/drivers/block/xen-blkback/common.h
@@ -27,7 +27,6 @@
 #ifndef __XEN_BLKIF__BACKEND__COMMON_H__
 #define __XEN_BLKIF__BACKEND__COMMON_H__
 
-#include <linux/version.h>
 #include <linux/module.h>
 #include <linux/interrupt.h>
 #include <linux/slab.h>
-- 
1.7.5.2


-- 
Jesper Juhl <jj@chaosbits.net>       http://www.chaosbits.net/
Don't top-post http://www.catb.org/jargon/html/T/top-post.html
Plain text mails only, please.

