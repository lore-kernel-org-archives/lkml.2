Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756498Ab2BYMCT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Feb 2012 07:02:19 -0500
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:38724
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753279Ab2BYMCR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Feb 2012 07:02:17 -0500
Date: Sat, 25 Feb 2012 07:02:16 -0500
From: Christoph Hellwig <hch@infradead.org>
To: xfs@oss.sgi.com
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: XFS status update for January 2012
Message-ID: <20120225120216.GA21721@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

January saw the release of Linux 3.2, which as usual included a large
number of XFS changes, most notably an large speedup for removing files
that have external attribute blocks, speedups and livelock fixes for
sync while doing heavy I/O, and large internal cleanups of the inode
block map handling.  The diffstat for XFS in Linux 3.2 is:

 54 files changed, 2414 insertions(+), 2625 deletions(-)

which is slightly below the average of the last releases.

In the meantime development for 3.3 went ahead full speed, including
the removal of the deprecated pre-delaylog logging code, various
quota cleanups, a shrink of the inode, a great simplification of the file
write path as well as the usual batch of fixes and cleanups.

On the userland side xfs_repair saw various major fixes and speedups,
with few other fixes thrown in, while xfsdump got two commits fixing
longer standing issues recently reported on the mailing list.  For
xfstests January was an extremely slow month, seeing only two new test cases
and less than a handful of other updates.
