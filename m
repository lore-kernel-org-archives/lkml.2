Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753799Ab1GUUuu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jul 2011 16:50:50 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:46332 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751532Ab1GUUut (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jul 2011 16:50:49 -0400
Date: Thu, 21 Jul 2011 21:50:42 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Christoph Hellwig <hch@infradead.org>
Cc: Randy Dunlap <rdunlap@xenotime.net>,
        Stephen Rothwell <sfr@canb.auug.org.au>, linux-mm@kvack.org,
        linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        akpm <akpm@linux-foundation.org>
Subject: Re: linux-next: Tree for July 18 (mm/truncate.c)
Message-ID: <20110721205042.GC31405@ZenIV.linux.org.uk>
References: <20110718203501.232bd176e83ff65f056366e6@canb.auug.org.au>
 <20110718081816.2106117e.rdunlap@xenotime.net>
 <20110718152117.GA8844@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110718152117.GA8844@infradead.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 18, 2011 at 11:21:18AM -0400, Christoph Hellwig wrote:
> On Mon, Jul 18, 2011 at 08:18:16AM -0700, Randy Dunlap wrote:
> > On Mon, 18 Jul 2011 20:35:01 +1000 Stephen Rothwell wrote:
> > 
> > > Hi all,
> > 
> > mm/truncate.c:612: error: implicit declaration of function 'inode_dio_wait'
> > 
> > mm/truncate.c should be #include-ing <linux/fs.h> for that function's
> > prototype, but that doesn't help when CONFIG_BLOCK is not enabled,
> > which is the case in this build failure.
> 
> Oops.  Two choices here:
> 
>  a) stub it out for non-blocks.
>  b) move it out of directio.c so that it's always provided.
> 
> I'd be fine with either one.  Al, any preferences?

None...
