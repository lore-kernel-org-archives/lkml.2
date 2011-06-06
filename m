Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757864Ab1FFTex (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jun 2011 15:34:53 -0400
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:54264
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753716Ab1FFTev (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jun 2011 15:34:51 -0400
Date: Mon, 6 Jun 2011 15:34:51 -0400
From: Christoph Hellwig <hch@infradead.org>
To: xfs@oss.sgi.com, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: XFS status update for May 2011
Message-ID: <20110606193451.GA9800@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

May finally saw the release of Linux 2.6.39, which was a little more calm
than usual for XFS, and only contains about half the amount of the changes
we are used to see:

  58 files changed, 1660 insertions(+), 1912 deletions(-)

The most visible change is an overhaul of the XFS-internal interfaces
to print kernel messages, which makes all messages from XFS look slightly
different from before by always providing information about which device
these messages relate to.  In addition to that support for the RT subvolume,
which had been broken for a while has been resurrect, the XFS buffer cache
switched away from using the Linux pagecache to improve performance on
metadata intensive workloads, and all but one of the XFS kernel threads have
been switched to the new concurrent managed workqueue infrastructure that
is present in more recent Linux 2.6 releases.

In the meantime development for the release now known as Linux 3.0 went
ahead full steam up to the merge of the XFS tree into Linux 3.0-rc1. News
in that release contain support for vastly improved busy extent tracking,
support for online discard (aka TRIM) and the usual amount of bug fixes.

On the user space side the xfsprogs saw a fix for a corner case in xfs_repair,
and xfstests saw a few bug fixes as well as a new test case to test
btrfs-specific functionality.
