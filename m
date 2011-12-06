Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754869Ab1LFGy1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Dec 2011 01:54:27 -0500
Received: from e28smtp04.in.ibm.com ([122.248.162.4]:37057 "EHLO
	e28smtp04.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754530Ab1LFGyY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Dec 2011 01:54:24 -0500
Message-ID: <4EDDBC0D.5090602@linux.vnet.ibm.com>
Date: Tue, 06 Dec 2011 12:24:05 +0530
From: Raghavendra K T <raghukt@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.24) Gecko/20111108 Fedora/3.1.16-1.fc14 Thunderbird/3.1.16
MIME-Version: 1.0
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
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
        Xen <xen-devel@lists.xensource.com>, Avi Kivity <avi@redhat.com>,
        Rik van Riel <riel@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Sasha Levin <levinsasha928@gmail.com>,
        Suzuki Poulose <suzuki@linux.vnet.ibm.com>,
        Dave Hansen <dave@linux.vnet.ibm.com>,
        Jeremy Fitzhardinge <jeremy@goop.org>
Subject: Re: [PATCH RFC V3 4/4] kvm : pv-ticketlocks support for linux guests
 running on KVM hypervisor
References: <20111130085921.23386.89708.sendpatchset@oc5400248562.ibm.com> <20111130090038.23386.4505.sendpatchset@oc5400248562.ibm.com> <20111206032741.GF6647@phenom.dumpdata.com>
In-Reply-To: <20111206032741.GF6647@phenom.dumpdata.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
x-cbid: 11120606-5564-0000-0000-000000630508
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/06/2011 08:57 AM, Konrad Rzeszutek Wilk wrote:
>> +static inline void add_stats(enum kvm_contention_stat var, int val)
>
> You probably want 'int val' to be 'u32 val' as that is the type
> in contention_stats.
>

Yes. Thanks for pointing, as its cumulative.   It is indeed u32 in #else 
:).I 'll change that.

