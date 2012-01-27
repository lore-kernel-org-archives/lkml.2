Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754395Ab2A0LCl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jan 2012 06:02:41 -0500
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:34607
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754322Ab2A0LCj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jan 2012 06:02:39 -0500
Date: Fri, 27 Jan 2012 06:02:38 -0500
From: Christoph Hellwig <hch@infradead.org>
To: HAYASAKA Mitsuo <mitsuo.hayasaka.hu@hitachi.com>
Cc: Christoph Hellwig <hch@infradead.org>, linux-kernel@vger.kernel.org,
        xfs@oss.sgi.com, xfs-masters@oss.sgi.com, Ben Myers <bpm@sgi.com>,
        Alex Elder <aelder@sgi.com>, Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 0/3] xfs: change available ranges in quota check
Message-ID: <20120127110238.GB31093@infradead.org>
References: <20120123034513.3339.97432.stgit@ltc219.sdl.hitachi.co.jp>
 <20120124174612.GC9853@infradead.org>
 <4F22424E.8070407@hitachi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4F22424E.8070407@hitachi.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 27, 2012 at 03:21:02PM +0900, HAYASAKA Mitsuo wrote:
> > Can you send a testcase that reproduces issues with the old behaviour?
> > 
> 
> Regarding (1) related to inode reservation, current xfs works well
> because inode is reserved one by one if required.
> 
> For example, when an new inode tries to be reserved in xfs_trans_dqresv(),
> it checks quota as follows.

I'm just curious what the intent behdind the patches was.  They look
good to me, but I wonder why we need to change it at all.

> To make it more general, this check should be the same way as the new
> block quota check introduced in the PATCH 2/3 where the disk block can
> be used up to the block quota limits.

So I guess that's the part we'd want a test case for if possible.

