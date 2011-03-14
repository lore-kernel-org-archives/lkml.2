Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754600Ab1CNLwx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Mar 2011 07:52:53 -0400
Received: from mail-qw0-f46.google.com ([209.85.216.46]:60157 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754213Ab1CNLww convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Mar 2011 07:52:52 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=mime-version:reply-to:in-reply-to:references:date:message-id
         :subject:from:to:cc:content-type:content-transfer-encoding;
        b=FGGxjqAcRe3/leGC6Spr2DOzDOPszirTVPa67+VdG/K5bAafzkzC2lQXqCvWaqJ0tB
         lUYtLBBoPKyaToy2ZVQxDekZEkfD4nD+VSGOouGRsoYHi6vnmEL2+ZX2LpjrLffK1ZhH
         LDUL/Dx7gTgdIOZqYXHaZLpA/TO5JTkJmdwtE=
MIME-Version: 1.0
Reply-To: sedat.dilek@gmail.com
In-Reply-To: <AANLkTikUKE4xzf-NJtK3vMCQmNEYiAXZzi2vMZs9Zy4W@mail.gmail.com>
References: <AANLkTinDTyupNgZR-0izCWrpwOnE1wEcubn+M3o=Mgy2@mail.gmail.com>
	<4D7E095802000078000363D5@vpn.id2.novell.com>
	<AANLkTikUKE4xzf-NJtK3vMCQmNEYiAXZzi2vMZs9Zy4W@mail.gmail.com>
Date: Mon, 14 Mar 2011 12:52:51 +0100
Message-ID: <AANLkTimmi7A6cXo8BCHWtBDmauZD4_-dNjThpn1J9DkW@mail.gmail.com>
Subject: Re: PATCH: Add --size-check=[error|warning]
From: Sedat Dilek <sedat.dilek@googlemail.com>
To: Jan Beulich <JBeulich@novell.com>
Cc: amodra@gmail.com, Ingo Molnar <mingo@elte.hu>,
        "H.J. Lu" <hjl.tools@gmail.com>, Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        binutils <binutils@sourceware.org>,
        LKML <linux-kernel@vger.kernel.org>, "H. Peter Anvin" <hpa@zytor.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 14, 2011 at 12:38 PM, Sedat Dilek
<sedat.dilek@googlemail.com> wrote:
> [ Changing Alan's Email to valid <amodra@gmail.com> in CC ]
>
> On Mon, Mar 14, 2011 at 12:26 PM, Jan Beulich <JBeulich@novell.com> wrote:
>>>>> On 14.03.11 at 12:02, Sedat Dilek <sedat.dilek@googlemail.com> wrote:
> [...]
>>> [2] Where can someone set a "global behaviour" (hardcoded options) for
>>> his/her assembler in the kernel's build-system (speaking of
>>> "--size-check=[error|warning]")?
>>
>> Nowhere, selecting behavior is possible only via the command line.
>>
>
> Via command-line, something like this would do it?
>
>     $ export AS="/usr/bin/as --size-check=warning
> [...]
>
> - Sedat -
>

By looking through the binutils source-code, I have seen ASFLAGS.

     $ ASFLAGS="--size-check=warning" ; export ASFLAGS

Would that work?

- Sedat -
