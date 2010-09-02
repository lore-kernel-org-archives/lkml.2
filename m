Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754825Ab0IBPAB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Sep 2010 11:00:01 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:60950 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753719Ab0IBPAA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Sep 2010 11:00:00 -0400
Date: Thu, 2 Sep 2010 10:59:59 -0400
From: Christoph Hellwig <hch@infradead.org>
To: xfs@oss.sgi.com, linux-kernel@vger.kernel.org
Subject: XFS status update for August 2010
Message-ID: <20100902145959.GA27887@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-08-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

At the first of August we finally saw the release of Linux 2.6.35,
which includes a large XFS update.  The most prominent feature in
Linux 2.6.35 is the new delayed logging code which provides massive
speedups for metadata-intensive workloads, but there has been
a large amount of other fixes and cleanups, leading to the following
diffstat:

	 67 files changed, 4426 insertions(+), 3835 deletions(-)

Given the early release of Linux 2.6.35 the merge window for the
next release fully fell into the month of August.  The XFS updates
for Linux 2.6.36 include various additional performance improvements
in the delayed logging code, for direct I/O writes and for avoiding
synchronous transactions, as well as various fixed and large amount
of cleanups, including the removal of the remaining dead DMAPI
code.

On the userspace side we saw the 3.1.3 release of xfsprogs, which includes
various smaller fixes, support for the new XFS_IOC_ZERO_RANGE ioctl and
Debian packaging updates.  The xfstests package saw one new test case
and a couple of smaller patches, and xfsdump has not seen any updates at
all.

The XMLified versions of the XFS users guide, training labs and filesystem
structure documentation are now available as on the fly generated html on
the xfs.org website and can be found at:

	http://www.xfs.org/index.php/XFS_Papers_and_Documentation

