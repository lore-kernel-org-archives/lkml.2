Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753481Ab1I0VYM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Sep 2011 17:24:12 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:47163 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752051Ab1I0VYK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Sep 2011 17:24:10 -0400
Date: Tue, 27 Sep 2011 22:23:43 +0100
From: Russell King <rmk@arm.linux.org.uk>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Catalin Marinas <catalin.marinas@arm.com>,
        Jon Medhurst <tixy@yxit.co.uk>
Subject: Re: linux-next: manual merge of the arm-soc tree with the arm tree
Message-ID: <20110927212342.GC7737@flint.arm.linux.org.uk>
References: <20110927112524.fd0b8f1fe69bc63855ead2d7@canb.auug.org.au> <20110927072517.GB11359@flint.arm.linux.org.uk> <201109271724.46371.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201109271724.46371.arnd@arndb.de>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 27, 2011 at 05:24:46PM +0200, Arnd Bergmann wrote:
> Do you generally send one pull request for each branch you have
> in the for-next branch, or do you send a single request for something
> that roughly resembles the for-next branch at the time of the merge
> window?

It depends how much is queued and how I feel towards the stuff which
is queued.  I've tended to send initially a big pull request of 'ARM
updates' which contains mostly everything, though I've also sent
pull requests for individual topic branches when it makes more sense.

At the moment, the diffstat summary says:

 423 files changed, 3054 insertions(+), 2855 deletions(-)

but there's quite a spread outside arch/arm this time around due to
the GPIO stuff I'm carrying (mostly the change of mach/gpio.h to
asm/gpio.h).

So, at least the GPIO stuff will be a completely separate pull request
from the rest of the ARM stuff.  The 'amba' (primecell) changes will
probably also be a separate pull request because it touches stuff
outside of the arch/arm sub-tree (even though its ARM related.)

What I term 'devel-stable' (iow, stuff I've pulled in from other people
and a few bits of my own stuff which others are using) won't be split
up (that'd negate the point of devel-stable being... stable as it'd
mean there's commits in there which can't be relied upon.)

That leaves 'the rest' which I'll make a decision nearer the time,
along with deciding whether devel-stable ends up being part of
'the rest' or not.

What I will try to do is get the bulk of it in fairly early in the
merge cycle as normal.

-- 
Russell King
 Linux kernel    2.6 ARM Linux   - http://www.arm.linux.org.uk/
 maintainer of:
