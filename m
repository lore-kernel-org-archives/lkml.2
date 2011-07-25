Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752082Ab1GYKsU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jul 2011 06:48:20 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:41821 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751673Ab1GYKsN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jul 2011 06:48:13 -0400
Date: Mon, 25 Jul 2011 12:47:19 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Alexander Graf <agraf@suse.de>
Cc: Pekka Enberg <penberg@kernel.org>, Jan Kiszka <jan.kiszka@web.de>,
        torvalds@linux-foundation.org, avi@redhat.com,
        akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, gorcunov@gmail.com, levinsasha928@gmail.com,
        asias.hejun@gmail.com, prasadjoshi124@gmail.com
Subject: Re: [GIT PULL] Native Linux KVM tool for 3.1
Message-ID: <20110725104719.GM28787@elte.hu>
References: <alpine.DEB.2.00.1107242335580.18045@tiger>
 <4E2CA6DE.4040900@web.de>
 <CAOJsxLEkXpDCiMZZnSXnxQ6-PFBwMEv4j5mLRhPZVMKw=LoPSQ@mail.gmail.com>
 <20110725075305.GA32294@elte.hu>
 <0EAA5203-D598-4CBA-B8D2-AB371A7689A9@suse.de>
 <CAOJsxLHGgpNrHpfnHzD-aOJakE9q_4ym51_AYQHaj+waEZtSuw@mail.gmail.com>
 <ED2ECD82-2B14-45FF-AA61-AB26B377B626@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ED2ECD82-2B14-45FF-AA61-AB26B377B626@suse.de>
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

> > You know, they said the same thing about oprofile. All you needed 
> > to do was to write few simple shell scripts to make it work. One 
> > of the key features of tools/kvm is 'as little configuration as 
> > possible' and I can assure you that bash alias is really not a 
> > solution for that.
> 
> I like perf. Really. But I still don't see why it wouldn't be able 
> to live in its own tree either.

Is the reason that the people who develop it prefer integration with 
the kernel tree not enough for you?

perf could possibly be ported to other OSs. Maybe some day someone 
will try that. But unless that project actually replaces the perf 
project, or perf developers move out of the kernel en masse due to 
difficulties with the development model i don't see why the project 
would want to move out of the kernel tree.

In fact my observations as a perf maintainer show the exact opposite: 
most perf developers are 100% happy to get their stuff merged and 
upstream ASAP. They do not buffer big patch-queues just to not have 
to deal with an integrated kernel tree. The integrated tree is a 
natural model of development to them and often perf tooling patches 
come mixed with kernel side patches such as new tracepoints or 
cleanups/fixes to related kernel code, so it's all very convenient.

Thanks,

	Ingo
