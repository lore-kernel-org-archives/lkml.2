Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756920Ab0KJQc3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Nov 2010 11:32:29 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:51453 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756824Ab0KJQc2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Nov 2010 11:32:28 -0500
Date: Wed, 10 Nov 2010 11:32:25 -0500
From: Christoph Hellwig <hch@infradead.org>
To: Nick Piggin <npiggin@kernel.dk>
Cc: Christoph Hellwig <hch@infradead.org>, Al Viro <viro@ZenIV.linux.org.uk>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [patch 4/6] fs: d_delete change
Message-ID: <20101110163224.GB15130@infradead.org>
References: <20101109124610.GB11477@amd>
 <20101109130133.GE11477@amd>
 <20101109162516.GB6217@infradead.org>
 <20101109220833.GG3246@amd>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101109220833.GG3246@amd>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 10, 2010 at 09:08:33AM +1100, Nick Piggin wrote:
> On Tue, Nov 09, 2010 at 11:25:16AM -0500, Christoph Hellwig wrote:
> > The patch looks fine to me, and I'm also fine with merging it ASAP.
> > But the patch subject and commit message are not very descriptive.
> 
> How is the commit message not descriptive? The first sentence
> summarises exactly what the change does. The last says why it
> is required. In the middle are some details.

foo change is about as useless as a subject could be.

"fs: idempotent d_delete" from your old tree was much better.

As far as the commit message is concerned I think the most important
bit is that we do not call it from prune_one_dentry anymore, which is
the things that might matter to any complex filesystem maintainer
looking at the changelog.

The other things I didn't like was the introductionary blurb, but from
reading the answer to the previous comment is seems like that wsn't
intentional anyway.
