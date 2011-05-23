Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754202Ab1EWLNM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 May 2011 07:13:12 -0400
Received: from mail-vx0-f174.google.com ([209.85.220.174]:49981 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754159Ab1EWLNK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 May 2011 07:13:10 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=OC4bFNDzvAdxQTdQi3l/NK+1q12UuTFzh5w9nZWhO+387GpGK5fmumA9G5GHmGUzat
         YrhOeKw4ywzGOomveiMY0kZyvOqSJKhwRBI6GrNdAz1UQS1Qs0PA0e8kk816Ml75/ZrG
         Yxxpb/bsZSWIJOGimVZx/LUxc1BUtvGP5L+CA=
MIME-Version: 1.0
In-Reply-To: <20110523105522.GC24674@elte.hu>
References: <20110520161210.81bbef3a.sfr@canb.auug.org.au>
	<BANLkTi=Dn_jvJ8mLY0Bc6C1Ptoqa-kJrCg@mail.gmail.com>
	<20110523090918.GA5474@elte.hu>
	<BANLkTi=Vbr+DRBy6sa7omGpvAb0uGunYMA@mail.gmail.com>
	<20110523105522.GC24674@elte.hu>
Date: Mon, 23 May 2011 14:13:09 +0300
Message-ID: <BANLkTinh8raz_96vgdgzzeeG+1TM=s5eVw@mail.gmail.com>
Subject: Re: [bloat] Measuring header file bloat effects on kernel build
 performance: a more than 2x slowdown ...
From: Alexey Dobriyan <adobriyan@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
        David Miller <davem@davemloft.net>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, x86@kernel.org,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 23, 2011 at 1:55 PM, Ingo Molnar <mingo@elte.hu> wrote:
>
> * Alexey Dobriyan <adobriyan@gmail.com> wrote:
>
>> On Mon, May 23, 2011 at 12:09 PM, Ingo Molnar <mingo@elte.hu> wrote:

>> > Anway, what i tried to demonstrate with this mail how much *real* slowdown
>> > in the kernel build our current header file bloat is causing. We could
>> > literally halve our kernel build times if we fixed this!
>>
>> News at 11!
>
> I have not seen *actual hard numbers* measured before, so how exactly is this
> news at 11? So i think your condescending reply is neither fair nor justified.

That's because the final number itself neither important nor interesting.
It's enough to know it's big enough.

Even removing "extern" from prototypes has small but noticeable effect,
you're talking about real headers.

Linus dropped few header cleanups of mine, I don't even know when is
the right time
to send them now.
