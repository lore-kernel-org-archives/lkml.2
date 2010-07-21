Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753395Ab0GUUVB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jul 2010 16:21:01 -0400
Received: from mailout2.w1.samsung.com ([210.118.77.12]:10656 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752319Ab0GUUU5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jul 2010 16:20:57 -0400
Date: Wed, 21 Jul 2010 22:22:19 +0200
From: =?utf-8?B?TWljaGHFgiBOYXphcmV3aWN6?= <m.nazarewicz@samsung.com>
Subject: Re: [PATCH 2/4] mm: cma: Contiguous Memory Allocator added
In-reply-to: <1279742604.31376.40.camel@c-dwalke-linux.qualcomm.com>
To: Daniel Walker <dwalker@codeaurora.org>
Cc: linux-mm@kvack.org, Marek Szyprowski <m.szyprowski@samsung.com>,
        Pawel Osciak <p.osciak@samsung.com>,
        Xiaolin Zhang <xiaolin.zhang@intel.com>,
        Hiremath Vaibhav <hvaibhav@ti.com>,
        Robert Fekete <robert.fekete@stericsson.com>,
        Marcus Lorentzon <marcus.xm.lorentzon@stericsson.com>,
        linux-kernel@vger.kernel.org,
        Kyungmin Park <kyungmin.park@samsung.com>,
        linux-arm-msm@vger.kernel.org
Message-id: <op.vf7mvhvn7p4s8u@pikus>
Organization: Samsung Electronics
MIME-version: 1.0
Content-type: text/plain; charset=utf-8; format=flowed; delsp=yes
Content-transfer-encoding: 8BIT
User-Agent: Opera Mail/10.60 (Linux)
References: <cover.1279639238.git.m.nazarewicz@samsung.com>
 <d6d104950c1391eaf3614d56615617cee5722fb4.1279639238.git.m.nazarewicz@samsung.com>
 <adceebd371e8a66a2c153f429b38068eca99e99f.1279639238.git.m.nazarewicz@samsung.com>
 <1279649724.26765.23.camel@c-dwalke-linux.qualcomm.com>
 <op.vf5o28st7p4s8u@pikus>
 <1279654698.26765.31.camel@c-dwalke-linux.qualcomm.com>
 <op.vf6zo9vb7p4s8u@pikus>
 <1279733750.31376.14.camel@c-dwalke-linux.qualcomm.com>
 <op.vf7gt3qy7p4s8u@pikus>
 <1279736348.31376.20.camel@c-dwalke-linux.qualcomm.com>
 <op.vf7h1yc47p4s8u@pikus>
 <1279738688.31376.24.camel@c-dwalke-linux.qualcomm.com>
 <op.vf7j13067p4s8u@pikus>
 <1279741029.31376.33.camel@c-dwalke-linux.qualcomm.com>
 <op.vf7lipj67p4s8u@pikus>
 <1279742604.31376.40.camel@c-dwalke-linux.qualcomm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 21 Jul 2010 22:03:24 +0200, Daniel Walker <dwalker@codeaurora.org> wrote:

> On Wed, 2010-07-21 at 21:53 +0200, Michał Nazarewicz wrote:
>> On Wed, 21 Jul 2010 21:37:09 +0200, Daniel Walker <dwalker@codeaurora.org> wrote:
>> > What makes you assume that the bootloader would have these strings?
>> > Do your devices have these strings? Maybe mine don't have them.
>>
>> I don't assume.  I only state it as one of the possibilities.
>>
>> > Assume the strings are gone and you can't find them, or have no idea
>> > what they should be. What do you do then?
>>
>> Ask Google?
>
> Exactly, that's why they need to be in the kernel ..

Right.....  Please show me a place where I've written that it won't be in
the kernel? I keep repeating command line is only one of the possibilities.
I would imagine that in final product defaults from platform would be used
and bootloader would be left alone.

>> I have a better question for you though: assume the "mem" parameter is
>> lost and you have no idea what it should be?  There are many parameters
>> passed to kernel by bootloader and you could ask about all of them.
>
> That's hardware based tho. Of course you need info on what your hardware
> is. What your doing isn't based on hardware specifics, it's based on
> optimizations.
>
>> Passing cma configuration via command line is one of the possibilities
>> -- especially convenient during development -- but I would expect platform
>> defaults in a final product so you may well not need to worry about it.
>
> I honestly don't thing the "development" angle flies either , but if you
> keep this there's no way it should be enabled for anything but debug.

If you are developing the whole platform and optimising the allocators,
etc. it's very convenient.  If you develop something else then it's not
needed but then again it's usually the case that if you develop “foo”
then “bar” is not needed.

>> Would you also argue about removing all the other kernel parameters as
>> well? I bet you don't use most of them.  Still they are there because
>> removing them would add too much complexity to the code (conditional
>> compilation, etc.).
>
> Your is at a different level of complexity ..

Which most of will remain even if the command line parameters were to
be removed.  One needs to specify this configuration somehow and no
matter how you do it it will be complex in one way or another.  In my
code the complexity is parsing of the strings, in a different approach
it would be complex in a different way.

At the same time, the fact that the parameters can be provided via command
line is has a minimal impact on the code.

-- 
Best regards,                                        _     _
| Humble Liege of Serenely Enlightened Majesty of  o' \,=./ `o
| Computer Science,  Michał "mina86" Nazarewicz       (o o)
+----[mina86*mina86.com]---[mina86*jabber.org]----ooO--(_)--Ooo--
