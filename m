Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752487Ab1EACxJ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Apr 2011 22:53:09 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57874 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750941Ab1EACxF convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Apr 2011 22:53:05 -0400
MIME-Version: 1.0
In-Reply-To: <web-516106572@zbackend1.aha.ru>
References: <web-516106572@zbackend1.aha.ru>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Sat, 30 Apr 2011 19:52:11 -0700
Message-ID: <BANLkTi=_oTLVZUOGXGU_WekyNmO+ArRgCw@mail.gmail.com>
Subject: Re: 2.6.39-rc5-git2 boot crashs
To: werner <w.landgraf@ru.ru>
Cc: linux-kernel@vger.kernel.org, jaxboe@fusionio.com, tj@kernel.org
Content-Type: text/plain; charset=KOI8-R
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Apr 30, 2011 at 6:52 PM, werner <w.landgraf@ru.ru> wrote:
>
> Enclosed is still the /var/log/debug file.

Can you please just do what I asked to, namely do the minimal config.

That will also make it _much_ faster for you to compile the kernel
(you can probably do it in 10 minutes or less if you just get a really
nice config that only has the stuff you actually require - on my
machine I compile my kernel in about 3 minutes from scratch).

And not only would it tell us something (namely whether the problem
persists or not), but if it _does_ persist even with a minimal kernel
that only has the drivers you need, it would make it much more
feasible to do a bisect because now the compile/test cycle would be
much shorter.

So please, just do it.  Because quite frankly, by now you're mainly
just wasting everybody's time.

> šUNFORTUNATELY, IT DONT SHOWS THE
> KERNEL VERSION (THIS IS SOMETHING WHAT YOU COULD CORRECT !!!)

The kernel version shows up in dmesg as the very first thing. Something like

[    0.000000] Linux version 2.6.39-rc5-00127-g1be6a1f89f13
(torvalds@i5.linux-foundation.org) (gcc version 4.5.1 20100924 (Red
Hat 4.5.1-4) (GCC) ) #9 SMP PREEMPT Fri Apr 29 16:28:05 PDT 2011

You've just lost it, possibly because your dmesg file ended up growing
too large, or possibly because some tool just didn't bother to save
it.

                        Linus
