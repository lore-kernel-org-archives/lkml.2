Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752957Ab1DSPiP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Apr 2011 11:38:15 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:16432 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752176Ab1DSPiO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Apr 2011 11:38:14 -0400
Date: Tue, 19 Apr 2011 08:38:06 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: lkml <linux-kernel@vger.kernel.org>
Cc: axboe@kernel.dk
Subject: [PATCH] block: fix new kernel-doc warning in blk-core
Message-Id: <20110419083806.708d94be.randy.dunlap@oracle.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt357.oracle.com [141.146.40.157]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090201.4DADAC61.009C:SCFSTAT5015188,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>

Fix new blk-core.c kernel-doc warning:

Warning(block/blk-core.c:302): Excess function parameter 'force_kblockd' description in '__blk_run_queue'

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
---
 block/blk-core.c |    1 -
 1 file changed, 1 deletion(-)

--- lnx-2639-rc4.orig/block/blk-core.c
+++ lnx-2639-rc4/block/blk-core.c
@@ -292,7 +292,6 @@ EXPORT_SYMBOL(blk_sync_queue);
 /**
  * __blk_run_queue - run a single device queue
  * @q:	The queue to run
- * @force_kblockd: Don't run @q->request_fn directly.  Use kblockd.
  *
  * Description:
  *    See @blk_run_queue. This variant must be called with the queue lock
