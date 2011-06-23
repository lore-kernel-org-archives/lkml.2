Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933693Ab1FWWHa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jun 2011 18:07:30 -0400
Received: from swampdragon.chaosbits.net ([90.184.90.115]:23832 "EHLO
	swampdragon.chaosbits.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759952Ab1FWWHY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jun 2011 18:07:24 -0400
Date: Thu, 23 Jun 2011 23:58:30 +0200 (CEST)
From: Jesper Juhl <jj@chaosbits.net>
To: LKML <linux-kernel@vger.kernel.org>
cc: trivial@kernel.org, linux-media@vger.kernel.org,
        ceph-devel@vger.kernel.org,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Sage Weil <sage@newdream.net>
Subject: [PATCH 03/37] Remove unneeded version.h includes from include/
In-Reply-To: <alpine.LNX.2.00.1106232344480.17688@swampdragon.chaosbits.net>
Message-ID: <alpine.LNX.2.00.1106232356530.17688@swampdragon.chaosbits.net>
References: <alpine.LNX.2.00.1106232344480.17688@swampdragon.chaosbits.net>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It was pointed out by 'make versioncheck' that some includes of
linux/version.h were not needed in include/.
This patch removes them.

Signed-off-by: Jesper Juhl <jj@chaosbits.net>
---
 include/linux/ceph/messenger.h |    1 -
 include/media/pwc-ioctl.h      |    1 -
 2 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/include/linux/ceph/messenger.h b/include/linux/ceph/messenger.h
index 31d91a6..291aa6e 100644
--- a/include/linux/ceph/messenger.h
+++ b/include/linux/ceph/messenger.h
@@ -6,7 +6,6 @@
 #include <linux/net.h>
 #include <linux/radix-tree.h>
 #include <linux/uio.h>
-#include <linux/version.h>
 #include <linux/workqueue.h>
 
 #include "types.h"
diff --git a/include/media/pwc-ioctl.h b/include/media/pwc-ioctl.h
index 0f19779..1ed1e61 100644
--- a/include/media/pwc-ioctl.h
+++ b/include/media/pwc-ioctl.h
@@ -53,7 +53,6 @@
  */
 
 #include <linux/types.h>
-#include <linux/version.h>
 
 /* Enumeration of image sizes */
 #define PSZ_SQCIF	0x00
-- 
1.7.5.2


-- 
Jesper Juhl <jj@chaosbits.net>       http://www.chaosbits.net/
Don't top-post http://www.catb.org/jargon/html/T/top-post.html
Plain text mails only, please.

