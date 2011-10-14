Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932832Ab1JNNLo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Oct 2011 09:11:44 -0400
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:43173
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751899Ab1JNNLn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Oct 2011 09:11:43 -0400
Date: Fri, 14 Oct 2011 09:11:42 -0400
From: Christoph Hellwig <hch@infradead.org>
To: xfs@oss.sgi.com
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: XFS status update for September 2011
Message-ID: <20111014131142.GA997@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

August saw further release candidates of Linux 3.1, which had been
completely uneventful with just a single small regression fix being
merged.

In the meantime developments for the Linux 3.2 kernel went on with the merge
of a large series that completely refactors the XFS-internal xfs_bmapi
interfaces for simpler interfaces and less stack usage, as well as various
smaller cleanups and fixes.

September also was a very busy month for userspace development. In xfsprogs
we saw various error handling fixes to libxcmd, libxfs, mkfs.xfs, xfs_quota
and xfs_repair, xfsdump saw a few smaller changes finishing up the large
work done in August.  Xfstests saw 4 new test cases contributed from
various developers, and the usual handful of bug fixes.
