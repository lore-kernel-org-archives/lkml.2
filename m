Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755489Ab1DFJqc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Apr 2011 05:46:32 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:54729 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755376Ab1DFJqa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Apr 2011 05:46:30 -0400
Date: Wed, 6 Apr 2011 11:46:12 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Gleb Natapov <gleb@redhat.com>
Cc: Avi Kivity <avi@redhat.com>, Anthony Liguori <anthony@codemonkey.ws>,
        Pekka Enberg <penberg@kernel.org>, linux-kernel@vger.kernel.org,
        aarcange@redhat.com, mtosatti@redhat.com, kvm@vger.kernel.org,
        joro@8bytes.org, penberg@cs.helsinki.fi, asias.hejun@gmail.com,
        gorcunov@gmail.com
Subject: Re: [ANNOUNCE] Native Linux KVM tool
Message-ID: <20110406094612.GA19943@elte.hu>
References: <1301592656.586.15.camel@jaguar>
 <4D982E89.8070502@redhat.com>
 <BANLkTinbCAUqaKfmKaj-7GXTh9F2if0x+Q@mail.gmail.com>
 <4D9847BC.9060906@redhat.com>
 <4D98716D.9040307@codemonkey.ws>
 <4D9873CD.3080207@redhat.com>
 <20110406093333.GB6465@elte.hu>
 <20110406093635.GE25626@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110406093635.GE25626@redhat.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
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


* Gleb Natapov <gleb@redhat.com> wrote:

> On Wed, Apr 06, 2011 at 11:33:33AM +0200, Ingo Molnar wrote:
>
> > So no, your kind of cynical, defeatist sentiment about code quality is by 
> > no means true in my experience. Projects become ugly gooballs once 
> > maintainers stop caring enough.
>
> In case of Qemu it was other way around. Maintainers started caring too late.

Nah, i do not think it's ever too late to care.

Example: arch/i386 - arch/x86_64/ was very messy for many, many years and we 
turned it around and can be proud of arch/x86/ today - but i guess i'm somewhat 
biased there ;-)

In my experience it's entirely possible to turn a messy gooball into something 
you can be proud of - it's all reversible. Start small, with the core bits you 
care about most - then extend those concepts to other areas of the code base, 
gradually. There might be subsystems that will never turn around before 
becoming obsolete - that's not a big problem.

Thanks,

	Ingo
