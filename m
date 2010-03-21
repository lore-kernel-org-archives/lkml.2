Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753539Ab0CUVAY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Mar 2010 17:00:24 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:37316 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753443Ab0CUVAX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Mar 2010 17:00:23 -0400
Date: Sun, 21 Mar 2010 22:00:11 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Avi Kivity <avi@redhat.com>
Cc: Antoine Martin <antoine@nagafix.co.uk>,
       Anthony Liguori <anthony@codemonkey.ws>,
       Pekka Enberg <penberg@cs.helsinki.fi>,
       "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Sheng Yang <sheng@linux.intel.com>, linux-kernel@vger.kernel.org,
       kvm@vger.kernel.org, Marcelo Tosatti <mtosatti@redhat.com>,
       oerg Roedel <joro@8bytes.org>, Jes Sorensen <Jes.Sorensen@redhat.com>,
       Gleb Natapov <gleb@redhat.com>, Zachary Amsden <zamsden@redhat.com>,
       ziteng.huang@intel.com, Arnaldo Carvalho de Melo <acme@redhat.com>,
       Fr?d?ric Weisbecker <fweisbec@gmail.com>
Subject: Re: [RFC] Unify KVM kernel-space and user-space code into a single
 project
Message-ID: <20100321210011.GD30194@elte.hu>
References: <20100318170223.GB9756@elte.hu>
 <4BA25E66.2050800@redhat.com>
 <20100318172805.GB26067@elte.hu>
 <4BA32E1A.2060703@redhat.com>
 <20100319085346.GG12576@elte.hu>
 <4BA3747F.60401@codemonkey.ws>
 <20100321191742.GD25922@elte.hu>
 <4BA674F1.6070603@nagafix.co.uk>
 <20100321195903.GA29490@elte.hu>
 <4BA67D0B.9030705@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4BA67D0B.9030705@redhat.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Avi Kivity <avi@redhat.com> wrote:

> On 03/21/2010 09:59 PM, Ingo Molnar wrote:
> >
> >Frankly, i was surprised (and taken slightly off base) by both Avi and Anthony
> >suggesting such a clearly inferior "add a demon to the guest space" solution.
> >It's a usability and deployment non-starter.
> 
> It's only clearly inferior if you ignore every consideration against it.  
> It's definitely not a deployment non-starter, see the tons of daemons that 
> come with any Linux system. [...]

Avi, please dont put arguments into my mouth that i never made.

My (clearly expressed) argument was that:

    _a new guest-side demon is a transparent instrumentation non-starter_

What is so hard to understand about that simple concept? Instrumentation is 
good if it's as transparent as possible.

Of course lots of other features can be done via a new user-space package ...

Thanks,

	Ingo
