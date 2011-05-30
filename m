Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754994Ab1E3UkI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 May 2011 16:40:08 -0400
Received: from lo.gmane.org ([80.91.229.12]:58877 "EHLO lo.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753148Ab1E3UkG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 May 2011 16:40:06 -0400
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Mustapha Rabiu <muztapha@gmail.com>
Subject: Re: Linux 3.0-rc1
Date: Mon, 30 May 2011 20:33:29 +0000 (UTC)
Message-ID: <loom.20110530T221016-75@post.gmane.org>
References: <BANLkTinE8eSSovGx6CPPkTeCpqv8AsS2nw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Complaints-To: usenet@dough.gmane.org
X-Gmane-NNTP-Posting-Host: sea.gmane.org
User-Agent: Loom/3.14 (http://gmane.org/)
X-Loom-IP: 41.220.69.17 (Mozilla/5.0 (Macintosh; U; Intel Mac OS X 10_6_7; en-us) AppleWebKit/533.21.1 (KHTML, like Gecko) Version/5.0.5 Safari/533.21.1)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds <torvalds <at> linux-foundation.org> writes:

> 
> Yay! Let the bikeshed painting discussions about version numbering
> begin (or at least re-start).
> 
> I decided to just bite the bullet, and call the next version 3.0. It
> will get released close enough to the 20-year mark, which is excuse
> enough for me, although honestly, the real reason is just that I can
> no longe rcomfortably count as high as 40.
> 

Unsurprising, however, congratulations on yet another major release! 
We applaud the fact that it'll be just as hideous as 2.6.x, without any 
new or modified features. Might you explain why you didn't just 
use 2.8.x ?

Also, given that multiple people have asked for a handful of things
to be merged into the kernel, re: security, I'm puzzled about how 
you managed to develop this self-styled 'alpha-male' based versioning 
scheme without addressing unsettling discrepancies such 
as /proc/pid/auxv, /proc/pid/stack and /proc/pid/syscall based 
info-leaks or slub cache merging, etc, all of which have been publicly 
discussed over varying periods of time, (circa ~2008)

> The whole renumbering was discussed at last years Kernel Summit, and
> there was a plan to take it up this year too. But let's face it -
> what's the point of being in charge if you can't pick the bike shed
> color without holding a referendum on it? So I'm just going all
> alpha-male, and just renumbering it. You'll like it.
> 

Again, without catering for pre-existing issues.

> Now, my alpha-maleness sadly does not actually extend to all the
> scripts and Makefile rules, so the kernel is fighting back, and is
> calling itself 3.0.0-rc1. We'll have the usual 6-7 weeks to wrestle it
> into submission, and get scripts etc cleaned up, and the final release
> should be just "3.0". The -stable team can use the third number for
> their versioning.
> 
> So what are the big changes?
> 
> NOTHING. Absolutely nothing. 

Relatively disturbing. Again, why not use 2.8.x ?

> Sure, we have the usual two thirds driver
> changes, and a lot of random fixes, but the point is that 3.0 is
> *just* about renumbering, we are very much *not* doing a KDE-4 or a
> Gnome-3 here. No breakage, no special scary new features, nothing at
> all like that. 

And none of the aforementioned issues.

> We've been doing time-based releases for many years
> now, this is in no way about features. If you want an excuse for the
> renumbering, you really should look at the time-based one ("20 years")
> instead.
> 
> So no ABI changes, no API changes, no magical new features - just
> steady plodding progress. In addition to the driver changes (and the
> bulk really is driver updates), we've had some nice VFS cleanups,
> various VM fixes, some nice initial ARM consolidation (yay!) and in
> general this is supposed to be a fairly normal release cycle. The
> merge window was a few days shorter than usual, but if that ends up
> meaning a smaller release and a nice stable 3.0 release, that is all
> good. There's absolutely no reason to aim for the traditional ".0"
> problems that so many projects have.
> 
> In fact, I think that in addition to the shorter merge window, I'm
> also considering make this one of my "Linus is being a difficult
> ^&^hole" releases, where I really want to be pretty strict about what
> I pull during the stabilization window. 

Well, being an asshole is relatively different. This is a case of being stupid.

> Part of that is that I'm going to be traveling next week with a slow 
> atom laptop, so you had better convince me I *really* want to 
> pull from you, because that thing really is not the most impressive 
> piece of hardware ever built. It does the "git" workflow quite well, 
> but let's just say that compiling the kernel is not quite the user 
> experience I've gotten used to.
>
> So be nice to me, and send me only really important fixes. And let's
> make sure we really make the next release not just an all new shiny
> number, but a good kernel too.

Being as most of the issues mentioned above have been prodded by several 
people over the scope of over five years, to multiple maintainers, including
yourself, I'm not sure you'd pay any attention to amendments until some sort
of en-masse all-out holocaust arrives.

> 
> Ok?
> 
> Go forth and test,
> Linus
> 

Yours, sincerely

Mustapha Rabiu.


