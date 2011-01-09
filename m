Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752018Ab1AIDnM (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Jan 2011 22:43:12 -0500
Received: from rcsinet10.oracle.com ([148.87.113.121]:27669 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751114Ab1AIDnF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Jan 2011 22:43:05 -0500
Date: Sat, 8 Jan 2011 19:40:33 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
To: lkml <linux-kernel@vger.kernel.org>
Cc: Linus <torvalds@linux-foundation.org>, Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 5/6] pipe_fs_i.h: fix kernel-doc warning
Message-Id: <20110108194033.7c76d766.randy.dunlap@oracle.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.6.0 (GTK+ 2.14.4; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>

Fix kernel-doc notation warnings in pipe_fs_i.h:

Warning(include/linux/pipe_fs_i.h:58): No description found for parameter 'buffers'

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
---
 include/linux/pipe_fs_i.h |    1 +
 1 file changed, 1 insertion(+)

--- lnx0107.orig/include/linux/pipe_fs_i.h
+++ lnx0107/include/linux/pipe_fs_i.h
@@ -30,6 +30,7 @@ struct pipe_buffer {
  *	struct pipe_inode_info - a linux kernel pipe
  *	@wait: reader/writer wait point in case of empty/full pipe
  *	@nrbufs: the number of non-empty pipe buffers in this pipe
+ *	@buffers: total number of buffers (should be a power of 2)
  *	@curbuf: the current pipe buffer entry
  *	@tmp_page: cached released page
  *	@readers: number of current readers of this pipe
