Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752618Ab1GYSls (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jul 2011 14:41:48 -0400
Received: from oproxy7-pub.bluehost.com ([67.222.55.9]:33392 "HELO
	oproxy7-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751350Ab1GYSlp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jul 2011 14:41:45 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=xenotime.net;
	h=Received:Date:From:To:Cc:Subject:Message-Id:Organization:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=upKAIPPV3O5jrsrohs2zNaUKDDI2JrLS1YFnoPMtQsM1HRA8QWTC4X6GyR4qIALsom0T7/HzUmg6rjDpeOnzxnIkJYKEae18Q357hfgeNEmYu9eeZUooy6kCg7j99RxQ;
Date: Mon, 25 Jul 2011 11:41:42 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
To: lkml <linux-kernel@vger.kernel.org>
Cc: viro <viro@zeniv.linux.org.uk>, akpm <akpm@linux-foundation.org>
Subject: [PATCH] fs: fix dcache.c new kernel-doc warning
Message-Id: <20110725114142.c2f5cbed.rdunlap@xenotime.net>
Organization: YPO4
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {1807:box742.bluehost.com:xenotime:xenotime.net} {sentby:smtp auth 50.53.38.135 authed with rdunlap@xenotime.net}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <rdunlap@xenotime.net>

Fix new kernel-doc warning in fs/dcache.c:

Warning(fs/dcache.c:797): No description found for parameter 'sb'

Signed-off-by: Randy Dunlap <rdunlap@xenotime.net>
---
 fs/dcache.c |    1 +
 1 file changed, 1 insertion(+)

--- linux-3.0-git4.orig/fs/dcache.c
+++ linux-3.0-git4/fs/dcache.c
@@ -784,6 +784,7 @@ relock:
 
 /**
  * prune_dcache_sb - shrink the dcache
+ * @sb: superblock
  * @nr_to_scan: number of entries to try to free
  *
  * Attempt to shrink the superblock dcache LRU by @nr_to_scan entries. This is
