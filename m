Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751802Ab1GYKRB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jul 2011 06:17:01 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:35018 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751074Ab1GYKQ4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jul 2011 06:16:56 -0400
Date: Mon, 25 Jul 2011 12:16:07 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Alexander Graf <agraf@suse.de>
Cc: Pekka Enberg <penberg@kernel.org>, Jan Kiszka <jan.kiszka@web.de>,
        torvalds@linux-foundation.org, avi@redhat.com,
        akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, gorcunov@gmail.com, levinsasha928@gmail.com,
        asias.hejun@gmail.com, prasadjoshi124@gmail.com
Subject: Re: [GIT PULL] Native Linux KVM tool for 3.1
Message-ID: <20110725101607.GI28787@elte.hu>
References: <alpine.DEB.2.00.1107242335580.18045@tiger>
 <4E2CA6DE.4040900@web.de>
 <CAOJsxLEkXpDCiMZZnSXnxQ6-PFBwMEv4j5mLRhPZVMKw=LoPSQ@mail.gmail.com>
 <20110725075305.GA32294@elte.hu>
 <0EAA5203-D598-4CBA-B8D2-AB371A7689A9@suse.de>
 <CAOJsxLHGgpNrHpfnHzD-aOJakE9q_4ym51_AYQHaj+waEZtSuw@mail.gmail.com>
 <ED2ECD82-2B14-45FF-AA61-AB26B377B626@suse.de>
 <CAOJsxLFDzSg55u92b6Qgvqn1yjaShYG_Bgdkzy19aBrzxo7FqA@mail.gmail.com>
 <20110725092656.GD28787@elte.hu>
 <68C2AB77-AA91-4B21-A321-2DB4EF8121C1@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <68C2AB77-AA91-4B21-A321-2DB4EF8121C1@suse.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.3.1
	-2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Alexander Graf <agraf@suse.de> wrote:

> > In fact one of the problems i see with Qemu is that Qemu had to 
> > make many compromises to support Windows and other weird 
> > platforms that i'm (and i'd claim most other Linux kernel 
> > developers) are personally not interested in.
> 
> It's what makes it so powerful. [...]

To me and Pekka that is what made Qemu unhackable.

Really, i'm not sure why you are arguing here. We are not trying to 
merge tools/qemu/ upstream. We are trying to merge a Linux-only 
utility that lives in the kernel tree today and which we are actively 
using and developing.

> [...] Adding a new architecture for KVM for example is as easy as 
> only implementing the CPU. All device emulation is already there. 
> If you want something Linux only, lguest would've been enough, no?

That's a rather bizarre argument, we were pretty happy with the 
design of the KVM host side, what we wanted to improve was user-space 
tooling.

With lguest we'd have to write a new host implementation in essence 
...

> > [...]
> >
> > tools/kvm/ does less and in my experience does it better - is 
> > that such a surprising thing?
>
> [...] 
> 
> > So it was a no brainer for me to pull it into -tip.
> 
> The thing I don't agree with is that it should live in the kernel 
> tree.

FYI, tools/kvm/ *already* lives in the kernel tree - that is how it's 
developed and used and it also shares code with the kernel.

Thanks,

	Ingo
