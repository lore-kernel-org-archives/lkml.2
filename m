Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757625Ab0JRSVI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Oct 2010 14:21:08 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:36439 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752191Ab0JRSVG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Oct 2010 14:21:06 -0400
Date: Mon, 18 Oct 2010 19:20:44 +0100
From: Russell King <rmk@arm.linux.org.uk>
To: Daniel Walker <dwalker@fifo99.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, Jeremy Kerr <jeremy.kerr@canonical.com>,
        Jeff Ohlstein <johlstei@codeaurora.org>
Subject: Re: linux-next: manual merge of the msm tree with the arm tree
Message-ID: <20101018182044.GA558@flint.arm.linux.org.uk>
References: <20101018103540.7bd9c535.sfr@canb.auug.org.au> <20101018110207.131b56ee.sfr@canb.auug.org.au> <20101018081520.GA10551@flint.arm.linux.org.uk> <1287422792.4105.14.camel@c-dwalke-linux.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1287422792.4105.14.camel@c-dwalke-linux.qualcomm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 18, 2010 at 10:26:32AM -0700, Daniel Walker wrote:
> On Mon, 2010-10-18 at 09:15 +0100, Russell King wrote:
> > On Mon, Oct 18, 2010 at 11:02:07AM +1100, Stephen Rothwell wrote:
> > > [ Just cc'ing Russell, sorry about that]
> > > 
> > > On Mon, 18 Oct 2010 10:35:40 +1100 Stephen Rothwell <sfr@canb.auug.org.au> wrote:
> > > >
> > > > Hi Daniel,
> > > > 
> > > > Today's linux-next merge of the msm tree got a conflict in
> > > > arch/arm/mach-msm/include/mach/debug-macro.S between commit
> > > > 08a610d9ef5394525b0328da0162d7b58c982cc4 ("arm: return both physical and
> > > > virtual addresses from addruart") from the arm tree and commit
> > > > 46fe5f29e3062f681cc3cf07a604d82396faea89 ("msm: allow uart to be
> > > > conditionally disabled") from the msm tree.
> > > > 
> > > > Just context changes.  I fixed it up (see below) and can carry the fix as
> > > > necessary.
> > 
> > Thanks, but I don't think there's much which can be done about these.
> > Changes such as 08a610d affect all ARM sub-architectures, and as they're
> > spread across multiple git trees...
> > 
> > I think there's going to be some problems during this forthcoming merge
> > window.
> 
> Would be nice to get CC'd ...
> 
> Ideally this patch should have been broken up and sent individually to
> each maintainer .. Then I could manage this within my own tree..

Err no.  It is one complete change which can't be broken up sensibly.
Breaking it up will mean either you lose functionality or you break
your build.

-- 
Russell King
 Linux kernel    2.6 ARM Linux   - http://www.arm.linux.org.uk/
 maintainer of:
