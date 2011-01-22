Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752187Ab1AVUmU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Jan 2011 15:42:20 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:43363 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751236Ab1AVUmS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Jan 2011 15:42:18 -0500
Date: Sat, 22 Jan 2011 15:41:29 -0500
From: Christoph Hellwig <hch@infradead.org>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Pekka Enberg <penberg@kernel.org>, Daniel Walker <dwalker@codeaurora.org>,
        linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jesse Barnes <jbarnes@virtuousgeek.org>,
        Dima Zavin <dmitriyz@google.com>, Joe Perches <joe@perches.com>,
        davidb@codeaurora.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 0/7] Nexus One Support
Message-ID: <20110122204129.GA8666@infradead.org>
References: <20110121095658.1ab623fe@jbarnes-desktop>
 <1295632828.19880.22.camel@m0nster>
 <20110121100441.06a94482@jbarnes-desktop>
 <1295633882.19880.31.camel@m0nster>
 <AANLkTi=L+MW5-KLP_TKSxhstD8JEtBW=RKci5wSbZsd6@mail.gmail.com>
 <1295642995.19880.42.camel@m0nster>
 <1295643762.25868.31.camel@Joe-Laptop>
 <1295645098.22882.1.camel@m0nster>
 <AANLkTi=mvdfpCPefGeDr+eGxpSUr3is5jgugHtgB-m1w@mail.gmail.com>
 <20110122122018.GC5194@n2100.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110122122018.GC5194@n2100.arm.linux.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jan 22, 2011 at 12:20:18PM +0000, Russell King - ARM Linux wrote:
> I've asked Daniel in private whether he'd mind posting the original
> set of patches which he based his work on to this thread.
> 
> I suspect that the situation is that there's many patches which he's
> taken from the repository and consolidated them down into a nice set
> of easy to review patches.
> 
> One of the problems of preserving the micro-detail of history right
> from the early inception of support for a platform is that quite often
> the early support is buggy or broken - it might not even compile.  There
> may be 20 or so patches on top of that which eventually get it to a
> usable state.
> 
> Do we really want to put off people from reviewing patches because of
> the size of micro-development that happened prior to getting to a point
> where the result of that development is usable?

No, not at all.  And I'm really annoyed at all the pointless flaming
here as people obviously never had to massage a completely messy
repository into something submittable.  That usually doesn't just
include making useful commits, but also updates to current APIs, bug
fixing, removing crap that should never make it's way upstream (and
Android had quite a lot of the latter last time I looked).

The only think that Daniel did wrong was to not attribute the original
authors in the commit message, and not explaining his own contribution.

