Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757879Ab1GKPNv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jul 2011 11:13:51 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:41561 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757800Ab1GKPNu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jul 2011 11:13:50 -0400
MIME-Version: 1.0
In-Reply-To: <20110711140303.GA32532@atrey.karlin.mff.cuni.cz>
References: <20110711134150.GA15506@localhost.ucw.cz> <CALT56yM+fNs_2QorWK0=gr2um1H3vDX+HXPCi9bmKDdOdSvptA@mail.gmail.com>
 <20110711140303.GA32532@atrey.karlin.mff.cuni.cz>
From: Eric Miao <eric.y.miao@gmail.com>
Date: Mon, 11 Jul 2011 23:13:30 +0800
Message-ID: <CAMPhdO-UjxqyL47VsihX-fBD9VtAKkQqEQGj2u1YG0c90EHfqA@mail.gmail.com>
Subject: Re: zaurus patches -- arm/pxa -- is Eric alive
To: Cyril Hrubis <metan@ucw.cz>
Cc: Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>,
        Pavel Machek <pavel@ucw.cz>, rpurdie@rpsys.net, lenz@cs.wisc.edu,
        kernel list <linux-kernel@vger.kernel.org>, arminlitzel@web.de,
        thommycheck@gmail.com,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        omegamoon@gmail.com, utx@penguin.cz, zaurus-devel@www.linuxtogo.org,
        Marek Vasut <marek.vasut@gmail.com>,
        Russell King <rmk@arm.linux.org.uk>,
        Linus Torvalds <torvalds@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 11, 2011 at 10:03 PM, Cyril Hrubis <metan@ucw.cz> wrote:
> Hi!
>> > There are some rather critical patches for zaurus C-3000 (spitz)
>> > available... with no response. What is going on?
>>
>> Eric seems alive. At least he've sent pull requests few days ago.
>> Maybe you can point to those patches, that you mention as critical?
>
> Perhaps the most critical one is:
>
> [PATCH] MAX1111: Fix race condition causing NULL pointer exception
>
> http://ns1.yosemitephotos.net/lists/arm-kernel/msg125356.html
>
> Which fixes memory corruption that caused random oops.
>
> And then there is a bunch of fixes for charging and power management from
> Pavel Machek:

Guys, I'm still alive, at least still breathing. Just too many mails
and I was lost.

>
> Disable CF during suspend
>
> https://lkml.org/lkml/2011/5/21/46

The fix is trivial, think I can take it. A better approach will be to have a
generic CF power control function and invoke it in pcmcia driver when
suspending.

>
> and spitz pm
>
> https://lkml.org/lkml/2011/5/21/72
> https://lkml.org/lkml/2011/5/21/73
> https://lkml.org/lkml/2011/5/21/76

Looks good to me, yet I need the last one Acked by power supply people.

>
> --
> metan
>
