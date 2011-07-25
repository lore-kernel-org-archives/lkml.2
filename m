Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751936Ab1GYK2z (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jul 2011 06:28:55 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:42437 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751254Ab1GYK2u (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jul 2011 06:28:50 -0400
Date: Mon, 25 Jul 2011 12:28:02 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Alexander Graf <agraf@suse.de>
Cc: Pekka Enberg <penberg@kernel.org>, Jan Kiszka <jan.kiszka@web.de>,
        torvalds@linux-foundation.org, avi@redhat.com,
        akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, gorcunov@gmail.com, levinsasha928@gmail.com,
        asias.hejun@gmail.com, prasadjoshi124@gmail.com
Subject: Re: [GIT PULL] Native Linux KVM tool for 3.1
Message-ID: <20110725102802.GJ28787@elte.hu>
References: <alpine.DEB.2.00.1107242335580.18045@tiger>
 <4E2CA6DE.4040900@web.de>
 <CAOJsxLEkXpDCiMZZnSXnxQ6-PFBwMEv4j5mLRhPZVMKw=LoPSQ@mail.gmail.com>
 <20110725075305.GA32294@elte.hu>
 <0EAA5203-D598-4CBA-B8D2-AB371A7689A9@suse.de>
 <20110725085426.GA28787@elte.hu>
 <C80CB058-38B3-4EA4-996F-4585F521415C@suse.de>
 <20110725094136.GE28787@elte.hu>
 <AB20F4B6-2A48-4245-9652-E1AE33C7DD29@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AB20F4B6-2A48-4245-9652-E1AE33C7DD29@suse.de>
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

> On 25.07.2011, at 11:41, Ingo Molnar wrote:
> 
> >>> Virtualization is very tightly bound to the kernel, like it or 
> >>> not. So is profiling, power management and a few other things.
> > 
> > It's a very simple point and observation: tools which integrate 
> > to the kernel so that they wouldnt even run on another kernel 
> > obviously are very natural to develop in tools/.
> 
> Ah, very good. So all we need to do to prove the point that 
> kvm-tool doesn't belong in tools/ is port KVM to another OS and 
> make kvm-tool compile there too? Shouldn't be too hard. People 
> already have working ports of (old) KVM versions on FreeBSD and 
> Windows.

Firstly, tools/kvm/ itself only works on Linux and it's developed in 
the kernel repo and we see many benefits of that model and are happy 
with it.

Secondly, even your argument is rather inconsistent: by your argument 
what keeps KVM itself within the Linux kernel, if it's so portable to 
FreeBSD and Windows? By your argument all the virtio drivers should 
be moved out of the Linux kernel tree, to support both the FreeBSD, 
Windows and Linux KVM implementations. By your argument the arch/x86/ 
KVM disassembler should move out of the kernel tree, etc. etc.

You cannot have it both ways really.

So yes, i disagree with you rigid views about this, in reality what 
matters is the quality of the end result and the preferences of the 
developers. Just like i cannot (and should not) force you to develop 
in tools/qemu/, should you not try to force me to not develop in 
tools/kvm/.

Thanks,

	Ingo
