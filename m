Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756850Ab2EHPfy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2012 11:35:54 -0400
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:34255
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756249Ab2EHPfw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2012 11:35:52 -0400
Date: Tue, 8 May 2012 11:35:51 -0400
From: Christoph Hellwig <hch@infradead.org>
To: xfs@oss.sgi.com
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: XFS status update for April 2012
Message-ID: <20120508153551.GB8176@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

April was a relatively quite month in XFS development, partially because
most XFS developers traveled to San Francisco for the Linux Filesystem
and Storage Summit and the first XFS developers meeting co hosted at the
Linux Foundation Collaboration Summit.

The XFS development tree only saw a series to reduce ilock hold times and
a few patches merged.  Traffic on the mailing list list has been a bit more
busy, with a few patchset being reposted again and again after various
updates.  Features still scheduled for Linux 3.5 include:  removal of
the xfsbufd daemon, various other cleanups of the buffer layer, moving
CIL commits into a background thread and thus reducing the impact on
threads causing the commits, as well as a bigger than usual set of
cleanups and fixes.

The user space side as been extremely slow with no patches applied and
very few posted to the mailing list.
