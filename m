Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751915Ab0EHTIt (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 May 2010 15:08:49 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:34195 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751095Ab0EHTIs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 May 2010 15:08:48 -0400
Date: Sat, 8 May 2010 15:08:43 -0400
From: Christoph Hellwig <hch@infradead.org>
To: xfs@oss.sgi.com, linux-kernel@vger.kernel.org
Subject: XFS status update for April 2010
Message-ID: <20100508190843.GA20445@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.19 (2009-01-05)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In April 2.6.34 still was in the release candidate phase, with
a hand full of XFS fixes making it into mainline.  Development for
the 2.6.35 merge window went ahead full steam at the same time.

While a fair amount of patches hit the development tree these were
largely cleanups, with the real development activity happening on
the mailing list.  There was another round of patches and following
discussion on the scalable busy extent tracking and delayed logging
features mentioned last month.  They are expected to be merged in
May and queue up for the Linux 2.6.35 window.  Last but not least
April saw a large number of XFS fixes backported to the 2.6.32 and
2.6.33 -stable series.

In user land xfsprogs has seen few but important updates, preparing
for a new release next month.  The xfs_repair tool saw a fix to
correctly enable the lazy superblock counters on an existing
filesystem, and xfs_fsr saw updates to better deal with dynamic
attribute forks.  Last but not a least a port to Debian GNU/kFreeBSD
got merged. The xfstests test suite saw two new test cases and various
smaller fixes.
