Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754673Ab1EDQBZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 May 2011 12:01:25 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:36174 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751764Ab1EDQBX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 May 2011 12:01:23 -0400
Date: Wed, 4 May 2011 12:01:22 -0400
From: Christoph Hellwig <hch@infradead.org>
To: xfs@oss.sgi.com, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: XFS status update for April 2011
Message-ID: <20110504160122.GA7224@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

April saw further stabilization work on the Linux 2.6.39 kernel, including
a number of XFS bug fixes.  Most importantly a series of patches fixes various
OOM problems due to bad interactions between the generic writeback code
and XFS inode reclaim, but there also were other patches for various smaller
issues.  In the meantime the XFS development tree saw the addition of the
optimized busy extent tracking, which allows large speedups for multi-threaded
meta data heavy workloads, and lays the groundwork for discard support on
transaction commit, and a few other smaller patches.

On the user space side the xfsprogs and xfsdump repositories saw a very quiet
month with no applied patches, although a few were posted and discussed on
the mailing list. The xfstests repository on the other hand saw a new test
cases exercising the xfs_metadump functionally as well as a fixes to existing
tests.
