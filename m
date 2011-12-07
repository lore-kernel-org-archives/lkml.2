Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754919Ab1LGKzF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Dec 2011 05:55:05 -0500
Received: from mx1.redhat.com ([209.132.183.28]:11034 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752436Ab1LGKzD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Dec 2011 05:55:03 -0500
Message-ID: <4EDF45C2.9060108@redhat.com>
Date: Wed, 07 Dec 2011 12:53:54 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:8.0) Gecko/20111115 Thunderbird/8.0
MIME-Version: 1.0
To: Konrad Rzeszutek Wilk <konrad@darnok.org>
CC: Raghavendra K T <raghukt@linux.vnet.ibm.com>,
        Jeremy Fitzhardinge <jeremy@goop.org>, x86@kernel.org,
        Gleb Natapov <gleb@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
        Virtualization <virtualization@lists.linux-foundation.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
        Xen <xen-devel@lists.xensource.com>, Dave Jiang <dave.jiang@intel.com>,
        KVM <kvm@vger.kernel.org>,
        Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@redhat.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>,
        Sasha Levin <levinsasha928@gmail.com>,
        Sedat Dilek <sedat.dilek@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>, Yinghai Lu <yinghai@kernel.org>,
        Greg Kroah-Hartman <gregkh@suse.de>,
        LKML <linux-kernel@vger.kernel.org>,
        Dave Hansen <dave@linux.vnet.ibm.com>,
        Suzuki Poulose <suzuki@linux.vnet.ibm.com>
Subject: Re: [Xen-devel] [PATCH RFC V3 2/4] kvm hypervisor : Add a hypercall
 to KVM hypervisor to support pv-ticketlocks
References: <20111130085921.23386.89708.sendpatchset@oc5400248562.ibm.com> <20111130085959.23386.69166.sendpatchset@oc5400248562.ibm.com> <4ED760F1.6080804@redhat.com> <4ED7DA85.5080504@linux.vnet.ibm.com> <4EDBB6C2.9050303@linux.vnet.ibm.com> <20111206164947.GA13184@andromeda.dapyr.net>
In-Reply-To: <20111206164947.GA13184@andromeda.dapyr.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/06/2011 06:49 PM, Konrad Rzeszutek Wilk wrote:
> On Sun, Dec 04, 2011 at 11:36:58PM +0530, Raghavendra K T wrote:
> > On 12/02/2011 01:20 AM, Raghavendra K T wrote:
> > >>Have you tested it on AMD machines? There are some differences in the
> > >>hypercall infrastructure there.
> > >
> > >Yes. 'll test on AMD machine and update on that.
> > >
> > 
> > I tested the code on 64 bit Dual-Core AMD Opteron machine, and it is 
> > working.
>
> I am not that familiar with how KVM does migration, but do you need any
> special flags in QEMU to when migrating a KVM-pv-spinlock enabled guest
> to another machine?

I don't think so.  Sleeping is an ordinary HLT state which we already
migrate.  There are no further states.

-- 
error compiling committee.c: too many arguments to function

