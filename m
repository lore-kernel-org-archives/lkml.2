Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751536Ab2GCI1o (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jul 2012 04:27:44 -0400
Received: from e23smtp04.au.ibm.com ([202.81.31.146]:44484 "EHLO
	e23smtp04.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750941Ab2GCI1m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jul 2012 04:27:42 -0400
From: Nikunj A Dadhania <nikunj@linux.vnet.ibm.com>
To: Marcelo Tosatti <mtosatti@redhat.com>
Cc: peterz@infradead.org, mingo@elte.hu, avi@redhat.com,
        raghukt@linux.vnet.ibm.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, x86@kernel.org, jeremy@goop.org,
        vatsa@linux.vnet.ibm.com, hpa@zytor.com
Subject: Re: [PATCH v2 3/7] KVM: Add paravirt kvm_flush_tlb_others
In-Reply-To: <20120703081135.GB12579@amt.cnet>
References: <20120604050223.4560.2874.stgit@abhimanyu.in.ibm.com> <20120604050629.4560.85284.stgit@abhimanyu.in.ibm.com> <20120703081135.GB12579@amt.cnet>
User-Agent: Notmuch/0.10.2+70~gf0e0053 (http://notmuchmail.org) Emacs/24.0.95.1 (x86_64-unknown-linux-gnu)
Date: Tue, 03 Jul 2012 13:57:04 +0530
Message-ID: <87obnxckrr.fsf@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain
x-cbid: 12070222-9264-0000-0000-000001D3EE69
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 3 Jul 2012 05:11:35 -0300, Marcelo Tosatti <mtosatti@redhat.com> wrote:
> On Mon, Jun 04, 2012 at 10:37:24AM +0530, Nikunj A. Dadhania wrote:

> >  arch/x86/include/asm/kvm_para.h |    3 +-
> >  arch/x86/include/asm/tlbflush.h |    9 ++++++
> >  arch/x86/kernel/kvm.c           |    1 +
> >  arch/x86/kvm/x86.c              |   14 ++++++++-
> >  arch/x86/mm/tlb.c               |   61 +++++++++++++++++++++++++++++++++++++++
> >  5 files changed, 86 insertions(+), 2 deletions(-)
> > 

[...]

> > diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> > index 264f172..4714a7b 100644
> > --- a/arch/x86/kvm/x86.c
> > +++ b/arch/x86/kvm/x86.c
> 
> Please split guest/host (arch/x86/kernel/kvm.c etc VS arch/x86/kvm/)
> patches.
> 
Ok

> Please document guest/host interface
> (Documentation/virtual/kvm/paravirt-tlb-flush.txt, add a pointer to it
> from msr.txt).
> 
Sure.

