Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755929Ab0JKRko (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Oct 2010 13:40:44 -0400
Received: from kroah.org ([198.145.64.141]:52348 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755659Ab0JKRj4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Oct 2010 13:39:56 -0400
Date: Mon, 11 Oct 2010 10:31:41 -0700
From: Greg KH <greg@kroah.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Dave Airlie <airlied@gmail.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>
Subject: Re: stable cc's in linux -next was Re: [BUG] x86: bootmem broken
	on SGI UV
Message-ID: <20101011173141.GB7116@kroah.com>
References: <AANLkTinyA=bSeSe7eavUb7fuSgM8m=QQFGqCrNtCGqKa@mail.gmail.com> <AANLkTikCHzaovYy+g8GBE7zwBOa-=pXk=WwQ_5ts1u5m@mail.gmail.com> <20101009235141.GB15564@kroah.com> <AANLkTikBGsO9wy3z-z6_pTKq0vrYme0fEhE8KcXj_Si3@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTikBGsO9wy3z-z6_pTKq0vrYme0fEhE8KcXj_Si3@mail.gmail.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 11, 2010 at 10:18:34AM -0700, Linus Torvalds wrote:
> And I suspect that from a social standpoint, if we delay the stable
> queue auto-patch-sending, it will just lead to people trying to bypass
> that delay by sending things directly to stable rather than depending
> on the "stable@kernel.org" tag on the commit itself. Or if the delay
> is implemented on the stable email address itself, then people would
> try to just send it directly to you instead.

I agree, that would just get messier.

> It doesn't help that the number of patches in a stable release is much
> bigger than at least I personally envisioned. Yes, many of them are
> things like adding device ID's etc, but I do suspect that it just then
> makes it much harder to try to delay things by a week or something.
> Plus some problems probably wouldn't even be noticed in a week in the
> development kernel, and they'd _still_ be found only once it hits
> stable just because lots of people will obviously never test the
> development kernel.

The "largeness" of recent stable kernel releases (i.e. for the past
year) seem more to be a factor of the subsystem maintainers finally
realizing that they should be sending their bugfixes to me (thanks a
large part to Andrew's constant badgering about this), combined with the
distros sending me their bugfixes that they have found that are already
included upstream.

> So I have no solution to it. I just don't think stable has been quite
> as stable as people would wish for.

It hasn't?  I haven't heard people saying anything about this before, in
fact, people seem to get upset at me when I reject the stuff they are
sending me for inclusion which don't meet the stable criteria.

Not that I'm trying to say, "it could be worse", just that, "what could
be done better?"

thanks,

greg k-h
