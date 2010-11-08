Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754543Ab0KHLUs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Nov 2010 06:20:48 -0500
Received: from mail-iw0-f174.google.com ([209.85.214.174]:44314 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754475Ab0KHLUq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Nov 2010 06:20:46 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=Bny2H5rxFTR8YnGcqiMlCofqF5qYkjGmCZ9gIum8/z8WJj1zF2sBO2JllnpxIizr4R
         jfh0W0BbYfuAEhtmwgFdDvvj6K3bj+W+rfQX3eat86czRSGcwFgKsy9J5ygSXUeWE5Cv
         IAgkONof1QkmvV8RTB1Xzv/jnSC4ewEK+rL5I=
MIME-Version: 1.0
In-Reply-To: <877hgorrj1.fsf@basil.nowhere.org>
References: <4CD538CA.8010901@xs4all.nl>
	<87wroostw3.fsf@basil.nowhere.org>
	<m2hbfsu57i.fsf@igel.home>
	<87k4kospnd.fsf@basil.nowhere.org>
	<AANLkTikG6kBxSrO7EZ5_nZqTKqo8Rjm2stoEGVJWxanz@mail.gmail.com>
	<877hgorrj1.fsf@basil.nowhere.org>
Date: Mon, 8 Nov 2010 12:20:46 +0100
Message-ID: <AANLkTi=tC01jshWAr_HyVs6-HKK-Puarb6cLpxZyg-Kr@mail.gmail.com>
Subject: Re: gcc 4.5.1 / as 2.20.51.0.11 miscompiling drivers/char/i8k.c ?
From: Richard Guenther <richard.guenther@gmail.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: Andreas Schwab <schwab@linux-m68k.org>, Jim <jim876@xs4all.nl>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        gcc@gcc.gnu.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 8, 2010 at 12:20 PM, Andi Kleen <andi@firstfloor.org> wrote:
> Richard Guenther <richard.guenther@gmail.com> writes:
>
>> On Mon, Nov 8, 2010 at 12:03 AM, Andi Kleen <andi@firstfloor.org> wrote:
>>> Andreas Schwab <schwab@linux-m68k.org> writes:
>>>>
>>>> The asm fails to mention that it modifies *regs.
>>>
>>> It has a memory clobber, that should be enough, no?
>>
>> No.  A memory clobber does not cover automatic storage.
>
> That's a separate problem.
>
>> Btw, I can't see a testcase anywhere so I just assume Andreas got
>> it right as usual.
>
> An asm with live inputs and outputs should never be optimized
> way. If 4.5.1 started doing that it's seriously broken.

Please provide a testcase, such asms can be optimized if the
outputs are dead.

Richard.

> -Andi
>
> --
> ak@linux.intel.com -- Speaking for myself only.
>
