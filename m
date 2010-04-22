Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754774Ab0DVQ1N (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Apr 2010 12:27:13 -0400
Received: from 0122700014.0.fullrate.dk ([95.166.99.235]:51712 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754348Ab0DVQ1L (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Apr 2010 12:27:11 -0400
Date: Thu, 22 Apr 2010 18:27:10 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: =?iso-8859-1?Q?J=F6rn?= Engel <joern@logfs.org>,
       David Woodhouse <dwmw2@infradead.org>, linux-mtd@lists.infradead.org,
       linux-kernel@vger.kernel.org, Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] [MTD] Fix JFFS2 sync silent failure
Message-ID: <20100422162709.GJ27497@kernel.dk>
References: <20100417184016.GA17345@logfs.org> <20100419073843.GN27497@kernel.dk> <20100419101559.GA4145@logfs.org> <20100419102056.GS27497@kernel.dk> <20100422055448.GA27309@logfs.org> <20100422062631.GC27309@logfs.org> <alpine.LFD.2.00.1004220724170.9086@i5.linux-foundation.org> <alpine.LFD.2.00.1004220730280.9086@i5.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.1004220730280.9086@i5.linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 22 2010, Linus Torvalds wrote:
> 
> 
> On Thu, 22 Apr 2010, Linus Torvalds wrote:
> >
> > Umm. Why not just remove the two-liner? It was incorrect. The comment says 
> > "this should be safe", and if it wasn't, then the commit that caused this 
> > all was total crap to begin with.
> 
> Grr. Ok, so we do need it. Because Jens made it not work without it, and 
> didn't fix up the filesystems, just added a random comment saying "we 
> shouldn't need to".
> 
> Double-grr. I hate misleading comments. It makes the patch and the code 
> look like people knew what they were doing.

Yeah sorry, that part was apparently not well thought through. It did go
through review and testing, but at least the latter was not good enough.

> Jens - please help fix this up.

Of course, I already posted a series of patches to fix this up. I want
to test them a bit, and I'll send them in tomorrow.

-- 
Jens Axboe

