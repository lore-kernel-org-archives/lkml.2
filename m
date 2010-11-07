Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752222Ab0KGWgF (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Nov 2010 17:36:05 -0500
Received: from swampdragon.chaosbits.net ([90.184.90.115]:23057 "EHLO
	swampdragon.chaosbits.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751417Ab0KGWgD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Nov 2010 17:36:03 -0500
Date: Sun, 7 Nov 2010 23:24:44 +0100 (CET)
From: Jesper Juhl <jj@chaosbits.net>
To: linux-kernel@vger.kernel.org
cc: trivial@kernel.org, linux-rdma@vger.kernel.org,
        Steve Wise <swise@chelsio.com>, Roland Dreier <rolandd@cisco.com>,
        Sean Hefty <sean.hefty@intel.com>,
        Hal Rosenstock <hal.rosenstock@gmail.com>
Subject: [PATCH][trivial] infiniband: Only include linux/mutex.h once in
 drivers/infiniband/hw/cxgb4/iw_cxgb4.h .
Message-ID: <alpine.LNX.2.00.1011072321150.26247@swampdragon.chaosbits.net>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Only include the header linux/mutex.h once inside 
drivers/infiniband/hw/cxgb4/iw_cxgb4.h

Signed-off-by: Jesper Juhl <jj@chaosbits.net>
---
 iw_cxgb4.h |    1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/infiniband/hw/cxgb4/iw_cxgb4.h b/drivers/infiniband/hw/cxgb4/iw_cxgb4.h
index 16032cd..42bb575 100644
--- a/drivers/infiniband/hw/cxgb4/iw_cxgb4.h
+++ b/drivers/infiniband/hw/cxgb4/iw_cxgb4.h
@@ -46,7 +46,6 @@
 #include <linux/timer.h>
 #include <linux/io.h>
 #include <linux/kfifo.h>
-#include <linux/mutex.h>
 
 #include <asm/byteorder.h>
 



-- 
Jesper Juhl <jj@chaosbits.net>             http://www.chaosbits.net/
Don't top-post  http://www.catb.org/~esr/jargon/html/T/top-post.html
Plain text mails only, please.

