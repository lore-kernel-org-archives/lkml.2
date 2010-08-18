Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752010Ab0HRQiB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Aug 2010 12:38:01 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:57057 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751471Ab0HRQh6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Aug 2010 12:37:58 -0400
Date: Wed, 18 Aug 2010 12:37:58 -0400
From: Christoph Hellwig <hch@infradead.org>
To: xfs@oss.sgi.com, linux-kernel@vger.kernel.org
Subject: XFS status update for July 2010
Message-ID: <20100818163758.GA4321@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-08-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

July saw three more release candidates for the Linux 2.6.35 kernel, which
included a relatively large number of XFS updates.  There were two security
fixes, a small one to prevent swapext to operate on write-only file
descriptors, and a much larger one to properly validate inode numbers
coming from NFS clients or userspace applications using the bulkstat or
the open-by-handle interfaces.  In addition to that another relatively
large patch fixes the way inodes get reclaimed in the background, and
avoids inode caches growing out of bounds.

In the meantime the code for the Linux 2.6.36 got the last touches before
the expected opening of the merge window, by merging a few more last
minute fixes and cleanups.  The most notable one is a patch series
that fixes in-memory corruption when concurrently accessing unwritten
extents using the in-kernel AIO code.

The userspace side was still quite slow, but some a bit more activity
than June.  In xfsprogs the xfs_db code grew two bug fixes, as did
the xfs_io script.  The xfstests package saw one new test cases and
various fixes to existing code.  Last but not least a few patches
affecting the build system for all userspace tools were committed.
