Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751453Ab1GYJAP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jul 2011 05:00:15 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:46223 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750886Ab1GYJAL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jul 2011 05:00:11 -0400
Date: Mon, 25 Jul 2011 10:59:15 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Alexander Graf <agraf@suse.de>
Cc: Pekka Enberg <penberg@kernel.org>, Jan Kiszka <jan.kiszka@web.de>,
        torvalds@linux-foundation.org, avi@redhat.com,
        akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, gorcunov@gmail.com, levinsasha928@gmail.com,
        asias.hejun@gmail.com, prasadjoshi124@gmail.com
Subject: Re: [GIT PULL] Native Linux KVM tool for 3.1
Message-ID: <20110725085915.GA21464@elte.hu>
References: <alpine.DEB.2.00.1107242335580.18045@tiger>
 <4E2CA6DE.4040900@web.de>
 <CAOJsxLEkXpDCiMZZnSXnxQ6-PFBwMEv4j5mLRhPZVMKw=LoPSQ@mail.gmail.com>
 <20110725075305.GA32294@elte.hu>
 <0EAA5203-D598-4CBA-B8D2-AB371A7689A9@suse.de>
 <20110725085426.GA28787@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110725085426.GA28787@elte.hu>
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


* Ingo Molnar <mingo@elte.hu> wrote:

> Virtualization is very tightly bound to the kernel, like it or not. 
> So is profiling, power management and a few other things.
> 
> And when you do 'ls tools/' you'll see exactly those topics 
> populated:
> 
>  earth5:~/tip> ls tools/
>  firewire  kvm  perf  power  slub  testing  usb  virtio
> 
> [ In fact tools/virtio/ was merged upstream yesterday and putting 
>   that code there was a good call IMO. ]

Correction: tools/virtio/ was merged much earlier than that - in 
v2.6.37.

Still the point remains: you cannot ridicule us moving user-space 
code to tools/ while virtio itself is moving code there ...

Thanks,

	Ingo
