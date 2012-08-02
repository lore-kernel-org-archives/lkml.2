Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753439Ab2HBKMM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Aug 2012 06:12:12 -0400
Received: from cantor2.suse.de ([195.135.220.15]:54447 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752094Ab2HBKMJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Aug 2012 06:12:09 -0400
References: <20120724085359.11344.91022.sendpatchset@codeblue.in.ibm.com> <20120801030736.GA31711@amt.cnet> <5019099D.9050608@linux.vnet.ibm.com> <20120801182554.GA9464@amt.cnet> <501A2775.90404@linux.vnet.ibm.com>
In-Reply-To: <501A2775.90404@linux.vnet.ibm.com>
Mime-Version: 1.0 (1.0)
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain;
	charset=us-ascii
Message-Id: <843859B1-67E7-46E3-9121-592F59450AA8@suse.de>
Cc: Marcelo Tosatti <mtosatti@redhat.com>, Rob Landley <rob@landley.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        Randy Dunlap <rdunlap@xenotime.net>, KVM <kvm@vger.kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>, Gleb Natapov <gleb@redhat.com>,
        Ingo Molnar <mingo@redhat.com>, Avi Kivity <avi@redhat.com>,
        Jan Kiszka <jan.kiszka@siemens.com>
X-Mailer: iPhone Mail (9A406)
From: Alexander Graf <agraf@suse.de>
Subject: Re: [PATCH] Documentation/kvm : Add documentation on Hypercalls
Date: Thu, 2 Aug 2012 12:13:00 +0200
To: Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 02.08.2012, at 09:08, Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com> wrote:

> On 08/01/2012 11:55 PM, Marcelo Tosatti wrote:
>> On Wed, Aug 01, 2012 at 04:19:01PM +0530, Raghavendra K T wrote:
>>> On 08/01/2012 08:37 AM, Marcelo Tosatti wrote:
>>>> On Tue, Jul 24, 2012 at 02:23:59PM +0530, Raghavendra K T wrote:
>>>>> From: Raghavendra K T<raghavendra.kt@linux.vnet.ibm.com>
>>>>> 
>>>>> Thanks Alex for KVM_HC_FEATURES inputs and Jan for VAPIC_POLL_IRQ,
>>>>> and Peter (HPA) for suggesting hypercall ABI addition.
>>>>> 
>>>>> Signed-off-by: Raghavendra K T<raghavendra.kt@linux.vnet.ibm.com>
>>>>> ---
> [...]
>>>>> +
>>>>> + Up to four arguments may be passed in rbx, rcx, rdx, and rsi respectively.
>>>>> + The hypercall number should be placed in rax and the return value will be
>>>>> + placed in rax.  No other registers will be clobbered unless explicitly stated
>>>>> + by the particular hypercall.
>>>> 
>>>> It depends on the hypercall. It happens that current hypercalls use
>>>> the four registers, but its not an ABI (hyper-v hypercalls uses r8, for example).
>>>> 
>>> 
>>> Okay, agree. I did not know about hyper-v. Above one is for X86 and
>>> KVM  (and not X86 / hyper-v). So I should remove ABI and probably say,
>> 
>> Just say "Linux x86 Hypercall", yeah.
>> 
> 
> Ok, Thanks Marcelo.will respin patches with the changes you suggested.
> 
> Also I would  like add Alex's description on ppc hypercalls
> into Documentation/virtual/kvm/ppc-pv.txt with Alex from/sob or
> suggested-by in a separate patch unless I see any objection to that.
> 

Yeah, don't stall this on me :)

Alex