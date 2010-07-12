Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756115Ab0GLQia (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jul 2010 12:38:30 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:32826 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755900Ab0GLQi1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jul 2010 12:38:27 -0400
Date: Mon, 12 Jul 2010 12:38:26 -0400
From: Christoph Hellwig <hch@infradead.org>
To: xfs@oss.sgi.com, linux-kernel@vger.kernel.org
Subject: XFS status update for June 2010
Message-ID: <20100712163826.GA17164@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-08-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The month of June saw a few important bug fixes for the Linux 2.6.35
release candidates.  That includes ensuring that files used for the
swapext ioctl are writable to the user, and doing proper validation
of inodes coming from untrusted sources, such as NFS exporting and
the open by handle system calls.  The main work however has been
focused on development for the Linux 2.6.36 merge window, including
merging various patches that have been out on the mainline list
for a long time.  Highlights include further performance improvements
for sync heavy metadata workloads, stack space reduction in the
writeback path and improvements of the XFS tracing infrastructure.
Also after some discussion the remaining hooks for DMAPI are going
to be dropped in mainline.   As a replacement a tree containing
full DMAPI support with a slightly cleaner XFS interaction will be
hosted by SGI.

On the userspace side June was a rather slow month, with no updates
to xfsprogs and xfsdump at all, and just one new test case and a cleanup
applied to xfstests.
