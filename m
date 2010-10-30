Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753493Ab0J3NdT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Oct 2010 09:33:19 -0400
Received: from swampdragon.chaosbits.net ([90.184.90.115]:25798 "EHLO
	swampdragon.chaosbits.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751142Ab0J3NdQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Oct 2010 09:33:16 -0400
Date: Sat, 30 Oct 2010 15:23:01 +0200 (CEST)
From: Jesper Juhl <jj@chaosbits.net>
To: linux-rdma@vger.kernel.org
cc: Roland Dreier <rolandd@cisco.com>, Sean Hefty <sean.hefty@intel.com>,
        Hal Rosenstock <hal.rosenstock@gmail.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH] infiniband: mutex header included twice in cxgb4 header
Message-ID: <alpine.LNX.2.00.1010301519010.7979@swampdragon.chaosbits.net>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

drivers/infiniband/hw/cxgb4/iw_cxgb4.h includes 'linux/mutex.h' twice, 
this removes the duplicate.

(please CC me on replies)


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
Plain text mails only, please      http://www.expita.com/nomime.html
Don't top-post  http://www.catb.org/~esr/jargon/html/T/top-post.html

