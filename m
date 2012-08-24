Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758930Ab2HXR2r (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Aug 2012 13:28:47 -0400
Received: from mail-wi0-f172.google.com ([209.85.212.172]:63098 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754155Ab2HXR2n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Aug 2012 13:28:43 -0400
MIME-Version: 1.0
In-Reply-To: <CAJ7jCmkiPrr3-pf2yspNiHHzhZBCsuWZaTRCjmi_wSdBGhB6Fg@mail.gmail.com>
References: <CAJ7jCmmbiR7Kzwtc4x++Z+onvSMN5ZyVrORiux6TuZ6=gCBH9Q@mail.gmail.com>
	<201208241814.16862.tweek@tweek.dk>
	<5037AAB0.6040102@genband.com>
	<201208241854.45656.tweek@tweek.dk>
	<CAJ7jCmkiPrr3-pf2yspNiHHzhZBCsuWZaTRCjmi_wSdBGhB6Fg@mail.gmail.com>
Date: Fri, 24 Aug 2012 13:28:41 -0400
Message-ID: <CAMzpN2jZY8o4yngyYGp9wqdBmYsJ62YN9MrD3p_5FgZGYJshvg@mail.gmail.com>
Subject: Re: Drop support for x86-32
From: Brian Gerst <brgerst@gmail.com>
To: wbrana <wbrana@gmail.com>
Cc: Martin Nybo Andersen <tweek@tweek.dk>,
        Chris Friesen <chris.friesen@genband.com>,
        Bernd Petrovitsch <bernd@petrovitsch.priv.at>,
        Ondrej Zary <linux@rainbow-software.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 24, 2012 at 1:05 PM, wbrana <wbrana@gmail.com> wrote:
> On 8/24/12, Martin Nybo Andersen <tweek@tweek.dk> wrote:
>> What I'd hate even more is rendering my old working hardware useless by
>> removing x86-32 support from the kernel. To reason the removal by saying
>> "Microsoft plans to do it" just makes me go bonkers...
> Your old hardware will work fine with long term kernel.

You still don't get it.  Forget your "long term kernel" fantasy.  That
is not what they are intended for.  They are to provide a stable
kernel for the lifetime of a major (usually enterprise) distribution.
They provide security and bug fixes without the churn associated with
major releases.

There is absolutely no reason to remove support for hardware from
Linux unless nobody is willing to maintain it.  As I said before,
there is so much more in common between x86-32 and x86-64 than there
is different, that x86-32 specific maintenance is almost nil.  I
haven't seen any patches from you, so your opinions about the
maintenance burden don't carry much weight, versus those of people who
are contributors.

--
Brian Gerst
