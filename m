Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751607Ab1GYJ16 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jul 2011 05:27:58 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:56618 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751100Ab1GYJ1x (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jul 2011 05:27:53 -0400
Date: Mon, 25 Jul 2011 11:26:56 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Pekka Enberg <penberg@kernel.org>
Cc: Alexander Graf <agraf@suse.de>, Jan Kiszka <jan.kiszka@web.de>,
        torvalds@linux-foundation.org, avi@redhat.com,
        akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, gorcunov@gmail.com, levinsasha928@gmail.com,
        asias.hejun@gmail.com, prasadjoshi124@gmail.com
Subject: Re: [GIT PULL] Native Linux KVM tool for 3.1
Message-ID: <20110725092656.GD28787@elte.hu>
References: <alpine.DEB.2.00.1107242335580.18045@tiger>
 <4E2CA6DE.4040900@web.de>
 <CAOJsxLEkXpDCiMZZnSXnxQ6-PFBwMEv4j5mLRhPZVMKw=LoPSQ@mail.gmail.com>
 <20110725075305.GA32294@elte.hu>
 <0EAA5203-D598-4CBA-B8D2-AB371A7689A9@suse.de>
 <CAOJsxLHGgpNrHpfnHzD-aOJakE9q_4ym51_AYQHaj+waEZtSuw@mail.gmail.com>
 <ED2ECD82-2B14-45FF-AA61-AB26B377B626@suse.de>
 <CAOJsxLFDzSg55u92b6Qgvqn1yjaShYG_Bgdkzy19aBrzxo7FqA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOJsxLFDzSg55u92b6Qgvqn1yjaShYG_Bgdkzy19aBrzxo7FqA@mail.gmail.com>
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


* Pekka Enberg <penberg@kernel.org> wrote:

> [ I thought the 'native Linux' part in 'native Linux KVM tool' was 
> a dead giveaway, really. ]
> 
> Now if people want to support other operating systems, that's cool 
> and I'm happy to help out where I can. But I don't understand why 
> people keep bringing non-Linux OSs as an argument for not merging 
> tools/kvm into the Linux kernel tree. I mean really, did someone 
> actually expect that a Linux kernel developer spends his weekends 
> improving the state of Windows virtualization?
> 
> And don't get this the wrong way either, I'm not hostile against 
> other operating systems, but I simply am not interested enough in 
> them to spend my time improving them.

In fact one of the problems i see with Qemu is that Qemu had to make 
many compromises to support Windows and other weird platforms that 
i'm (and i'd claim most other Linux kernel developers) are personally 
not interested in.

So here's a 14 KLOC tools/kvm/ that does everything that i need from 
virtualization (easy testing of a bzImage before rebooting the host 
system into it), is clean, readable and hackable and is 1.5% of the 
nearly 1 MLOC Qemu code base.

The whole tools/kvm/ code base is (much) smaller than Qemu's IA64 
support code for example. The size difference is startling. 

tools/kvm/ does less and in my experience does it better - is that 
such a surprising thing?

So it was a no brainer for me to pull it into -tip.

Thanks,

	Ingo
