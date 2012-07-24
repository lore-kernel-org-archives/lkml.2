Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754343Ab2GXNlC (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jul 2012 09:41:02 -0400
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:54337
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753140Ab2GXNlA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jul 2012 09:41:00 -0400
Date: Tue, 24 Jul 2012 09:40:59 -0400
From: Christoph Hellwig <hch@infradead.org>
To: xfs@oss.sgi.com, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: XFS status update for June 2012
Message-ID: <20120724134059.GA25901@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

June has been a pretty slow month for XFS in Linus tree, as June saw the
stabilization of the Linux 3.5 and thus only a handful of important XFS
fixes.  Development of the tree destined for the next merge window has been
a bit more busy with the addition of discontinuous buffers that replace the
dabuf layer which has performance issues and isn't easy to deal with in the
upcoming metadata checksumming as well as a few smaller cleanups.

The list saw various other patches not applied yet, most notable a
refactoring and speedup of the inode allocator, and a heavily discussed
rewrite of the mount option parsing.

On the user space side a small number of fixes to the handling of fragmented
directories were applied to xfs_repair, and xfstests saw a fix for handling
different versions of xfsdump.
