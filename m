Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754506Ab1JXJdZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Oct 2011 05:33:25 -0400
Received: from e23smtp09.au.ibm.com ([202.81.31.142]:56222 "EHLO
	e23smtp09.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754180Ab1JXJdX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Oct 2011 05:33:23 -0400
Message-ID: <4EA530E0.9070107@linux.vnet.ibm.com>
Date: Mon, 24 Oct 2011 15:03:20 +0530
From: Raghavendra K T <raghukt@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.23) Gecko/20110928 Fedora/3.1.15-1.fc14 Thunderbird/3.1.15
MIME-Version: 1.0
To: Sasha Levin <levinsasha928@gmail.com>
CC: Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>,
        Greg Kroah-Hartman <gregkh@suse.de>, "H. Peter Anvin" <hpa@zytor.com>,
        Gleb Natapov <gleb@redhat.com>,
        Virtualization <virtualization@lists.linux-foundation.org>,
        Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>, x86@kernel.org,
        KVM <kvm@vger.kernel.org>, Dave Jiang <dave.jiang@intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
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
References: <20111023190307.16364.35381.sendpatchset@oc5400248562.ibm.com> <20111023190753.16364.31164.sendpatchset@oc5400248562.ibm.com> <1319450514.5660.7.camel@lappy>
In-Reply-To: <1319450514.5660.7.camel@lappy>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
x-cbid: 11102400-3568-0000-0000-000000923C12
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/24/2011 03:31 PM, Sasha Levin wrote:
> On Mon, 2011-10-24 at 00:37 +0530, Raghavendra K T wrote:
>> +#else /* CONFIG_PARAVIRT_SPINLOCKS */
>> +#define kvm_guest_early_init() do { } while (0)
>
> This should be defined as an empty function.
>
Yes Agree, I 'll change to an empty function.
- Raghu

