Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755018Ab1ABHeY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Jan 2011 02:34:24 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:46632 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754884Ab1ABHeG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Jan 2011 02:34:06 -0500
Date: Sun, 2 Jan 2011 02:34:05 -0500
From: Christoph Hellwig <hch@infradead.org>
To: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        xfs@oss.sgi.com
Subject: XFS status update for December 2010
Message-ID: <20110102073405.GA32611@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The release process of the Linux 2.6.37 kernel with it's large XFS updates
was in it's final days in December, which explains why we only saw a single
one-liner regression fix for XFS in Linus' tree.  The XFS development tree
finally saw some updates when the writeback updates and some small cleanups
to the allocator and log recovery code were merged, but the large metadata
scalability updates that have been posted to the list multiple times are
still missing.  In addition to this on-going work the list also saw patches
that fix smaller issues, which are also still waiting to be merged.

On the userspace side xfsprogs and xfsdump development has been quit, with
no commits to either repository in December, although a large series of
updates to the metadump command has been reposted near the end of the month.
The xfstests repository saw a new regression test for a btrfs problem,
and various updates to existing tests.
