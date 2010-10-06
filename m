Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751304Ab0JFJlx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Oct 2010 05:41:53 -0400
Received: from canuck.infradead.org ([134.117.69.58]:43025 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750947Ab0JFJlw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Oct 2010 05:41:52 -0400
Date: Wed, 6 Oct 2010 05:41:52 -0400
From: Christoph Hellwig <hch@lst.de>
To: xfs@oss.sgi.com, linux-kernel@vger.kernel.org
Subject: XFS status update for September 2010
Message-ID: <20101006094152.GA24239@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-08-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by canuck.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mainline activity has been rather low in September while with only
two more fixes going into the 2.6.36 release candidates after the
large merge activity in August.  Development for the next merge
window has been more active.  The largest item was the inclusion
of the metadata scalability patch series, which provides very large
speedups for parallel metadata operations.  In addition a new
ioctl to punch holes and convert the whole to an unwritten extent
was added and a small number of cleanups also made it into the tree.

Patches to add support for 32bit wide project ID identifiers and
using group and project quotas concurrently were posted to the list
and discussed but not yet included.

Userspace development has been rather quited again, with a single fix
committed to xfsprogs and xfsdump each.  The xfstests test suite grew
a new test case and received a few additional fixes.  Last but not least
the XFS Users Guide [1] was updated with various factual corrections
and spelling fixes.

[1] http://xfs.org/docs/xfsdocs-xml-dev/XFS_User_Guide//tmp/en-US/html/index.html
