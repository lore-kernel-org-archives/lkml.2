Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752968Ab2GJURj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jul 2012 16:17:39 -0400
Received: from h1446028.stratoserver.net ([85.214.92.142]:35183 "EHLO
	mail.ahsoftware.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752724Ab2GJURi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jul 2012 16:17:38 -0400
Message-ID: <4FFC8DA3.6010100@ahsoftware.de>
Date: Tue, 10 Jul 2012 22:16:35 +0200
From: Alexander Holler <holler@ahsoftware.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120605 Thunderbird/13.0
MIME-Version: 1.0
To: Joe Perches <joe@perches.com>
CC: Catalin Marinas <catalin.marinas@arm.com>, Ingo Molnar <mingo@kernel.org>,
        Arnd Bergmann <arnd@arndb.de>, Olof Johansson <olof@lixom.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Russell King <linux@arm.linux.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH 00/36] AArch64 Linux kernel port
References: <1341608777-12982-1-git-send-email-catalin.marinas@arm.com>  <CAOesGMiCexiqA3L5GdNgyHhSD-5Bpqbb02YJrZPr8yMYa0afjA@mail.gmail.com>  <201207071927.13135.arnd@arndb.de> <20120710071023.GA10456@gmail.com>  <20120710101018.GE15120@arm.com> <1341940476.6118.150.camel@joe2Laptop>
In-Reply-To: <1341940476.6118.150.camel@joe2Laptop>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 10.07.2012 19:14, schrieb Joe Perches:
> On Tue, 2012-07-10 at 11:10 +0100, Catalin Marinas wrote:
>> On Tue, Jul 10, 2012 at 08:10:23AM +0100, Ingo Molnar wrote:
>>> * Arnd Bergmann <arnd@arndb.de> wrote:
>>>> On Saturday 07 July 2012, Olof Johansson wrote:
>>>>>> ARM introduced AArch64 as part of the ARMv8 architecture
>>>>>
>>>>> With the risk of bikeshedding here, but I find the name awkward. How
>>>>> about just naming the arch port arm64 instead? It's considerably more
>>>>> descriptive in the context of the kernel.  For reference, we didn't
>>>>> name ppc64, nor powerpc, after what the IBM/power.org marketing people
>>>>> were currently calling the architecture at the time either.
>>>>
>>>> I agree the name sucks, [...]
>>>
>>> So why not change it now, when it only bothers a few dozen
>>> people and it is only present in 36 patches? Why go full steam
>>> ahead to annoy thousands of people with it and why spread the
>>> naming madness to thousands of commits?
>>
>> Changing the arch/ dir name is easy at this point. My preference is for
>> consistency with the official name (that cannot be changed) and the gcc
>> triplet. I also don't think it annoys thousands of people, most don't
>> really care. The few reactions I've seen is pretty much because people
>> were expecting arm64 and it came as something else.
>
> Count me as one of the 1000s that think it's a poor name choice.
> I think it's a poor name for marketing purposes too.

Add me to the thousands too.

Using AArch64 is like calling a fly Brachycera or a dog Canis lupus 
familiaris. It might be correct, but it is a name I wouldn't want to use 
when I would need to name the architecture. Try to make a presentation 
where you have to say AArch64 a dozen times. Those two As are imho just 
annoying to speak, besides that AArch64 doesn't given a hint by itself 
that is meant for ARM processors.

And it isn't so that the name will have to be used that seldom, at least 
every distribution would need to use it to name the flavour, like e.g. 
"Fedora AArch64hf" or "Debian AArch64".

Regards,

Alexander
