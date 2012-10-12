Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751634Ab2JLUCf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Oct 2012 16:02:35 -0400
Received: from p3plsmtps2ded03.prod.phx3.secureserver.net ([208.109.80.60]:52973
	"EHLO p3plsmtps2ded03.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751331Ab2JLUCd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Oct 2012 16:02:33 -0400
x-originating-ip: 72.167.245.219
From: "K. Y. Srinivasan" <kys@microsoft.com>
To: gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org,
        devel@linuxdriverproject.org, olaf@aepfle.de, apw@canonical.com,
        jasowang@redhat.com
Cc: "K. Y. Srinivasan" <kys@microsoft.com>
Subject: [PATCH 1/3] Drivers: hv: Get rid of unnecessary forward declarations
Date: Fri, 12 Oct 2012 13:22:41 -0700
Message-Id: <1350073363-10614-1-git-send-email-kys@microsoft.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1350073335-10575-1-git-send-email-kys@microsoft.com>
References: <1350073335-10575-1-git-send-email-kys@microsoft.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Get rid of unnecessary forward declarations.

Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
Reviewed-by: Haiyang Zhang <haiyangz@microsoft.com>
Reported-by: Jason Wang <jasowang@redhat.com>
---
 drivers/hv/channel.c |    8 --------
 1 files changed, 0 insertions(+), 8 deletions(-)

diff --git a/drivers/hv/channel.c b/drivers/hv/channel.c
index 4065374..1bb1a80 100644
--- a/drivers/hv/channel.c
+++ b/drivers/hv/channel.c
@@ -33,14 +33,6 @@
 #define NUM_PAGES_SPANNED(addr, len) \
 ((PAGE_ALIGN(addr + len) >> PAGE_SHIFT) - (addr >> PAGE_SHIFT))
 
-/* Internal routines */
-static int create_gpadl_header(
-	void *kbuffer,	/* must be phys and virt contiguous */
-	u32 size,	/* page-size multiple */
-	struct vmbus_channel_msginfo **msginfo,
-	u32 *messagecount);
-static void vmbus_setevent(struct vmbus_channel *channel);
-
 /*
  * vmbus_setevent- Trigger an event notification on the specified
  * channel.
-- 
1.7.4.1

