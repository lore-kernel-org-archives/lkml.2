Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752123Ab2LCTpM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Dec 2012 14:45:12 -0500
Received: from mail-wg0-f46.google.com ([74.125.82.46]:42161 "EHLO
	mail-wg0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751383Ab2LCTpL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Dec 2012 14:45:11 -0500
MIME-Version: 1.0
In-Reply-To: <20121203193310.GA32762@rhlx01.hs-esslingen.de>
References: <CA+55aFyetqyMa2BQu7kE=cqFdAysUh9gV=O5as5Chgg1EMCW7g@mail.gmail.com>
 <20121203193310.GA32762@rhlx01.hs-esslingen.de>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Mon, 3 Dec 2012 11:39:07 -0800
X-Google-Sender-Auth: RFzasz5EtGf9z54gnz8fluspjQs
Message-ID: <CA+55aFygWCxz=Mmogp8FoSr51rNct6ANw0Kw3y=u4Pu2iDK48Q@mail.gmail.com>
Subject: Re: [YASB] Re: Linux 3.7-rc7
To: Andreas Mohr <andi@lisas.de>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 3, 2012 at 11:33 AM, Andreas Mohr <andi@lisas.de> wrote:
> Hello,
>
> JFYI: Yet Another Suspend Breakage, it seems (hopefully someone
> can contribute to and further nail down this issue).
>
>
> Working:
> vmlinuz-3.7.0-rc5-00068-gc5e35d6 (HEAD possibly unknown?)
>
> Failing:
> vmlinuz-3.7.0-rc7-00179-g2db18aa (HEAD 3c46f3d6406b1d0c53575774b2d1fd013cd7f76f)
>
>
> Athlon XP 32bit VIA 8K5A2+.
>
>
> Florian Fainelli (1):
>       x86/ce4100: Fix pm_poweroff
>
> sounds like it *might* happen to be a candidate (I could try to add a
> revert on top, of certain likely candidates).

That can only matter if you select support for CONFIG_X86_INTEL_CE
("CE4100 TV platform") which you should never do unless you actually
compile for that platform.

So it's something else (or you have an insane config file). Bisection
would be wonderful.

                Linus
