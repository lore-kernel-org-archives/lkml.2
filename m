Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754178Ab2HBHLQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Aug 2012 03:11:16 -0400
Received: from e23smtp08.au.ibm.com ([202.81.31.141]:44463 "EHLO
	e23smtp08.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752936Ab2HBHLO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Aug 2012 03:11:14 -0400
Message-ID: <501A2775.90404@linux.vnet.ibm.com>
Date: Thu, 02 Aug 2012 12:38:37 +0530
From: Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>
Organization: IBM
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.1) Gecko/20120216 Thunderbird/10.0.1
MIME-Version: 1.0
To: Marcelo Tosatti <mtosatti@redhat.com>, Alexander Graf <agraf@suse.de>
CC: Rob Landley <rob@landley.net>, linux-kernel@vger.kernel.org,
        linux-doc@vger.kernel.org, Randy Dunlap <rdunlap@xenotime.net>,
        KVM <kvm@vger.kernel.org>, "H. Peter Anvin" <hpa@zytor.com>,
        Gleb Natapov <gleb@redhat.com>, Ingo Molnar <mingo@redhat.com>,
        Avi Kivity <avi@redhat.com>, Jan Kiszka <jan.kiszka@siemens.com>
Subject: Re: [PATCH] Documentation/kvm : Add documentation on Hypercalls
References: <20120724085359.11344.91022.sendpatchset@codeblue.in.ibm.com> <20120801030736.GA31711@amt.cnet> <5019099D.9050608@linux.vnet.ibm.com> <20120801182554.GA9464@amt.cnet>
In-Reply-To: <20120801182554.GA9464@amt.cnet>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
x-cbid: 12080207-5140-0000-0000-000001DA55ED
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/01/2012 11:55 PM, Marcelo Tosatti wrote:
> On Wed, Aug 01, 2012 at 04:19:01PM +0530, Raghavendra K T wrote:
>> On 08/01/2012 08:37 AM, Marcelo Tosatti wrote:
>>> On Tue, Jul 24, 2012 at 02:23:59PM +0530, Raghavendra K T wrote:
>>>> From: Raghavendra K T<raghavendra.kt@linux.vnet.ibm.com>
>>>>
>>>> Thanks Alex for KVM_HC_FEATURES inputs and Jan for VAPIC_POLL_IRQ,
>>>> and Peter (HPA) for suggesting hypercall ABI addition.
>>>>
>>>> Signed-off-by: Raghavendra K T<raghavendra.kt@linux.vnet.ibm.com>
>>>> ---
[...]
>>>> +
>>>> + Up to four arguments may be passed in rbx, rcx, rdx, and rsi respectively.
>>>> + The hypercall number should be placed in rax and the return value will be
>>>> + placed in rax.  No other registers will be clobbered unless explicitly stated
>>>> + by the particular hypercall.
>>>
>>> It depends on the hypercall. It happens that current hypercalls use
>>> the four registers, but its not an ABI (hyper-v hypercalls uses r8, for example).
>>>
>>
>> Okay, agree. I did not know about hyper-v. Above one is for X86 and
>> KVM  (and not X86 / hyper-v). So I should remove ABI and probably say,
>
> Just say "Linux x86 Hypercall", yeah.
>

Ok, Thanks Marcelo.will respin patches with the changes you suggested.

Also I would  like add Alex's description on ppc hypercalls
into Documentation/virtual/kvm/ppc-pv.txt with Alex from/sob or
suggested-by in a separate patch unless I see any objection to that.

