Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758026Ab0JYRAA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Oct 2010 13:00:00 -0400
Received: from mx1.redhat.com ([209.132.183.28]:27954 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757967Ab0JYQ75 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Oct 2010 12:59:57 -0400
Message-ID: <4CC5B764.5030007@redhat.com>
Date: Mon, 25 Oct 2010 18:59:16 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.9) Gecko/20100921 Fedora/3.1.4-1.fc13 Lightning/1.0b3pre Thunderbird/3.1.4
MIME-Version: 1.0
To: Scott Wood <scottwood@freescale.com>, Alexander Graf <agraf@suse.de>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        KVM list <kvm@vger.kernel.org>, Marcelo Tosatti <mtosatti@redhat.com>
Subject: Re: [GIT PULL] KVM updates for the 2.6.37 merge window
References: <4CC434A8.1000903@redhat.com> <20101025114924.6c05160c@udp111988uds.am.freescale.net>
In-Reply-To: <20101025114924.6c05160c@udp111988uds.am.freescale.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  On 10/25/2010 06:49 PM, Scott Wood wrote:
> On Sun, 24 Oct 2010 15:29:12 +0200
> Avi Kivity<avi@redhat.com>  wrote:
>
> >    Linus, the repository and branch
> >
> >     git://git.kernel.org/pub/scm/virt/kvm/kvm.git kvm-updates/2.6.37
> >
> >  contains the kvm updates for the 2.6.37 merge window.  Major changes
> >  this time around include powerpc paravirtualization, a virtual tsc
> >  rework, and exposing npt to the guest for fast nested virtualization.
> >  Please pull.
>
> How about these patches which are in kvm.git/next but not
> kvm-updates/2.6.37?
>
> PPC: KVM: Book E doesn't have __end_interrupts.
> KVM: PPC: e500: Call kvm_vcpu_uninit() before kvmppc_e500_tlb_uninit()
> KVM: PPC: BookE: fix sleep with interrupts disabled
> KVM: PPC: BookE: Load the lower half of MSR
>

Alex, if you want them in, please prepare backports for 2.6.36.1.

-- 
error compiling committee.c: too many arguments to function

