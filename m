Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752571Ab1BZSzE (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Feb 2011 13:55:04 -0500
Received: from rcsinet10.oracle.com ([148.87.113.121]:32750 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752445Ab1BZSzC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Feb 2011 13:55:02 -0500
Date: Sat, 26 Feb 2011 10:54:00 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
To: lkml <linux-kernel@vger.kernel.org>
Cc: torvalds <torvalds@linux-foundation.org>
Subject: [PATCH] fs/block_dev.c: fix new kernel-doc warning
Message-Id: <20110226105400.c70faa11.randy.dunlap@oracle.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt353.oracle.com [141.146.40.153]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090207.4D694C82.0053:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>

Fix new kernel-doc warning in fs/block_dev.c:

Warning(fs/block_dev.c:937): No description found for parameter 'kill_dirty'

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
---
 fs/block_dev.c |    1 +
 1 file changed, 1 insertion(+)

--- linux-2.6.38-rc6-git6.orig/fs/block_dev.c
+++ linux-2.6.38-rc6-git6/fs/block_dev.c
@@ -928,6 +928,7 @@ EXPORT_SYMBOL_GPL(bd_unlink_disk_holder)
  * flush_disk - invalidates all buffer-cache entries on a disk
  *
  * @bdev:      struct block device to be flushed
+ * @kill_dirty: flag to guide handling of dirty inodes
  *
  * Invalidates all buffer-cache entries on a disk. It should be called
  * when a disk has been changed -- either by a media change or online
