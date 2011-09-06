Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754382Ab1IFMDp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Sep 2011 08:03:45 -0400
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:41637
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754046Ab1IFMDl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Sep 2011 08:03:41 -0400
Date: Tue, 6 Sep 2011 08:03:40 -0400
From: Christoph Hellwig <hch@infradead.org>
To: xfs@oss.sgi.com, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: XFS status update for August 2011
Message-ID: <20110906120340.GA19636@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

August saw further release candidates of Linux 3.1, which had been quite
for XFS except for the bulk renaming of many XFS source files so that all
source files are now located directly underneath the fs/xfs/ directory.

A lot of development for the Linux 3.2 kernel series was going on,
including an overhaul of the data I/O completion handler, further buffer
cache speedups and cleanups, a major refactoring around xfs_bmapi, quota
locking changes, and optimization for direct I/O on high IOP solid state
devices.

On the userspace side xfsdump saw a lot of cleanups in preparation of porting
the multithreaded dump and restore code from IRIX.  Xfsprogs saw a few fix
to the xfs_quota tool and mkfs.xfs as well as a man page update.  This month
xfstests did not see any new test cases, but it got the usual amount of fixes
and  grew support for jfs and NFS v4.
