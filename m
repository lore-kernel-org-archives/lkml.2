Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757575Ab0KKA1J (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Nov 2010 19:27:09 -0500
Received: from ipmail07.adl2.internode.on.net ([150.101.137.131]:14624 "EHLO
	ipmail07.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756719Ab0KKA1H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Nov 2010 19:27:07 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AvsEAAfF2kx5LcZK/2dsb2JhbACiPHK/cYVKBI9m
Date: Thu, 11 Nov 2010 11:27:02 +1100
From: Nick Piggin <npiggin@kernel.dk>
To: Christoph Hellwig <hch@infradead.org>
Cc: Nick Piggin <npiggin@kernel.dk>, Al Viro <viro@ZenIV.linux.org.uk>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [patch 4/6] fs: d_delete change
Message-ID: <20101111002702.GA3477@amd>
References: <20101109124610.GB11477@amd>
 <20101109130133.GE11477@amd>
 <20101109162516.GB6217@infradead.org>
 <20101109220833.GG3246@amd>
 <20101110163224.GB15130@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101110163224.GB15130@infradead.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 10, 2010 at 11:32:25AM -0500, Christoph Hellwig wrote:
> On Wed, Nov 10, 2010 at 09:08:33AM +1100, Nick Piggin wrote:
> > On Tue, Nov 09, 2010 at 11:25:16AM -0500, Christoph Hellwig wrote:
> > > The patch looks fine to me, and I'm also fine with merging it ASAP.
> > > But the patch subject and commit message are not very descriptive.
> > 
> > How is the commit message not descriptive? The first sentence
> > summarises exactly what the change does. The last says why it
> > is required. In the middle are some details.
> 
> foo change is about as useless as a subject could be.
> 
> "fs: idempotent d_delete" from your old tree was much better.

It's not only idempotent, though, so I thought it was better to
change it. Seeing as the change could not be summarised in a
changelog, at least the ambiguous subject would draw the reader
to look at the changelog.


> As far as the commit message is concerned I think the most important
> bit is that we do not call it from prune_one_dentry anymore, which is
> the things that might matter to any complex filesystem maintainer
> looking at the changelog.

See: first sentence of the changelog.


> The other things I didn't like was the introductionary blurb, but from
> reading the answer to the previous comment is seems like that wsn't
> intentional anyway.

Right, I'll switch to a different way of commenting that git-am
does not pick up.

