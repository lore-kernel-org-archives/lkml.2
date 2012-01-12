Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754942Ab2ALTCY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jan 2012 14:02:24 -0500
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:45605
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754853Ab2ALTCW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jan 2012 14:02:22 -0500
Date: Thu, 12 Jan 2012 14:02:21 -0500
From: Christoph Hellwig <hch@infradead.org>
To: xfs@oss.sgi.com
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: XFS status update for December 2011
Message-ID: <20120112190221.GA3108@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

December saw further stabilization of the Linux 3.2 release candidates.
For XFS that meant two important fixes for sync() data integrity, to
work around issues introduced in the VFS sync code in the past few
kernel releases.  These fixes have also been backported to the 3.0-stable
release.

Development for the next merge windows continue in fast pace, although
only a relatively small amount of patches was merged into the development
tree for the Linux 3.3 window.  The most interesting topic in December
probably was further development of the SEEK_DATA /  SEEK_HOLE support,
including defining the exact semantics in presence of unwritten extents
and proper test coverage.

On the user space side December was fairly quite, with about a handful
fixes commit to xfsprogs, two new test cases and a couple of fixes in
xfstests, and no activity in xfsdump.
