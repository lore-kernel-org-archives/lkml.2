Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756735Ab2IMIE3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Sep 2012 04:04:29 -0400
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:57141
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756631Ab2IMIEV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Sep 2012 04:04:21 -0400
Date: Thu, 13 Sep 2012 04:04:20 -0400
From: Christoph Hellwig <hch@infradead.org>
To: xfs@oss.sgi.com, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: XFS status update for August 2012
Message-ID: <20120913080420.GA9775@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

After the release of Linux 3.5 in July, August saw the big XFS merge for
the Linux 3.6 merge window.  In the meantime the XFS tree has seen low
activity, with refined support for SEEK_HOLE/SEEK_DATA that takes unwritten
extents into account as the main feature.  A couple of fixes also went in
and mostly got back ported to mainline for Linux 3.5 as well.

The mailing list had a lot of traffic about interesting updates that didn't
make it into the tree yet, with the most interesting being: remount support
for the inode64 option, a patch series allowing to trim back large
preallocations when the filesystem is out of space, and a large rewrite
of the XFS-internal sync code.

On the user land side xfs_db saw a fix for a very long standing bug go into
the tree and xfstests saw a few fixes.  The mailing list list saw various other
interesting updates including a German translation for the xfsdump messages,
32-bit project ID support in xfsdump, a lot of xfstests updates including a
patch to use the upstream util-linux version of fstrim in xfstests, support
for tmpfs in xfstests, various ext3 and btrfs updates, but none of them
made it into the git tree.  There also was a lot of discussion of older
patch to reorganize the xfstests source tree.
