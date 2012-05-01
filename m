Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753589Ab2EAUUj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 May 2012 16:20:39 -0400
Received: from e23smtp06.au.ibm.com ([202.81.31.148]:48256 "EHLO
	e23smtp06.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751939Ab2EAUUh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 May 2012 16:20:37 -0400
Message-ID: <4FA04576.6030405@linux.vnet.ibm.com>
Date: Wed, 02 May 2012 01:50:06 +0530
From: Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>
Organization: IBM
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.1) Gecko/20120216 Thunderbird/10.0.1
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>
CC: Jeremy Fitzhardinge <jeremy@goop.org>, Greg Kroah-Hartman <gregkh@suse.de>,
        Alexander Graf <agraf@suse.de>, Randy Dunlap <rdunlap@xenotime.net>,
        linux-doc@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        KVM <kvm@vger.kernel.org>,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
        Virtualization <virtualization@lists.linux-foundation.org>,
        X86 <x86@kernel.org>, Gleb Natapov <gleb@redhat.com>,
        Ingo Molnar <mingo@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Xen <xen-devel@lists.xensource.com>,
        Sasha Levin <levinsasha928@gmail.com>,
        Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>
Subject: Re: [PATCH RFC V6 1/5] kvm hypervisor : Add a hypercall to KVM hypervisor
 to support pv-ticketlocks
References: <20120423095937.30893.14776.sendpatchset@codeblue.in.ibm.com> <20120423095947.30893.84029.sendpatchset@codeblue.in.ibm.com> <4F9D415B.7010103@redhat.com> <4F9E42F6.8050108@linux.vnet.ibm.com>
In-Reply-To: <4F9E42F6.8050108@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
x-cbid: 12050110-7014-0000-0000-00000103196F
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/30/2012 01:14 PM, Raghavendra K T wrote:

>>> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
>>> index 4044ce0..7fc9be6 100644
>>> --- a/arch/x86/kvm/x86.c
>>> +++ b/arch/x86/kvm/x86.c
>>> @@ -2147,6 +2147,7 @@ int kvm_dev_ioctl_check_extension(long ext)
>>> case KVM_CAP_ASYNC_PF:
>>> case KVM_CAP_GET_TSC_KHZ:
>>> case KVM_CAP_PCI_2_3:
>>> + case KVM_CAP_PV_UNHALT:
>>> r = 1;
>>> break;
>>> case KVM_CAP_COALESCED_MMIO:
>>
>> Redundant, since we can infer this from KVM_GET_SUPPORTED_CPUID. But
>> please indicate this in the documentation.
>>
>
> Ok. will mention that in documentation added for KVM_CAP_PV_UNHALT.
>

I think it is better to remove  KVM_CAP_PV_UNHALT itself and avoid
spamming CAP.. will do that in coming version.

