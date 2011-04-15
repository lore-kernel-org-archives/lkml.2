Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755643Ab1DOKab (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Apr 2011 06:30:31 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:36971 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753862Ab1DOKa3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Apr 2011 06:30:29 -0400
Date: Fri, 15 Apr 2011 06:30:28 -0400
From: Christoph Hellwig <hch@infradead.org>
To: xfs@oss.sgi.com
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: XFS status update for March 2011
Message-ID: <20110415103028.GA19528@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

March saw the release of Linux 2.6.39, which included a sizable XFS update.
The most prominent new features of XFS in Linux 2.6.39 is support for the
FITRIM ioctl that allows discarding unused space on the filesystem
periodically, better handling of persistent preallocations especially on
NFS servers, and further scalability improvements in the buffer cache
and log code.  In additions to that the release includes a wide range
of fixes and cleanups to the code base.  The diff stat for XFS in the
Linux 2.6.39 release is:

  57 files changed, 2964 insertions(+), 2528 deletions(-)

Which means the XFS code base actually had a minor growth in code size
this time around.  In the second half of March the XFS development
tree got merged into Linus' tree for Linux 2.6.39.  Linux 2.6.39 is going
to be a rather quiet release for XFS, mostly concentrating on settling
the large changes that went into the last releases and smaller cleanups.
The only user visible change will be that the delaylog option which
improves metadata performance and scalability is now turned on by default,
and a couple of fixes that make the realtime subvolume support usable
again.

On the user space side both xfsprogs and xfsdump saw new releases in March.
The xfsprogs 3.1.5 release contains various smaller updates to xfs_repair,
xfs_metadump and xfs_quota, as well as support for the new generic hole
punching in the falloc system call in the xfs_io tool.  The xfsdump 3.0.5
release now supports up to 4 billion directory entries, has much better
performance for large dumps, and some improvements to the inventory code
and dumping of quota information, as well as long overdue updates to the
build system.  The xfstests repository has seen various build system
improvements, better FIEMAP testing, falloc support for fsx and a few
cleanups.
