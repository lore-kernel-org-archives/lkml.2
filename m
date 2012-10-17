Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751864Ab2JQWBV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Oct 2012 18:01:21 -0400
Received: from inx.pm.waw.pl ([195.116.170.130]:58818 "EHLO inx.pm.waw.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751747Ab2JQWBU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Oct 2012 18:01:20 -0400
From: Krzysztof Halasa <khc@pm.waw.pl>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        linux-arm-kernel@lists.infradead.org,
        lkml <linux-kernel@vger.kernel.org>, arm@kernel.org
Subject: Re: [PULL REQ] IXP4xx changes for Linux 3.7
References: <m3bog6m5iz.fsf@intrepid.localdomain>
	<201210142002.55841.arnd@arndb.de>
Date: Thu, 18 Oct 2012 00:01:17 +0200
In-Reply-To: <201210142002.55841.arnd@arndb.de> (Arnd Bergmann's message of
	"Sun, 14 Oct 2012 20:02:55 +0000")
Message-ID: <m3a9vkahci.fsf@intrepid.localdomain>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Arnd Bergmann <arnd@arndb.de> writes:

> as mentioned before, all arch/arm/mach-* patches should go through the
> arm-soc tree or get an Ack from the arm-soc maintainers. The same thing
> is true for the char-misc and the crypto trees.

You've seen the changes. They were trivial fixes, touched only
IXP4xx-related areas, there was nothing related to char or crypto
subsystems there, except file location (well, IXP4xx drivers have to be
located somewhere).

The patches have been posted to linux-arm-kernel and you knew about
them. That they were obviously correct and clean is probably not
that important.

Nobody bothered to comment the patches.

> Also, never rebase your tree immediately before sending a pull
> request.

I did not, of course. My mail stated:
"Build-tested for now. This is based on your current tree tip because it
depends on commits following 3.6 release."

Normally I wouldn't rebase, but had to (as you well knew) - because you
commited a conflicting patch to this very IXP4xx arch. Using your logic,
you were supposed to get an Ack from me (or from Imre) for this patch.

Actually it wasn't a problem for me, I simply had to rebase.

> Finally when sending bug fixes, please annotate any patches with
> 'Cc: stable@vger.kernel.org' if they address bugs that are already
> present in older kernels, so that the stable and longterm maintainers
> can easily backport the fixes.

I do that when I think it makes sense. In this case (two patches for
Goramo MultiLink platform) practically all such devices use kernels
prepared by me, and I think Greg (and others) have more efficient ways
to spend their time than handling almost unused patches. Also, I have
much more efficient ways to spend time. Anyway, if I can't have my
patches upstream, why should they end up in stable?

> Almost all of the platform patches in your tree seem to be bug fixes,
> so they are still good for inclusion in v3.7 if you submit them to
> arm-soc soon, but please make sure you separate bug fixes from other
> changes so we can group them appropriately when forwarding them to
> Linus.

Unfortunately, as I already explained to you in
https://lkml.org/lkml/2012/9/29/37, my resources for IXP4xx are very
limited (and this isn't a paid job) and I'm in no way able to do what
you require. This, coupled with my inability to make the patches end up
upstream any other way, will make me post relevant MAINTAINERS changes
shortly.

Don't get me wrong. If I had time for this it could be different.
Unfortunately IXP4xx is a legacy arch, and for me it's simply a hobby at
this point. Given the raised barriers to participate, probably aimed at
paid maintainers, I have to quit doing this.

BTW since Imre has probably even much less time, it would be a good time
to find someone to maintain IXP4xx code. I will be publishing (from time
to time) my tree (I'm using the hw myself), so even simple
cherry-picking would probably make some sense.
-- 
Krzysztof Halasa
