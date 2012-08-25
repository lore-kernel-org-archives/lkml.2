Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758827Ab2HYAvJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Aug 2012 20:51:09 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:47292 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752591Ab2HYAvH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Aug 2012 20:51:07 -0400
Message-ID: <50382175.1020305@gmail.com>
Date: Sat, 25 Aug 2012 10:51:01 +1000
From: Cruz Julian Bishop <cruzjbishop@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120714 Thunderbird/14.0
MIME-Version: 1.0
To: wbrana <wbrana@gmail.com>
CC: Martin Nybo Andersen <tweek@tweek.dk>,
        Chris Friesen <chris.friesen@genband.com>,
        Bernd Petrovitsch <bernd@petrovitsch.priv.at>,
        Ondrej Zary <linux@rainbow-software.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: Drop support for x86-32
References: <CAJ7jCmmbiR7Kzwtc4x++Z+onvSMN5ZyVrORiux6TuZ6=gCBH9Q@mail.gmail.com> <201208241814.16862.tweek@tweek.dk> <5037AAB0.6040102@genband.com> <201208241854.45656.tweek@tweek.dk> <CAJ7jCmkiPrr3-pf2yspNiHHzhZBCsuWZaTRCjmi_wSdBGhB6Fg@mail.gmail.com>
In-Reply-To: <CAJ7jCmkiPrr3-pf2yspNiHHzhZBCsuWZaTRCjmi_wSdBGhB6Fg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 25/08/12 03:05, wbrana wrote:
> On 8/24/12, Martin Nybo Andersen <tweek@tweek.dk> wrote:
>> What I'd hate even more is rendering my old working hardware useless by
>> removing x86-32 support from the kernel. To reason the removal by saying
>> "Microsoft plans to do it" just makes me go bonkers...
> Your old hardware will work fine with long term kernel.
People won't want to be forced to stick with an old version of the
kernel which,
as you said, will not have any backported features.

People deserve the choice to use whatever they have, however they want.
That's the way it works. The was it has been, currently is, and always
will be.

...Unless someone at Microsoft* holds Linus hostage** in order to take over
Linux kernel development. Not that it's likely to ever happen


*Not being a troll or hurling personal insults at Microsoft - It's just
that they
currently have the majority share on the desktop (and made the original
announcement for W9)

**If this ever happens, even if it's by a terrorist group and not a company,
please don't sue me for conspiracy to kidnapping. It was just an example :)

>
>> These legacy apps will most likely be compiled for x86-32 and not x32 (an
>> argument for not removing x86-32 support on a running x86-64 kernel).
> Which legacy apps do you mean?
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

