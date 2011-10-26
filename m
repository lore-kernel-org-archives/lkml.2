Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752347Ab1JZTyr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Oct 2011 15:54:47 -0400
Received: from e28smtp02.in.ibm.com ([122.248.162.2]:33716 "EHLO
	e28smtp02.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752143Ab1JZTyp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Oct 2011 15:54:45 -0400
Message-ID: <4EA86598.1060604@linux.vnet.ibm.com>
Date: Thu, 27 Oct 2011 01:25:04 +0530
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
References: <20111023190307.16364.35381.sendpatchset@oc5400248562.ibm.com> <20111023190753.16364.31164.sendpatchset@oc5400248562.ibm.com> <4EA7012B.5040808@goop.org> <4EA85E32.3080107@linux.vnet.ibm.com> <4EA86387.5040108@goop.org>
In-Reply-To: <4EA86387.5040108@goop.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/27/2011 01:16 AM, Jeremy Fitzhardinge wrote:
> On 10/26/2011 12:23 PM, Raghavendra K T wrote:
>> On 10/26/2011 12:04 AM, Jeremy Fitzhardinge wrote:
>>> On 10/23/2011 12:07 PM, Raghavendra K T wrote:
>
>> our current aim was to have before any printk happens.
>> So I  'll trim the comment to somethings like :
>>
>> Setup pv_lock_ops to exploit KVM_FEATURE_WAIT_FOR_KICK if present.
>> This needs to be setup early in boot. ?
>
> You can hook the smp_ops.smp_prepare_cpus call and initialize it there.
> There's no need to add new hook code.
>

Ok.. Thanks for pointer. 'll check on that.

>      J
>

