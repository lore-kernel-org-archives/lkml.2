Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755269Ab1KGL7p (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Nov 2011 06:59:45 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:49301 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753311Ab1KGL7o (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Nov 2011 06:59:44 -0500
Date: Mon, 7 Nov 2011 12:57:34 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: Gerd Hoffmann <kraxel@redhat.com>, Pekka Enberg <penberg@kernel.org>,
        Alexander Graf <agraf@suse.de>, Avi Kivity <avi@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "linux-kernel@vger.kernel.org List" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org list" <kvm@vger.kernel.org>,
        qemu-devel Developers <qemu-devel@nongnu.org>,
        =?iso-8859-1?Q?Am=E9rico?= Wang <xiyou.wangcong@gmail.com>,
        Blue Swirl <blauwirbel@gmail.com>
Subject: Re: [PATCH] KVM: Add wrapper script around QEMU to test kernels
Message-ID: <20111107115734.GA30222@elte.hu>
References: <4EB67486.1070105@redhat.com>
 <CAOJsxLE2_ce+SCT25cmS7iFuH3SyJeYRNHjxG5iBPkodTX1AoA@mail.gmail.com>
 <4EB67D17.7000701@redhat.com>
 <CAOJsxLGRDeMg1CWJ+A6zYCb7dZnm1cm7UL0UVipmJJk4GFGtWA@mail.gmail.com>
 <4EB680D9.2070706@redhat.com>
 <CAOJsxLFpNG1iZt8=XU2xH3x9dFCqjM=+i8y4EMPg0Ah47bYfqg@mail.gmail.com>
 <877C82F4-F07C-44AA-8722-3AF57CFC4597@suse.de>
 <CAOJsxLFhB8V94VWbDgM6d_rgcy8XQNEfYBKYG1eh6oUMiQicEA@mail.gmail.com>
 <4EB7B1A9.9000409@redhat.com>
 <alpine.LFD.2.02.1111071333350.2815@tux.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.02.1111071333350.2815@tux.localdomain>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=AWL,BAYES_00 autolearn=no SpamAssassin version=3.3.1
	-2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
	[score: 0.0000]
	0.0 AWL                    AWL: From: address is in the auto white-list
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Pekka Enberg <penberg@cs.helsinki.fi> wrote:

> On Mon, 7 Nov 2011, Gerd Hoffmann wrote:
> >>It's not just about code, it's as much about culture and development process.
> >
> >Indeed.  The BSDs have both kernel and the base system in a single
> >repository.  There are probably good reasons for (and against) it.
> >
> > In Linux we don't have that culture.  No tool (except perf) lives 
> > in the kernel repo.  I fail to see why kvm-tool is that much 
> > different from udev, util-linux, iproute, filesystem tools, that 
> > it should be included.
> 
> You seem to think perf is an exception - I think it's going to be 
> the future norm for userspace components that are very close to the 
> kernel. That's in fact what Ingo was arguing for when he suggested 
> QEMU to be merged to the kernel tree.

Yep, and the answer i got from the Qemu folks when i suggested that 
merge was a polite "buzz off", along the lines of: "We don't want to 
do that, but feel free to write your own tool, leave Qemu alone."

Now that people have done exactly that some Qemu folks not only have 
changed their objection from "write your own tool" to "erm, write 
your own tool but do it the way *we* prefer you to do it" - they also 
started contributing *against* the KVM tool with predictable, once 
every 3 months objections against its upstream merge...

That's not very nice and not very constructive.

The only valid technical objection against tools/kvm/ that i can see 
would be that it's not useful enough yet for the upstream kernel 
versus other tools such as Qemu. In all fairness i think we might 
still be at that early stage of the project but it's clearly 
progressing very rapidly and i'm already using it on a daily basis 
for my own kernel testing purposes. During the Kernel Summit that's 
how i tested contemporary kernels on contemporary user-space 
remotely, without having to risk a physical reboot.

Thanks,

	Ingo
