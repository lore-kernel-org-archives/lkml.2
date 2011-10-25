Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753186Ab1JYSLj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Oct 2011 14:11:39 -0400
Received: from e28smtp02.in.ibm.com ([122.248.162.2]:57748 "EHLO
	e28smtp02.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752982Ab1JYSLh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Oct 2011 14:11:37 -0400
Message-ID: <4EA6FBEA.8080506@linux.vnet.ibm.com>
Date: Tue, 25 Oct 2011 23:41:54 +0530
From: Raghavendra K T <raghukt@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.23) Gecko/20110928 Fedora/3.1.15-1.fc14 Thunderbird/3.1.15
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>
CC: Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>,
        Greg Kroah-Hartman <gregkh@suse.de>, KVM <kvm@vger.kernel.org>,
        Sedat Dilek <sedat.dilek@gmail.com>, Ingo Molnar <mingo@redhat.com>,
        Virtualization <virtualization@lists.linux-foundation.org>,
        Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>, Dave Jiang <dave.jiang@intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
        Gleb Natapov <gleb@redhat.com>, Yinghai Lu <yinghai@kernel.org>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Xen <xen-devel@lists.xensource.com>, Rik van Riel <riel@redhat.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Suzuki Poulose <suzuki@linux.vnet.ibm.com>,
        Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
        Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH RFC V2 4/5] kvm guest : Added configuration support to
 enable debug information for KVM Guests
References: <20111023190307.16364.35381.sendpatchset@oc5400248562.ibm.com> <20111023190700.16364.7548.sendpatchset@oc5400248562.ibm.com> <4EA53AB2.9050805@redhat.com>
In-Reply-To: <4EA53AB2.9050805@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/24/2011 03:45 PM, Avi Kivity wrote:
> On 10/23/2011 09:07 PM, Raghavendra K T wrote:
>> Added configuration support to enable debug information
>> for KVM Guests in debugfs
>>
>> Signed-off-by: Srivatsa Vaddagiri<vatsa@linux.vnet.ibm.com>
>> Signed-off-by: Suzuki Poulose<suzuki@in.ibm.com>
>> Signed-off-by: Raghavendra K T<raghavendra.kt@linux.vnet.ibm.com>
>> ---
>> diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
>> index 1f03f82..ed34269 100644
>> --- a/arch/x86/Kconfig
>> +++ b/arch/x86/Kconfig
>> @@ -562,6 +562,15 @@ config KVM_GUEST
>>   	  This option enables various optimizations for running under the KVM
>>   	  hypervisor.
>>
>> +config KVM_DEBUG_FS
>> +	bool "Enable debug information for KVM Guests in debugfs"
>> +	depends on KVM_GUEST
>> +	default n
>> +	---help---
>> +	  This option enables collection of various statistics for KVM guest.
>> +   	  Statistics are displayed in debugfs filesystem. Enabling this option
>> +	  may incur significant overhead.
>> +
>>   source "arch/x86/lguest/Kconfig"
>>
>>
>
> This might be better implemented through tracepoints, which an be
> enabled dynamically.
>
Interesting option. I 'll explore this one. Thanks for pointing.
