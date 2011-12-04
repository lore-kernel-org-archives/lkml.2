Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754939Ab1LDSHc (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Dec 2011 13:07:32 -0500
Received: from e23smtp06.au.ibm.com ([202.81.31.148]:55637 "EHLO
	e23smtp06.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754698Ab1LDSHa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Dec 2011 13:07:30 -0500
Message-ID: <4EDBB6C2.9050303@linux.vnet.ibm.com>
Date: Sun, 04 Dec 2011 23:36:58 +0530
From: Raghavendra K T <raghukt@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.24) Gecko/20111108 Fedora/3.1.16-1.fc14 Thunderbird/3.1.16
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>
CC: Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>,
        Greg Kroah-Hartman <gregkh@suse.de>, KVM <kvm@vger.kernel.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Sedat Dilek <sedat.dilek@gmail.com>,
        Virtualization <virtualization@lists.linux-foundation.org>,
        Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>, Dave Jiang <dave.jiang@intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
        Gleb Natapov <gleb@redhat.com>, Yinghai Lu <yinghai@kernel.org>,
        Marcelo Tosatti <mtosatti@redhat.com>, Ingo Molnar <mingo@redhat.com>,
        Rik van Riel <riel@redhat.com>, Xen <xen-devel@lists.xensource.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Sasha Levin <levinsasha928@gmail.com>,
        Suzuki Poulose <suzuki@linux.vnet.ibm.com>,
        Dave Hansen <dave@linux.vnet.ibm.com>,
        Jeremy Fitzhardinge <jeremy@goop.org>
Subject: Re: [PATCH RFC V3 2/4] kvm hypervisor : Add a hypercall to KVM hypervisor
 to support pv-ticketlocks
References: <20111130085921.23386.89708.sendpatchset@oc5400248562.ibm.com> <20111130085959.23386.69166.sendpatchset@oc5400248562.ibm.com> <4ED760F1.6080804@redhat.com> <4ED7DA85.5080504@linux.vnet.ibm.com>
In-Reply-To: <4ED7DA85.5080504@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
x-cbid: 11120408-7014-0000-0000-0000003499CD
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/02/2011 01:20 AM, Raghavendra K T wrote:
>> Have you tested it on AMD machines? There are some differences in the
>> hypercall infrastructure there.
>
> Yes. 'll test on AMD machine and update on that.
>

I tested the code on 64 bit Dual-Core AMD Opteron machine, and it is 
working.

- Raghu

