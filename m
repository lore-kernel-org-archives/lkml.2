Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751892Ab1HOE5l (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Aug 2011 00:57:41 -0400
Received: from acsinet15.oracle.com ([141.146.126.227]:16907 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751435Ab1HOE5k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Aug 2011 00:57:40 -0400
Message-ID: <4E48A723.8070906@oracle.com>
Date: Mon, 15 Aug 2011 12:57:07 +0800
From: Joe Jin <joe.jin@oracle.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:5.0) Gecko/20110707 Thunderbird/5.0
MIME-Version: 1.0
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Jens Axboe <jaxboe@fusionio.com>,
        Ian Campbell <Ian.Campbell@eu.citrix.com>
CC: Greg Marsden <greg.marsden@oracle.com>,
        Kurt C Hackel <KURT.HACKEL@oracle.com>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Joe Jin <joe.jin@oracle.com>
Subject: xen-blkback: fixed indentation and comments
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090203.4E48A73F.002B:SCFMA922111,ss=1,re=-4.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes belows:

1. Fix code style issue.
2. Fix incorrect functions name in comments.

Signed-off-by: Joe Jin <joe.jin@oracle.com>
Cc: Jens Axboe <jaxboe@fusionio.com>
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: Ian Campbell <Ian.Campbell@eu.citrix.com>
---
 drivers/block/xen-blkback/common.h |    2 +-
 drivers/block/xen-blkback/xenbus.c |    4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/block/xen-blkback/common.h b/drivers/block/xen-blkback/common.h
index 9e40b28..00c57c9 100644
--- a/drivers/block/xen-blkback/common.h
+++ b/drivers/block/xen-blkback/common.h
@@ -46,7 +46,7 @@
 
 #define DRV_PFX "xen-blkback:"
 #define DPRINTK(fmt, args...)				\
-	pr_debug(DRV_PFX "(%s:%d) " fmt ".\n",	\
+	pr_debug(DRV_PFX "(%s:%d) " fmt ".\n",		\
 		 __func__, __LINE__, ##args)
 
 
diff --git a/drivers/block/xen-blkback/xenbus.c b/drivers/block/xen-blkback/xenbus.c
index da39d61..9fa9d07 100644
--- a/drivers/block/xen-blkback/xenbus.c
+++ b/drivers/block/xen-blkback/xenbus.c
@@ -598,7 +598,7 @@ static void frontend_changed(struct xenbus_device *dev,
 
 		/*
 		 * Enforce precondition before potential leak point.
-		 * blkif_disconnect() is idempotent.
+		 * xen_blkif_disconnect() is idempotent.
 		 */
 		xen_blkif_disconnect(be->blkif);
 
@@ -619,7 +619,7 @@ static void frontend_changed(struct xenbus_device *dev,
 			break;
 		/* fall through if not online */
 	case XenbusStateUnknown:
-		/* implies blkif_disconnect() via blkback_remove() */
+		/* implies xen_blkif_disconnect() via xen_blkbk_remove() */
 		device_unregister(&dev->dev);
 		break;
 

