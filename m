Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751634Ab1JZTIE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Oct 2011 15:08:04 -0400
Received: from e23smtp01.au.ibm.com ([202.81.31.143]:33739 "EHLO
	e23smtp01.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750843Ab1JZTIC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Oct 2011 15:08:02 -0400
Message-ID: <4EA85A9D.5060203@linux.vnet.ibm.com>
Date: Thu, 27 Oct 2011 00:38:13 +0530
From: Raghavendra K T <raghukt@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.23) Gecko/20110928 Fedora/3.1.15-1.fc14 Thunderbird/3.1.15
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>
CC: Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
        Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>,
        Greg Kroah-Hartman <gregkh@suse.de>, "H. Peter Anvin" <hpa@zytor.com>,
        Gleb Natapov <gleb@redhat.com>,
        Virtualization <virtualization@lists.linux-foundation.org>,
        Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>, x86@kernel.org,
        KVM <kvm@vger.kernel.org>, Dave Jiang <dave.jiang@intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
        Xen <xen-devel@lists.xensource.com>,
        Sedat Dilek <sedat.dilek@gmail.com>, Yinghai Lu <yinghai@kernel.org>,
        Marcelo Tosatti <mtosatti@redhat.com>, Ingo Molnar <mingo@redhat.com>,
        Rik van Riel <riel@redhat.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Suzuki Poulose <suzuki@linux.vnet.ibm.com>,
        Peter Zijlstra <peterz@infradead.org>, Ryan Harper <ryanh@us.ibm.com>
Subject: Re: [PATCH RFC V2 3/5] kvm hypervisor : Add two hypercalls to support
 pv-ticketlock
References: <20111023190307.16364.35381.sendpatchset@oc5400248562.ibm.com> <20111023190558.16364.2136.sendpatchset@oc5400248562.ibm.com> <4EA53A7D.300@redhat.com> <20111024122734.GA10634@linux.vnet.ibm.com> <4EA56385.9040302@redhat.com> <20111024135032.GB10634@linux.vnet.ibm.com> <4EA6FEC2.1060209@linux.vnet.ibm.com> <4EA7E21B.8020805@redhat.com>
In-Reply-To: <4EA7E21B.8020805@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/26/2011 04:04 PM, Avi Kivity wrote:
> On 10/25/2011 08:24 PM, Raghavendra K T wrote:
CCing Ryan also
>>
>> So then do also you foresee the need for directed yield at some point,
>> to address LHP? provided we have good improvements to prove.
>
> Doesn't this patchset completely eliminate lock holder preemption?
>
Basically I was curious whether we can do more better with your directed 
yield discussions in https://lkml.org/lkml/2010/8/2/106 .

I felt we can get little more improvement with doing directed yield to
lock-holder in case of LHP than sleeping. But I may be wrong.

So wanted to get the feedback, on whether I am thinking in right
direction.



