Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751338Ab2HMJPT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2012 05:15:19 -0400
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:33912
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750834Ab2HMJPR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2012 05:15:17 -0400
Date: Mon, 13 Aug 2012 05:15:17 -0400
From: Christoph Hellwig <hch@infradead.org>
To: xfs@oss.sgi.com, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: XFS status update for July 2012
Message-ID: <20120813091517.GA27609@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

July saw the release of Linux 3.5, which included an average sized XFS
update:

    81 files changed, 2633 insertions(+), 3004 deletions(-)

Noteworthy updates in Linux 3.5 include the removal of the xfsbufd
background thread which writes metadata buffers, background processing
of CIL flushes and thus lower average latency for metadata heavy
workloads, as well a a reduction of lock hold times and frequency during
reads and writes.  The large XFS update for the Linux 3.6 merge window
did not get merged yet by the end of July, but will bring better support
for large directory block sizes, a faster inode allocator and a large
amount of bug fixes in different areas of the code.  Development on the list
has been fairly busy on the patchsets to support group and project quotas
at the same time, as well as improved SEEK_HOLE/SEEK_DATA support but
otherwise mostly limited to bug fixes and smaller cleanups.

Userpace development has been rather slow with a single fix for xfs_db
and another single fix in xfstests.
