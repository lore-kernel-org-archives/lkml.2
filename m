Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934790Ab2J3Vqt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2012 17:46:49 -0400
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:37372
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934165Ab2J3Vqr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2012 17:46:47 -0400
Date: Tue, 30 Oct 2012 17:46:46 -0400
From: Christoph Hellwig <hch@infradead.org>
To: xfs@oss.sgi.com, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: XFS status update for September 2012
Message-ID: <20121030214646.GA12771@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

September saw the release of Linux 3.6 which included a slightly smaller
than usual XFS update:

 51 files changed, 2607 insertions(+), 2455 deletions(-)

The bulk of the changes in Linux 3.6 is made up by native support for
discontinuous buffers, with various minor bug fixes and cleanups making up
the rest.  In the meantime the mailing list was busy with multiple revisions
of the sync/unmount code rewrite, and the patch series to make the inode64
mount option remountable and the default.

On the user space side xfsprogs saw new support for the preadv, pwritev and
sync_file_range system calls in xfs_io as well as minor fixes to libxcmd and
mkfs.xfs, xfsdump grew support for dumping and restoring 32-bit project ids
and and saw an update to the German translation.  Xfstests saw a large number
of fixes, and a single new test case.
