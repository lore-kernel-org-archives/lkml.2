Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932273Ab2EGUnB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 May 2012 16:43:01 -0400
Received: from www.linutronix.de ([62.245.132.108]:42098 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932090Ab2EGUm7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 May 2012 16:42:59 -0400
Date: Mon, 7 May 2012 22:42:30 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Ingo Molnar <mingo@kernel.org>
cc: Avi Kivity <avi@redhat.com>,
        Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>,
        Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jeremy Fitzhardinge <jeremy@goop.org>,
        Greg Kroah-Hartman <gregkh@suse.de>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Marcelo Tosatti <mtosatti@redhat.com>, X86 <x86@kernel.org>,
        Gleb Natapov <gleb@redhat.com>, Ingo Molnar <mingo@redhat.com>,
        Attilio Rao <attilio.rao@citrix.com>,
        Virtualization <virtualization@lists.linux-foundation.org>,
        Xen Devel <xen-devel@lists.xensource.com>, linux-doc@vger.kernel.org,
        KVM <kvm@vger.kernel.org>, Andi Kleen <andi@firstfloor.org>,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
        Stephan Diestelhorst <stephan.diestelhorst@amd.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [PATCH RFC V8 0/17] Paravirtualized ticket spinlocks
In-Reply-To: <20120507172527.GA5357@gmail.com>
Message-ID: <alpine.LFD.2.02.1205072240020.6271@ionos>
References: <4FA7BABA.4040700@redhat.com> <4FA7CC05.50808@linux.vnet.ibm.com> <4FA7CCA2.4030408@redhat.com> <4FA7D06B.60005@linux.vnet.ibm.com> <20120507134611.GB5533@linux.vnet.ibm.com> <4FA7D2E5.1020607@redhat.com> <4FA7D3F7.9080005@linux.vnet.ibm.com>
 <4FA7D50D.1020209@redhat.com> <4FA7E06E.20304@linux.vnet.ibm.com> <4FA7E1C8.7010509@redhat.com> <20120507172527.GA5357@gmail.com>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 7 May 2012, Ingo Molnar wrote:
> * Avi Kivity <avi@redhat.com> wrote:
> 
> > > PS: Nikunj had experimented that pv-flush tlb + 
> > > paravirt-spinlock is a win on PLE where only one of them 
> > > alone could not prove the benefit.
> > 
> > I'd like to see those numbers, then.
> > 
> > Ingo, please hold on the kvm-specific patches, meanwhile.
> 
> I'll hold off on the whole thing - frankly, we don't want this 
> kind of Xen-only complexity. If KVM can make use of PLE then Xen 
> ought to be able to do it as well.
> 
> If both Xen and KVM makes good use of it then that's a different 
> matter.

Aside of that, it's kinda strange that a dude named "Nikunj" is
referenced in the argument chain, but I can't find him on the CC list.

Thanks,

	tglx
