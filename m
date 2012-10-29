Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758324Ab2J2J5s (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2012 05:57:48 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:33002 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758148Ab2J2J5p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2012 05:57:45 -0400
Date: Mon, 29 Oct 2012 09:55:38 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Krzysztof Halasa <khc@pm.waw.pl>
Cc: Arnd Bergmann <arnd@arndb.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-arm-kernel@lists.infradead.org,
        lkml <linux-kernel@vger.kernel.org>, arm@kernel.org
Subject: Re: [PULL REQ] IXP4xx changes for Linux 3.7
Message-ID: <20121029095538.GE21164@n2100.arm.linux.org.uk>
References: <m3bog6m5iz.fsf@intrepid.localdomain> <201210142002.55841.arnd@arndb.de> <m3a9vkahci.fsf@intrepid.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <m3a9vkahci.fsf@intrepid.localdomain>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 18, 2012 at 12:01:17AM +0200, Krzysztof Halasa wrote:
> Hi,
> 
> Arnd Bergmann <arnd@arndb.de> writes:
> > Also, never rebase your tree immediately before sending a pull
> > request.
> 
> I did not, of course. My mail stated:
> "Build-tested for now. This is based on your current tree tip because it
> depends on commits following 3.6 release."

You're lucky that you didn't get flamed by Linus himself for that, as
others _have_ been in the past.

> Normally I wouldn't rebase, but had to (as you well knew) - because you
> commited a conflicting patch to this very IXP4xx arch. Using your logic,
> you were supposed to get an Ack from me (or from Imre) for this patch.

If you had *bothered* asking the arm-soc people to pull your tree
_instead_ of Linus, then that problem becomes the arm-soc's problem, not
yours.  That  means _you_ end up with _less_ work to do.  Yet, instead
of seeing that benefit, whenever you've been asked to send your tree via
arm-soc, you throw your toys out of your pram and basically refuse.

So, you're making *more* work for yourself by not participating in
arm-soc (as I've explained to you before.)

The _ONLY_ thing you have to do is send your pull request to the arm-soc
people instead of Linus before the merge window opens.  You don't need to
rebase your stuff on a different tree, you can still use Linus' tree as
a basis.

You have offered no technical reason why you can't participate in arm-soc
which has stood up to screutiny.

The only reasons you've offered seem to be:

1. it'll be more work (untrue)
2. you look after platforms which aren't in mainline and you're not submitting
   to mainline.

Both of these a total nonsense arguments when it comes to the _route_ that
your patches make their way into mainline.  They have absolutely no bearing
on the path your changes take AT ALL.

> Don't get me wrong. If I had time for this it could be different.
> Unfortunately IXP4xx is a legacy arch, and for me it's simply a hobby at
> this point. Given the raised barriers to participate, probably aimed at
> paid maintainers, I have to quit doing this.

As you're being difficult and not willing to co-operate, and for whatever
reason building this issue into a mountain, this unfortunately sounds to
me like a good thing.  Hopefully, a more co-operative maintainer will step
up in your place who can see the benefits.
