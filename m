Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752066Ab2GHSNQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Jul 2012 14:13:16 -0400
Received: from mx1.redhat.com ([209.132.183.28]:27556 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751768Ab2GHSNP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Jul 2012 14:13:15 -0400
Message-ID: <4FF9CDAE.30305@redhat.com>
Date: Sun, 08 Jul 2012 14:13:02 -0400
From: Jon Masters <jcm@redhat.com>
Organization: Red Hat, Inc.
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: "Dr. David Alan Gilbert" <linux@treblig.org>
CC: Arnd Bergmann <arnd@arndb.de>, Olof Johansson <olof@lixom.net>,
        Catalin Marinas <catalin.marinas@arm.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 00/36] AArch64 Linux kernel port
References: <1341608777-12982-1-git-send-email-catalin.marinas@arm.com> <CAOesGMiCexiqA3L5GdNgyHhSD-5Bpqbb02YJrZPr8yMYa0afjA@mail.gmail.com> <201207071927.13135.arnd@arndb.de> <4FF93C99.80203@redhat.com> <20120708111736.GA11121@gallifrey>
In-Reply-To: <20120708111736.GA11121@gallifrey>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/08/2012 07:17 AM, Dr. David Alan Gilbert wrote:
> * Jon Masters (jcm@redhat.com) wrote:
>> On 07/07/2012 03:27 PM, Arnd Bergmann wrote:
>>> On Saturday 07 July 2012, Olof Johansson wrote:
>>>
>>>>> ARM introduced AArch64 as part of the ARMv8 architecture
>>>>
>>>> With the risk of bikeshedding here, but I find the name awkward. How
>>>> about just naming the arch port arm64 instead? It's considerably more
>>>> descriptive in the context of the kernel.  For reference, we didn't
>>>> name ppc64, nor powerpc, after what the IBM/power.org marketing people
>>>> were currently calling the architecture at the time either.
>>>
>>> I agree the name sucks, and I'd much prefer to just call it arm64
>>> as well. The main advantage of the aarch64 name is that it's the
>>> same as the identifier in the elf triplet, and it makes sense to
>>> keep the same name for all places where we need to identify the
>>> architecture. This also includes the rpm and dpkg architecture names,
>>> and the string returned by the uname syscall. If everything else
>>> is aarch64, we should use that in the kernel directory too, but
>>> if everyone calls it arm64 anyway, we should probably use that name
>>> for as many things as possible.
>>
>> FWIW I actually really like the aarch64 name (but you know that already
>> :) ). I think it clearly spells out that this is not just a 64-bit
>> extension to the existing 32-bit ARM Architecture, it is a new (inspired
>> by ARM) architecture. Implementations will also run in AArch32 state
>> (A32 and T32), but it's not like x86->x86_64.
> 
> It's one advantage is that it won't trigger the infinite number
> of broken scripts out there that do something on arm*

Indeed. I believe that was another reason for the name choice,
especially in the toolchain, but also in kernel/uname.

Jon.
