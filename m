Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752529Ab1KEJcV (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Nov 2011 05:32:21 -0400
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:38116
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752358Ab1KEJcT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Nov 2011 05:32:19 -0400
Date: Sat, 5 Nov 2011 05:32:19 -0400
From: Christoph Hellwig <hch@infradead.org>
To: xfs@oss.sgi.com
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: XFS status update for October 2011
Message-ID: <20111105093219.GA5303@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

October finally saw the delayed release of Linux 3.1, which is a fairly
boring release as XFS is concerned.  In addition to a few bug fixes
and cleanups the biggest item is an XFS-internal re organization of the
source files, dropping all sub directories under fs/xfs.

Due to the long Linux 3.1 release cycle development for 3.3 has already
started full steam in October while adding a few more small optimization
and fixes to the development tree for Linux 3.2, and merging that tree
into mainline.

Notable items for Linux 3.2 are speedup for parallel O_DIRECT reads and
writes on high IOPS devices, optimizations for fsync(2) on directories
and sync(2) latency, as well as further small improvements for metadata
performance on highly parallel workloads.

On the user space side xfsprogs saw a few more xfs_repair fixes, as well
as some updates of mount point handling for the xfs_quota tools, which
together with the updates from the last months was published in form
of the xfsprogs 3.1.6 release.  This was accompanied by an xfsdump
3.0.6 release, which does not include any new updates in October, but
lots of work from the previous month.  Xfstests saw two additional
test cases and various fixes, and it's first versioned release ever.
