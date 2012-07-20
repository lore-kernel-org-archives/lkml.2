Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752961Ab2GTOxx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jul 2012 10:53:53 -0400
Received: from wolverine02.qualcomm.com ([199.106.114.251]:13924 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752766Ab2GTOxv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jul 2012 10:53:51 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6777"; a="210418350"
Message-ID: <500970F3.4010606@codeaurora.org>
Date: Fri, 20 Jul 2012 10:53:39 -0400
From: Christopher Covington <cov@codeaurora.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101208 Thunderbird/3.1.7
MIME-Version: 1.0
To: Catalin Marinas <catalin.marinas@arm.com>
CC: Jon Masters <jonathan@jonmasters.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Arnd Bergmann <arnd@arndb.de>, Will Deacon <Will.Deacon@arm.com>
Subject: Re: [PATCH 08/36] AArch64: Kernel booting and initialisation
References: <1341608777-12982-1-git-send-email-catalin.marinas@arm.com> <1341608777-12982-9-git-send-email-catalin.marinas@arm.com> <50065E6B.3060602@jonmasters.org> <5008445B.2010109@codeaurora.org> <20120720134824.GC6947@arm.com>
In-Reply-To: <20120720134824.GC6947@arm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Catalin,

On 07/20/2012 09:48 AM, Catalin Marinas wrote:
> On Thu, Jul 19, 2012 at 06:31:07PM +0100, Christopher Covington wrote:
>> On 07/18/2012 02:57 AM, Jon Masters wrote:
>>> On 07/06/2012 05:05 PM, Catalin Marinas wrote:
>>>
>>>> +- CPU mode
>>>> +  All forms of interrupts must be masked in PSTATE.DAIF (Debug, SError,
>>>> +  IRQ and FIQ).
>>>> +  The CPU must be in either EL2 (RECOMMENDED) or non-secure EL1.
>>
>> Why not secure EL1?
> 
> Because the secure side does not have virtualisation extensions so you
> won't be able to run something like KVM.

This is another useful explanation to include, in my opinion.

>>> Even though this stuff is likely to be replaced with the result of some
>>> of the other standardization, I'd like it if you'd strongly consider
>>> removing the "or non-secure EL1". If you give an inch, someone will take
>>> a mile and build a system that enters other than in EL2. Or, something
>>> to the effect of "the highest non-secure exception level implemented"
>>> would be my preference if you don't want to specify.
>>
>> I think it would be best to list the technical limitations, from the
>> kernel's perspective, of the unsupported exception levels and the
>> advantages of the supported exception levels here. If you want to guide
>> system builders towards EL2, I think it'd be more convincing to document
>> the relevant technical aspects (perhaps KVM needs facilities only
>> available in EL2) than just providing an unexplained requirement.
> 
> That's not meant to be an official document for SoC designers. It just
> states the requirements from the Linux kernel perspective. But ARM is
> producing platform design documents covering hardware and firmware
> requirements and these will be made available.

I agree that the main audience for this document should be kernel and
bootloader hackers and I now think I concentrated a little too much on
how my suggestions, meant to advocate for that audience, could be seen
as aligned with Jon's comment.

Christopher
-- 
Employee of Qualcomm Innovation Center, Inc.
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum
