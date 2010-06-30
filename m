Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757399Ab0F3W1P (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jun 2010 18:27:15 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:16685 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754646Ab0F3W1O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jun 2010 18:27:14 -0400
Date: Wed, 30 Jun 2010 15:27:01 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: lkml <linux-kernel@vger.kernel.org>
Cc: Christoph Hellwig <hch@lst.de>, Jens Axboe <jaxboe@fusionio.com>
Subject: [PATCH] fs-writeback: fix kernel-doc warnings
Message-Id: <20100630152701.0c476a44.randy.dunlap@oracle.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt353.oracle.com [141.146.40.153]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A0B020B.4C2BC4B8.0186:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>

Fix kernel-doc to match the function's changed args.

Warning(fs/fs-writeback.c:190): No description found for parameter 'args'
Warning(fs/fs-writeback.c:190): Excess function parameter 'sb' description in 'bdi_queue_work_onstack'

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Jens Axboe <jaxboe@fusionio.com>
---
 fs/fs-writeback.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- linux-2.6.35-rc3-git4.orig/fs/fs-writeback.c
+++ linux-2.6.35-rc3-git4/fs/fs-writeback.c
@@ -179,7 +179,7 @@ static void bdi_alloc_queue_work(struct 
 
 /**
  * bdi_queue_work_onstack - start and wait for writeback
- * @sb: write inodes from this super_block
+ * @args: parameters to control the work queue writeback
  *
  * Description:
  *   This function initiates writeback and waits for the operation to
