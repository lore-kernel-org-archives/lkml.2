Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932404Ab1COQik (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Mar 2011 12:38:40 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:46982 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932283Ab1COQih (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Mar 2011 12:38:37 -0400
Date: Tue, 15 Mar 2011 12:38:37 -0400
From: Christoph Hellwig <hch@infradead.org>
To: xfs@oss.sgi.com, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: XFS status update for February 2011
Message-ID: <20110315163836.GA10748@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

February saw the stabilization of the Linux 2.6.38 tree, with just two
small XFS fixes going into Linus' tree, and the XFS development tree
has been similarly quite with just a few cleanups, and the delaylog option
propagated to the default operation mode.  A few more patches for the 2.6.39
merge window have been posted and/or discussed on the mailing list, but February
was a rather quite month in general.

On the user space side xfsprogs saw a few bug fixes, and a speedup for
phase2 of xfs_repair, xfsdump saw a bug fix and support for pruning the
inventory by session id, and xfstests saw it's usual stream of bug fixes
as well as two new test cases.
