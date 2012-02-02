Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755918Ab2BBUR5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Feb 2012 15:17:57 -0500
Received: from swampdragon.chaosbits.net ([90.184.90.115]:11148 "EHLO
	swampdragon.chaosbits.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753427Ab2BBURz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Feb 2012 15:17:55 -0500
Date: Thu, 2 Feb 2012 21:18:16 +0100 (CET)
From: Jesper Juhl <jj@chaosbits.net>
To: linux-rdma@vger.kernel.org
cc: Bart Van Assche <bvanassche@acm.org>, Roland Dreier <roland@kernel.org>,
        Sean Hefty <sean.hefty@intel.com>,
        Hal Rosenstock <hal.rosenstock@gmail.com>,
        "Nicholas A. Bellinger" <nab@risingtidesystems.com>,
        linux-kernel@vger.kernel.org, trivial@kernel.org
Subject: [PATCH] Infiniband: Remove unneeded version.h include from
 drivers/infiniband/ulp/srpt/ib_srpt.h
Message-ID: <alpine.LNX.2.00.1202022116280.16704@swampdragon.chaosbits.net>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Jesper Juhl <jj@chaosbits.net>
---
 drivers/infiniband/ulp/srpt/ib_srpt.h |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/drivers/infiniband/ulp/srpt/ib_srpt.h b/drivers/infiniband/ulp/srpt/ib_srpt.h
index b4b4bbc..61e52b8 100644
--- a/drivers/infiniband/ulp/srpt/ib_srpt.h
+++ b/drivers/infiniband/ulp/srpt/ib_srpt.h
@@ -35,7 +35,6 @@
 #ifndef IB_SRPT_H
 #define IB_SRPT_H
 
-#include <linux/version.h>
 #include <linux/types.h>
 #include <linux/list.h>
 #include <linux/wait.h>
-- 
1.7.9


-- 
Jesper Juhl <jj@chaosbits.net>       http://www.chaosbits.net/
Don't top-post http://www.catb.org/jargon/html/T/top-post.html
Plain text mails only, please.

