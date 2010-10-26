Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759996Ab0JZPzl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Oct 2010 11:55:41 -0400
Received: from cantor2.suse.de ([195.135.220.15]:45915 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753774Ab0JZPzk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Oct 2010 11:55:40 -0400
Subject: Re: [GIT PULL] KVM updates for the 2.6.37 merge window
Mime-Version: 1.0 (Apple Message framework v1081)
Content-Type: text/plain; charset=us-ascii
From: Alexander Graf <agraf@suse.de>
In-Reply-To: <4CC5B764.5030007@redhat.com>
Date: Tue, 26 Oct 2010 08:55:34 -0700
Cc: Scott Wood <scottwood@freescale.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        KVM list <kvm@vger.kernel.org>, Marcelo Tosatti <mtosatti@redhat.com>
Content-Transfer-Encoding: 8BIT
Message-Id: <AAAC8548-D406-4CAC-8579-D2B5AAB6AC2C@suse.de>
References: <4CC434A8.1000903@redhat.com> <20101025114924.6c05160c@udp111988uds.am.freescale.net> <4CC5B764.5030007@redhat.com>
To: Avi Kivity <avi@redhat.com>
X-Mailer: Apple Mail (2.1081)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On 25.10.2010, at 09:59, Avi Kivity wrote:

> On 10/25/2010 06:49 PM, Scott Wood wrote:
>> On Sun, 24 Oct 2010 15:29:12 +0200
>> Avi Kivity<avi@redhat.com>  wrote:
>> 
>> >    Linus, the repository and branch
>> >
>> >     git://git.kernel.org/pub/scm/virt/kvm/kvm.git kvm-updates/2.6.37
>> >
>> >  contains the kvm updates for the 2.6.37 merge window.  Major changes
>> >  this time around include powerpc paravirtualization, a virtual tsc
>> >  rework, and exposing npt to the guest for fast nested virtualization.
>> >  Please pull.
>> 
>> How about these patches which are in kvm.git/next but not
>> kvm-updates/2.6.37?
>> 
>> PPC: KVM: Book E doesn't have __end_interrupts.
>> KVM: PPC: e500: Call kvm_vcpu_uninit() before kvmppc_e500_tlb_uninit()
>> KVM: PPC: BookE: fix sleep with interrupts disabled
>> KVM: PPC: BookE: Load the lower half of MSR
>> 
> 
> Alex, if you want them in, please prepare backports for 2.6.36.1.

Why backports for 2.6.36.1 when we're talking about 2.6.27? Most of them fix bugs introduced by the PV framework.


Alex

