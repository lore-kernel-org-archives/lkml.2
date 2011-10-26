Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751870Ab1JZTZl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Oct 2011 15:25:41 -0400
Received: from e23smtp07.au.ibm.com ([202.81.31.140]:41916 "EHLO
	e23smtp07.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751406Ab1JZTZk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Oct 2011 15:25:40 -0400
Message-ID: <4EA85EC3.7070102@linux.vnet.ibm.com>
Date: Thu, 27 Oct 2011 00:55:55 +0530
From: Raghavendra K T <raghukt@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.23) Gecko/20110928 Fedora/3.1.15-1.fc14 Thunderbird/3.1.15
MIME-Version: 1.0
To: Jeremy Fitzhardinge <jeremy@goop.org>
CC: Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>,
        Greg Kroah-Hartman <gregkh@suse.de>, "H. Peter Anvin" <hpa@zytor.com>,
        Gleb Natapov <gleb@redhat.com>,
        Virtualization <virtualization@lists.linux-foundation.org>,
        "x86@kernel.org" <x86@kernel.org>, KVM <kvm@vger.kernel.org>,
        Dave Jiang <dave.jiang@intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Stefano Stabellini <Stefano.Stabellini@eu.citrix.com>,
        Yinghai Lu <yinghai@kernel.org>, Sedat Dilek <sedat.dilek@gmail.com>,
        Ingo Molnar <mingo@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>,
        Xen <xen-devel@lists.xensource.com>, Avi Kivity <avi@redhat.com>,
        Rik van Riel <riel@redhat.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Suzuki Poulose <suzuki@linux.vnet.ibm.com>,
        Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
        Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH RFC V2 5/5] kvm guest : pv-ticketlocks support for linux
 guests running on KVM hypervisor
References: <20111023190307.16364.35381.sendpatchset@oc5400248562.ibm.com> <20111023190753.16364.31164.sendpatchset@oc5400248562.ibm.com> <4EA7017B.5000903@goop.org>
In-Reply-To: <4EA7017B.5000903@goop.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/26/2011 12:05 AM, Jeremy Fitzhardinge wrote:
> On 10/23/2011 12:07 PM, Raghavendra K T wrote:
>>
>> +#ifdef CONFIG_PARAVIRT_SPINLOCKS
>> +
>> +#ifdef CONFIG_KVM_DEBUG_FS
>> +
>> +#include<linux/debugfs.h>
>> +
>> +#endif /* CONFIG_KVM_DEBUG_FS */
>> +
>> +#endif /* CONFIG_PARAVIRT_SPINLOCKS */
>
> This is a big mess.  Is there any problem with including linux/debugfs.h
> unconditionally?  Or at least using "#if
> defined(CONFIG_PARAVIRT_SPINLOCKS)&&  defined(CONFIG_KVM_DEBUG_FS)"?
>

I agree. I 'll include unconditionally unless somebody objects.

>      J

