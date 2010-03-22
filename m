Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756113Ab0CVTyT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Mar 2010 15:54:19 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:45708 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755966Ab0CVTyR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Mar 2010 15:54:17 -0400
Date: Mon, 22 Mar 2010 20:54:03 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Alexander Graf <agraf@suse.de>
Cc: "Daniel P. Berrange" <berrange@redhat.com>,
       Anthony Liguori <anthony@codemonkey.ws>, Avi Kivity <avi@redhat.com>,
       Pekka Enberg <penberg@cs.helsinki.fi>,
       "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Sheng Yang <sheng@linux.intel.com>, linux-kernel@vger.kernel.org,
       kvm@vger.kernel.org, Marcelo Tosatti <mtosatti@redhat.com>,
       oerg Roedel <joro@8bytes.org>, Jes Sorensen <Jes.Sorensen@redhat.com>,
       Gleb Natapov <gleb@redhat.com>, Zachary Amsden <zamsden@redhat.com>,
       ziteng.huang@intel.com, Arnaldo Carvalho de Melo <acme@redhat.com>,
       Fr?d?ric Weisbecker <fweisbec@gmail.com>,
       Gregory Haskins <ghaskins@novell.com>
Subject: Re: [RFC] Unify KVM kernel-space and user-space code into a single
 project
Message-ID: <20100322195403.GC3306@elte.hu>
References: <4BA7821C.7090900@codemonkey.ws>
 <20100322155505.GA18796@elte.hu>
 <4BA796DF.7090005@redhat.com>
 <20100322165107.GD18796@elte.hu>
 <4BA7A406.9050203@redhat.com>
 <20100322173400.GB15795@elte.hu>
 <4BA7AF2D.7060306@redhat.com>
 <4BA7C1D7.5070208@codemonkey.ws>
 <20100322193100.GB28709@redhat.com>
 <E548536E-4D62-4B17-BA09-9C12EB1A2717@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E548536E-4D62-4B17-BA09-9C12EB1A2717@suse.de>
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


* Alexander Graf <agraf@suse.de> wrote:

> Yes. I think the point was that every layer in between brings potential 
> slowdown and loss of features.

Exactly. The more 'fragmented' a project is into sub-projects, without a 
single, unified, functional reference implementation in the center of it, the 
longer it takes to fix 'unsexy' problems like trivial usability bugs.

Furthermore, another negative effect is that many times features are 
implemented not in their technically best way, but in a way to keep them local 
to the project that originates them. This is done to keep deployment latencies 
and general contribution overhead down to a minimum. The moment you have to 
work with yet another project, the overhead adds up.

So developers rather go for the quicker (yet inferior) hack within the 
sub-project they have best access to.

Tell me this isnt happening in this space ;-)

Thanks,

	Ingo
