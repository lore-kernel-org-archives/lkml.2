Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751513Ab2JTEYM (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Oct 2012 00:24:12 -0400
Received: from mail-oa0-f46.google.com ([209.85.219.46]:65354 "EHLO
	mail-oa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750921Ab2JTEYL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Oct 2012 00:24:11 -0400
MIME-Version: 1.0
In-Reply-To: <5081F5B0.7000707@cn.fujitsu.com>
References: <1350641777-19605-1-git-send-email-wency@cn.fujitsu.com>
 <1350641777-19605-2-git-send-email-wency@cn.fujitsu.com> <CAHGf_=oDTLC8ebNgwCbT7NyxLre9c8ZokEKgjrORgzaHfZsTqQ@mail.gmail.com>
 <5081F5B0.7000707@cn.fujitsu.com>
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Date: Sat, 20 Oct 2012 00:23:49 -0400
X-Google-Sender-Auth: zDoJ37i-o7uEE0xS0rKDVl-w6Jk
Message-ID: <CAHGf_=rLUyRf2ptTZzhdPn3feJ2My95joMxYnoAM3jxc=qm4Rw@mail.gmail.com>
Subject: Re: [RESEND PATCH v2 1/2] update mem= option's spec according to its implementation
To: Wen Congyang <wency@cn.fujitsu.com>
Cc: x86@kernel.org, linux-kernel@vger.kernel.org, rob@landley.net,
        tglx@linutronix.de, mingo@redhat.com, bhelgaas@google.com,
        hpa@zytor.com, isimatu.yasuaki@jp.fujitsu.com,
        muneda.takahiro@jp.fujitsu.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 19, 2012 at 8:52 PM, Wen Congyang <wency@cn.fujitsu.com> wrote:
> At 10/20/2012 02:11 AM, KOSAKI Motohiro Wrote:
>> On Fri, Oct 19, 2012 at 6:16 AM,  <wency@cn.fujitsu.com> wrote:
>>> From: Wen Congyang <wency@cn.fujitsu.com>
>>>
>>> Current mem= implementation seems buggy because specification and
>>> implementation doesn't match. Current mem= has been working
>>> for many years and it's not buggy, it works as expected. So
>>> we should update the specification.
>>>
>>> Signed-off-by: Wen Congyang <wency@cn.fujitsu.com>
>>> Sort-of-tentatively-acked-by: Rob Landley <rob@landley.net>
>>> ---
>>>  Documentation/kernel-parameters.txt |    7 ++++---
>>>  1 files changed, 4 insertions(+), 3 deletions(-)
>>>
>>> diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
>>> index 9776f06..85b911a 100644
>>> --- a/Documentation/kernel-parameters.txt
>>> +++ b/Documentation/kernel-parameters.txt
>>> @@ -1481,9 +1481,10 @@ bytes respectively. Such letter suffixes can also be entirely omitted.
>>>         mem=nn[KMG]     [KNL,BOOT] Force usage of a specific amount of memory
>>>                         Amount of memory to be used when the kernel is not able
>>>                         to see the whole system memory or for test.
>>> -                       [X86-32] Use together with memmap= to avoid physical
>>> -                       address space collisions. Without memmap= PCI devices
>>> -                       could be placed at addresses belonging to unused RAM.
>>> +                       [X86-32] Work as limiting max address. Use together
>>> +                       with memmap= to avoid physical address space collisions.
>>> +                       Without memmap= PCI devices could be placed at addresses
>>> +                       belonging to unused RAM.
>>
>> If my remember is correct, x86-64 also specify maximum address.
>> but my remember is not clear.
>
> Do you mean max_addr option? It is only for ia64 box.

No.
Your patch say x86-32 and x86-64 have different mem parameter
semantics. and I doubt it.
