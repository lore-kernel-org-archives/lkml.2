Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757782Ab0LTSAP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Dec 2010 13:00:15 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:57538 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753870Ab0LTSAO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Dec 2010 13:00:14 -0500
Date: Mon, 20 Dec 2010 13:00:13 -0500
From: Christoph Hellwig <hch@infradead.org>
To: xfs@oss.sgi.com, linux-kernel@vger.kernel.org
Subject: XFS status update for November 2010
Message-ID: <20101220180013.GA16283@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From looking at the kernel git commits November looked like a pretty
slow month with just two hand full fixes going into the release candidates
for Linux 2.6.37, and none at all going into the development tree.
But in this case git statistics didn't tell the whole story - there
was a lot of activity on patches for the next merge window on the list.
The focus in November was still at metadata scalability, with various
patchsets that improves parallel creates and unlinks again, and also
improves 8-way dbench throughput by 30%.  In addition to that there
were patches to improve preallocation for NFS servers, to simplify
the writeback code, and to remove the XFS-internal percpu counters
for free space for the generic kernel percpu counters, which just needed
a small improvement.

On the user space side we saw the release of xfsprogs 3.1.4, which
contains various accumulated bug fixes and Debian packaging updates.
The xfsdump tree saw a large update to speed up restore by using
mmap for an internal database and remove the limitation of ~ 214
million directory entries per dump file.  The xfstests test suite
saw three new testcases and various fixes, including support for the
hfsplus filesystem.
