Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753317Ab1LLOtl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Dec 2011 09:49:41 -0500
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:43553
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752274Ab1LLOtj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Dec 2011 09:49:39 -0500
Date: Mon, 12 Dec 2011 09:49:38 -0500
From: Christoph Hellwig <hch@infradead.org>
To: xfs@oss.sgi.com
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: XFS status update for November 2011
Message-ID: <20111212144938.GA25014@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

November saw stabilization of the Linux 3.2 release candidates, including
a few fixes for XFS.  In addition a lot of bug fixes were backported to
the 3.0 long term stable and 3.1-stable releases for users not on
bleeding edge kernels.

At the same time development for Linux 3.3 went on at a fast pace, although
no pages were merged into the development tree yet.  The highlights are:

 - further versions of the patches to log all file size updates instead of
   relying the the flaky VM writeback code for them
 - an initial version of SEEK_HOLE/SEEK_DATA support
 - removal of the old non-delaylog logging code, and cleanups resulting
   from the removal
 - large updates for the quota code

Userspace development was even more busy:

Xfsprogs saw the rushed 3.1.7 release which contains Debian packaging fixes,
a polish translation update and a xfs_repair fix.  In the meantime a lot of
xfs_repair fixes were posted but mostly not reviewed and commit yet.

Xfsdump grew support for using pthreads to write backup streams to multiple
tapes in parallel, and SGI_XFSDUMP_SKIP_FILE which has been deprecated in
favor of the nodump flag has finally been removed.

Xfstests saw an enormous amount of updates.  The fsstress tool saw major
updates to exercise even more system calls, and found numerous bugs in
all major Linux filesystems, additional ENOSPC tests, a new test for
btrfs-specific functionality and the usual amount of bug fixes and small
cleanups.  Also a series to clean up the very large filesystem testing,
including extending the support to ext4 was posted but not committed yet.
