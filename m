Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754342Ab2HKKDA (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Aug 2012 06:03:00 -0400
Received: from e23smtp07.au.ibm.com ([202.81.31.140]:33136 "EHLO
	e23smtp07.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753515Ab2HKKCy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Aug 2012 06:02:54 -0400
Message-ID: <50262D1C.6080601@linux.vnet.ibm.com>
Date: Sat, 11 Aug 2012 15:29:56 +0530
From: Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>
Organization: IBM
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.1) Gecko/20120216 Thunderbird/10.0.1
MIME-Version: 1.0
To: Marcelo Tosatti <mtosatti@redhat.com>
CC: Rob Landley <rob@landley.net>, linux-kernel@vger.kernel.org,
        linux-doc@vger.kernel.org, Alexander Graf <agraf@suse.de>,
        Randy Dunlap <rdunlap@xenotime.net>, KVM <kvm@vger.kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>, Gleb Natapov <gleb@redhat.com>,
        Ingo Molnar <mingo@redhat.com>, Avi Kivity <avi@redhat.com>,
        Jan Kiszka <jan.kiszka@siemens.com>, X86 <x86@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH 0/3] Documentation : hypercalls
References: <20120807073946.20169.72958.sendpatchset@codeblue.in.ibm.com> <20120809183120.GA20343@amt.cnet>
In-Reply-To: <20120809183120.GA20343@amt.cnet>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
x-cbid: 12081110-0260-0000-0000-000001AA17B7
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/10/2012 12:01 AM, Marcelo Tosatti wrote:
> On Tue, Aug 07, 2012 at 01:09:46PM +0530, Raghavendra K T wrote:
>> This is the hypercall documentation patch series
>> First patch covers KVM specific hypercall information.
>>
>> second patch is has typo fix for vmcall instruction
>> comment in kvm_para.h
>>
>> Third patch includes a veryful documentation on PowerPC
>> hypercalls originally written by Alex
>>
>> Changes since initial post:
>>   - Added hypercall ABI (Peter)
>>   - made KVM_HC_VAPIC_POLL_IRQ active explicitly (Randy)
>>   - Changed vmrun/vmmrun ==>  vmcall/vmmcall (Marcelo)
>>   - use Linux KVM hypercall instead of ABI  (Marcelo)
>>   - correct PowerPC typo (Alex)
>>   - Remove value field (Alex)
>>
>> Raghavendra K T (2):
>>   Documentation/kvm : Add documentation on hypercalls
>>   Documentation/header : Correct vmrun to vmcall typo
>>
>> Alexander Graf (1) :
>>   Documentation/ppc: Add ppc hypercall documentation
>>
>>   Documentation/virtual/kvm/hypercalls.txt |   66 ++++++++++++++++++++++++++++++
>>   Documentation/virtual/kvm/ppc-pv.txt     |   22 ++++++++++
>>   arch/x86/include/asm/kvm_para.h          |    2 +-
>>   3 files changed, 89 insertions(+), 1 deletions(-)
>
> ACK
>
>

Thank you Marcelo.

