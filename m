Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752975Ab1G0AwG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jul 2011 20:52:06 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47198 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751549Ab1G0AwD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jul 2011 20:52:03 -0400
MIME-Version: 1.0
In-Reply-To: <5039974.y3GReu3Vjy@wuerfel>
References: <3057645.NjCAYUXHGt@wuerfel> <5818290.TCY0zMWmbr@wuerfel>
 <1698068.Mn9Tmtfmzl@wuerfel> <5039974.y3GReu3Vjy@wuerfel>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Tue, 26 Jul 2011 17:51:16 -0700
Message-ID: <CA+55aFygBzynb_4kZQEHQAU0Np0H9UCBFoW1hoRJ571QCMo42Q@mail.gmail.com>
Subject: Re: [GIT PULL] arm-soc new features (part 2/2) for 3.1
To: Arnd Bergmann <arnd@arndb.de>
Cc: Thomas Gleixner <tglx@linutronix.de>,
        Nicolas Pitre <nicolas.pitre@linaro.org>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Russell King <rmk@arm.linux.org.uk>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 26, 2011 at 4:36 PM, Arnd Bergmann <arnd@arndb.de> wrote:
>
> This is the final branch I have for now, although I hope to get one more
> for actual device tree conversions for a lot of drivers.

Ok, everything merged.

I compared the end result with yours, and we did some things a bit
differently, but on the whole it looks pretty identical. We have a
different resolution for "exynos4_cpu_suspend()", but afaik mine is
better (it looks like from a type standpoint it should return int, but
due to the panic it doesn't matter). And we did those
OMAP4430_DLL_OVERRIDE_SHIFT/MASK defines in a different order. I have
some other changes in my tree (Andrew's patch-set for asm/atomic.h
etc), so that makes for other differences in arch/arm, but it looks
like it's ok.

But you should double-check. I didn't compile-test any of it, I don't
do the cross-compile thing, and maybe I missed something.

                       Linus
