Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754795Ab0HCBIP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Aug 2010 21:08:15 -0400
Received: from gate.crashing.org ([63.228.1.57]:52426 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754414Ab0HCBIO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Aug 2010 21:08:14 -0400
Subject: Re: linux-next: build failure after merge of the final tree (tip
 tree related)
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Russell King <rmk@arm.linux.org.uk>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        LKML <linux-kernel@vger.kernel.org>, linux-next@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <peterz@infradead.org>
In-Reply-To: <4C56F317.7030008@zytor.com>
References: <20100803022310.bec3ba79.sfr@canb.auug.org.au>
	 <20100802162810.GB4755@flint.arm.linux.org.uk> <4C56F317.7030008@zytor.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 03 Aug 2010 11:07:34 +1000
Message-ID: <1280797654.1902.79.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-08-02 at 09:32 -0700, H. Peter Anvin wrote:
> > Please, no, don't break the memblock code now.  I'm not reworking the
> > ARM implementation just as the merge window has opened - especially
> > as the ARM implementation has now been pulled into other people's
> > trees.
> > 
> > If there's changes to memblock which haven't been in linux-next (which,
> > as this is a new failure, that is most definitely the case), then they
> > shouldn't be going into this merge window.
> > 
> 
> Ben, what's your tack on this?

I'm perfectly happy to wait for the next merge window.. or even delay it
a bit til we can make sure ARM stuff is in, then memblock is updated to
also update ARM.

The latest failure is a bit of a concern... it shows that sh and
microblaze have not tested the series when I asked them to a while back
then, but then, I suppose everybody is short on time.

In any case, I'll fixup those glitches in my memblock branch, and we can
look at the ARM situation then and decide what to do.

Cheers,
Ben.
 

