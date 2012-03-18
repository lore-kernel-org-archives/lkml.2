Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753994Ab2CRI0Z (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Mar 2012 04:26:25 -0400
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:47790
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752677Ab2CRI0V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Mar 2012 04:26:21 -0400
Date: Sun, 18 Mar 2012 04:26:19 -0400
From: Christoph Hellwig <hch@infradead.org>
To: xfs@oss.sgi.com
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: XFS status update for February 2012
Message-ID: <20120318082619.GA28069@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

February has been been busy with development for Linux 3.3, although only
little new code made it to the development tree yet, mostly a refactor
of the log grant code.  Patch traffic on the mailing list included a rewrite
of disk quota caching, yielding dramatic performance improvements for systems
with lots of quotas, a series to make all inode updates and thus all live
metadata updates transactional.  Last but not least a version versions to
fix a long standing bug in support of the real time subvolume was posted,
showing that even this long deprecated feature still has a user base.

On the userspace side development has been quite, with just two fixes to
xfs_io committed to xfsprogs, while waiting for the long overdue 3.1.8
release.  Xfsdump has been entirely quite this month, again waiting for
a release, and xfstests saw only two commits either, although there are
still lots of outstanding patches on the list that haven't been reviewed
and/or applied.
