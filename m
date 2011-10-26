Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932680Ab1JZKfC (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Oct 2011 06:35:02 -0400
Received: from mx1.redhat.com ([209.132.183.28]:22149 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932490Ab1JZKfA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Oct 2011 06:35:00 -0400
Message-ID: <4EA7E21B.8020805@redhat.com>
Date: Wed, 26 Oct 2011 12:34:03 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:7.0.1) Gecko/20110930 Thunderbird/7.0.1
MIME-Version: 1.0
To: Raghavendra K T <raghukt@linux.vnet.ibm.com>
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
        Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH RFC V2 3/5] kvm hypervisor : Add two hypercalls to support
 pv-ticketlock
References: <20111023190307.16364.35381.sendpatchset@oc5400248562.ibm.com> <20111023190558.16364.2136.sendpatchset@oc5400248562.ibm.com> <4EA53A7D.300@redhat.com> <20111024122734.GA10634@linux.vnet.ibm.com> <4EA56385.9040302@redhat.com> <20111024135032.GB10634@linux.vnet.ibm.com> <4EA6FEC2.1060209@linux.vnet.ibm.com>
In-Reply-To: <4EA6FEC2.1060209@linux.vnet.ibm.com>
X-Enigmail-Version: 1.3.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/25/2011 08:24 PM, Raghavendra K T wrote:
>
> So then do also you foresee the need for directed yield at some point,
> to address LHP? provided we have good improvements to prove.

Doesn't this patchset completely eliminate lock holder preemption?

-- 
I have a truly marvellous patch that fixes the bug which this
signature is too narrow to contain.

