Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752300Ab1BBUBQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Feb 2011 15:01:16 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:47746 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752014Ab1BBUBP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Feb 2011 15:01:15 -0500
Date: Wed, 2 Feb 2011 20:00:31 +0000
From: Russell King <rmk@arm.linux.org.uk>
To: Greg KH <greg@kroah.com>
Cc: David Brown <davidb@codeaurora.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Stepan Moskovchenko <stepanm@codeaurora.org>
Subject: Re: linux-next: manual merge of the msm tree with the arm tree
Message-ID: <20110202200030.GA26104@flint.arm.linux.org.uk>
References: <20110131131401.5d6c7646.sfr@canb.auug.org.au> <8ya4o8m70jp.fsf@huya.qualcomm.com> <20110202194359.GC27065@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110202194359.GC27065@kroah.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 02, 2011 at 11:43:59AM -0800, Greg KH wrote:
> On Wed, Feb 02, 2011 at 10:29:14AM -0800, David Brown wrote:
> > On Sun, Jan 30 2011, Stephen Rothwell wrote:
> > 
> > > Hi David,
> > >
> > > Today's linux-next merge of the msm tree got conflicts in
> > > arch/arm/mach-msm/board-msm7x27.c, arch/arm/mach-msm/board-msm7x30.c,
> > > arch/arm/mach-msm/board-qsd8x50.c and arch/arm/mach-msm/board-sapphire.c
> > > between commit eda53d6d032effb653410b79e1b49e652a881744 ("ARM: P2V: avoid
> > > initializers and assembly using PHYS_OFFSET") from the arm tree and
> > > commit 07a3cc4814f790354d4c7be2c9dc6143a714a07a ("msm: Clean up useless
> > > ifdefs") from the msm tree.
> > >
> > > I fixed it up (see below) and can carry the fix as necessary.
> > 
> > What is the best way to resolve this?  I can't really merge against
> > Russell's tree, since he may need to rebase his tree before the merge
> > window?
> 
> Public trees should never be rebased, so that shouldn't happen.

No.  I refuse to operate in a rigid environment.

My tree is made available on the basis that the 'devel' branch is
constantly remerged (sometimes many times a day) from the individual
topic branches; 'devel' is a convenient branch for sfr to pull into
linux-next, and for others to see what's in the tree.

I am not permitted by people in the community to keep my development
work unpublished.

All the requirements from various different people are incompatible,
so I've chosen a way which satisfies the majority on the ARM community,
which is the community my tree serves.  It does not serve mainline
community interests.

So I do not operate a "commit the patch and its fixed" policy except
for branches which people need to be fixed; they need to discuss their
requirements with me to achieve that.

-- 
Russell King
 Linux kernel    2.6 ARM Linux   - http://www.arm.linux.org.uk/
 maintainer of:
