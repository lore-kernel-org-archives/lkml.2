Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754360Ab1G0PIH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jul 2011 11:08:07 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:59166 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750861Ab1G0PID (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jul 2011 11:08:03 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [GIT PULL] arm-soc new features (part 2/2) for 3.1
Date: Wed, 27 Jul 2011 17:07:53 +0200
User-Agent: KMail/1.12.2 (Linux/2.6.37; KDE/4.3.2; x86_64; ; )
Cc: Thomas Gleixner <tglx@linutronix.de>,
        Nicolas Pitre <nicolas.pitre@linaro.org>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Russell King <rmk@arm.linux.org.uk>
References: <3057645.NjCAYUXHGt@wuerfel> <5039974.y3GReu3Vjy@wuerfel> <CA+55aFygBzynb_4kZQEHQAU0Np0H9UCBFoW1hoRJ571QCMo42Q@mail.gmail.com>
In-Reply-To: <CA+55aFygBzynb_4kZQEHQAU0Np0H9UCBFoW1hoRJ571QCMo42Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201107271707.54059.arnd@arndb.de>
X-Provags-ID: V02:K0:boj8lr6BqIBSmhuPeLzMDgUc9bM0CCK2YoF+dySBKUM
 5dytyQwBb/KQjqxbUxJWU+Gr0DSTJOjETBa1JOhjypzjoMGC7L
 DZWIjzqpo6VqsMCMhqlaWXQ1odpBMZ6c4mx6jKGgTOL+4m5S7p
 1Zy4A8VlMDLwfNcMabrABcl/npw2uFiuGrgXdiiTgNN7UJwA/V
 wJYobhyjTyHleokg6cXog==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 27 July 2011, Linus Torvalds wrote:
> I compared the end result with yours, and we did some things a bit
> differently, but on the whole it looks pretty identical. We have a
> different resolution for "exynos4_cpu_suspend()", but afaik mine is
> better (it looks like from a type standpoint it should return int, but
> due to the panic it doesn't matter). And we did those
> OMAP4430_DLL_OVERRIDE_SHIFT/MASK defines in a different order. I have
> some other changes in my tree (Andrew's patch-set for asm/atomic.h
> etc), so that makes for other differences in arch/arm, but it looks
> like it's ok.
> 
> But you should double-check. I didn't compile-test any of it, I don't
> do the cross-compile thing, and maybe I missed something.

Looks all good as far as I can tell. Your exynos4_cpu_suspend is
better than the solution I had in next and everything else
is equivalent.

I'm still in the process of fixing randconfig builds that have never
been working for most arm platforms, so I can do a better job
at automatically doing build tests myself. My guess is that there
will be several build regressions due to stuff coming in but that
they are not the result of mismerges.

	Arnd
