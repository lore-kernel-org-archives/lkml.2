Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757367Ab0JYQte (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Oct 2010 12:49:34 -0400
Received: from db3ehsobe006.messaging.microsoft.com ([213.199.154.144]:44433
	"EHLO DB3EHSOBE006.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756267Ab0JYQtd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Oct 2010 12:49:33 -0400
X-SpamScore: -24
X-BigFish: VS-24(z21eRe80izbb2cK1432N98dNzz1202hzz8275bh8275dhz2dh2a8h61h)
X-Spam-TCS-SCL: 0:0
Date: Mon, 25 Oct 2010 11:49:24 -0500
From: Scott Wood <scottwood@freescale.com>
To: Avi Kivity <avi@redhat.com>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        KVM list <kvm@vger.kernel.org>, Marcelo Tosatti <mtosatti@redhat.com>
Subject: Re: [GIT PULL] KVM updates for the 2.6.37 merge window
Message-ID: <20101025114924.6c05160c@udp111988uds.am.freescale.net>
In-Reply-To: <4CC434A8.1000903@redhat.com>
References: <4CC434A8.1000903@redhat.com>
X-Mailer: Claws Mail 3.7.4 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 25 Oct 2010 16:49:52.0842 (UTC) FILETIME=[A543B2A0:01CB7464]
X-Reverse-DNS: az33egw01.freescale.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 24 Oct 2010 15:29:12 +0200
Avi Kivity <avi@redhat.com> wrote:

>   Linus, the repository and branch
> 
>    git://git.kernel.org/pub/scm/virt/kvm/kvm.git kvm-updates/2.6.37
> 
> contains the kvm updates for the 2.6.37 merge window.  Major changes 
> this time around include powerpc paravirtualization, a virtual tsc 
> rework, and exposing npt to the guest for fast nested virtualization.  
> Please pull.

How about these patches which are in kvm.git/next but not
kvm-updates/2.6.37?

PPC: KVM: Book E doesn't have __end_interrupts.
KVM: PPC: e500: Call kvm_vcpu_uninit() before kvmppc_e500_tlb_uninit()
KVM: PPC: BookE: fix sleep with interrupts disabled
KVM: PPC: BookE: Load the lower half of MSR

-Scott

