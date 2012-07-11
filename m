Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758040Ab2GKTBy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2012 15:01:54 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:63815 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756586Ab2GKTBx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2012 15:01:53 -0400
MIME-Version: 1.0
Reply-To: sedat.dilek@gmail.com
In-Reply-To: <CACRpkdbazoCztqbT00_oBsRyee=VBDH+NiGEpzNk8uV7mvsNwQ@mail.gmail.com>
References: <CA+icZUX565WsuJNHKsohXi=vp34Acn+2D-nj8mQQtCfi=Pw_Nw@mail.gmail.com>
	<CACRpkdbazoCztqbT00_oBsRyee=VBDH+NiGEpzNk8uV7mvsNwQ@mail.gmail.com>
Date: Wed, 11 Jul 2012 21:01:51 +0200
Message-ID: <CA+icZUUDt6uAHKf=B3Lfh6FxNaCPsjZS2xY7_DoG312aV0MJhA@mail.gmail.com>
Subject: Re: linux-next: Tree for July 10 (gpio/gpio-tps65910.c)
From: Sedat Dilek <sedat.dilek@gmail.com>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        linux-next <linux-next@vger.kernel.org>,
        Randy Dunlap <rdunlap@xenotime.net>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 11, 2012 at 6:39 PM, Linus Walleij <linus.walleij@linaro.org> wrote:
> On Wed, Jul 11, 2012 at 2:29 PM, Sedat Dilek <sedat.dilek@gmail.com> wrote:
>
>> I see the same build-error as Randy in latest linux.git
>> (055c9fa8874fa7261eec7a268366565db84af474).
>
> Yes, it is there.
>
>> Where is this patch queued up (see original posting)?
>
> Here:
> http://git.kernel.org/?p=linux/kernel/git/linusw/linux-gpio.git;a=shortlog;h=refs/heads/fixes
>
>> I do not see any patch in [2].
>
> Grant asked me to take over for a while, 10 days ago.
>
>> I also do not see any patch sent to LKML.
>
> But there was such a patch:
> http://lkml.org/lkml/2012/7/10/16
>
> And it's queued in my tree and on the for-next branch.
>

If you are talking of "queued patches" so please give a pointer to the
patch next time - saves my and others time.

BTW, didn't see your tree in linux-next [1].

In the mean time I have built with CONFIG_*_TPS65910=n successfully.

- Sedat -

[1] http://git.kernel.org/?p=linux/kernel/git/next/linux-next.git;a=blob;f=Next/Trees#l184

> And as noted, I also tried to send it to Linus (Torvalds)
> as an update to my last pull request. I guess I'll just have
> to send another request.
>
> Yours,
> Linus Walleij
