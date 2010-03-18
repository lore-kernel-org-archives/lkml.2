Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753482Ab0CRR2R (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Mar 2010 13:28:17 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:48070 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752745Ab0CRR2P (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Mar 2010 13:28:15 -0400
Date: Thu, 18 Mar 2010 18:28:05 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Avi Kivity <avi@redhat.com>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>,
       Anthony Liguori <anthony@codemonkey.ws>,
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
Message-ID: <20100318172805.GB26067@elte.hu>
References: <4BA21B09.6060706@redhat.com>
 <20100318130047.GA7424@elte.hu>
 <4BA23FE1.5050402@codemonkey.ws>
 <20100318151737.GA2875@elte.hu>
 <4BA250BF.80704@codemonkey.ws>
 <20100318162853.GB447@elte.hu>
 <4BA256FE.5080501@codemonkey.ws>
 <84144f021003180951s5207de16p1cdf4b9b04040222@mail.gmail.com>
 <20100318170223.GB9756@elte.hu>
 <4BA25E66.2050800@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4BA25E66.2050800@redhat.com>
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

> On 03/18/2010 07:02 PM, Ingo Molnar wrote:
> >
> > I find the 'KVM mostly cares about the server, not about the desktop' 
> > attitude expressed in this thread troubling.
> 
> It's not kvm, just it's developers (and their employers, where applicable).  
> If you post desktop oriented patches I'm sure they'll be welcome.

Just such a patch-set was posted in this very thread: 'perf kvm'.

There were two negative reactions immediately, both showed a fundamental 
server versus desktop bias:

 - you did not accept that the most important usecase is when there is a
   single guest running.

 - the reaction to the 'how do we get symbols out of the guest' sub-question 
   was, paraphrased: 'we dont want that due to <unspecified> security threat 
   to XYZ selinux usecase with lots of guests'.

Anyone being aware of how Linux and KVM is being used on the desktop will know 
how detached that attitude is from the typical desktop usecase ...

Usability _never_ sucks because of lack of patches or lack of suggestions. I 
bet if you made the next server feature contingent on essential usability 
fixes they'd happen overnight - for God's sake there's been 1000 commits in 
the last 3 months in the Qemu repository so there's plenty of manpower...

Usability suckage - and i'm not going to be popular for saying this out loud - 
almost always shows a basic maintainer disconnect with the real world. See 
your very first reactions to my 'KVM usability' observations. Read back your 
and Anthony's replies: total 'sure, patches welcome' kind of indifference. It 
is _your project_, not some other project down the road ...

So that is my first-hand experience about how you are welcoming these desktop 
issues, in this very thread. I suspect people try a few times with 
suggestions, then get shot down like our suggestions were shot down and then 
give up.

	Ingo
