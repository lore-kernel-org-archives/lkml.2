Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756106Ab0CVTtw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Mar 2010 15:49:52 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:57695 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755520Ab0CVTtv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Mar 2010 15:49:51 -0400
Date: Mon, 22 Mar 2010 20:49:36 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Joerg Roedel <joro@8bytes.org>
Cc: Avi Kivity <avi@redhat.com>, Anthony Liguori <anthony@codemonkey.ws>,
       Pekka Enberg <penberg@cs.helsinki.fi>,
       "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Sheng Yang <sheng@linux.intel.com>, linux-kernel@vger.kernel.org,
       kvm@vger.kernel.org, Marcelo Tosatti <mtosatti@redhat.com>,
       Jes Sorensen <Jes.Sorensen@redhat.com>, Gleb Natapov <gleb@redhat.com>,
       Zachary Amsden <zamsden@redhat.com>, ziteng.huang@intel.com,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Fr?d?ric Weisbecker <fweisbec@gmail.com>
Subject: Re: [RFC] Unify KVM kernel-space and user-space code into a single
 project
Message-ID: <20100322194936.GB3306@elte.hu>
References: <20100319085346.GG12576@elte.hu>
 <4BA3747F.60401@codemonkey.ws>
 <20100321191742.GD25922@elte.hu>
 <4BA67B2F.4030101@redhat.com>
 <20100321203121.GA30194@elte.hu>
 <20100322111040.GL13108@8bytes.org>
 <20100322122228.GH3483@elte.hu>
 <20100322134633.GD1940@8bytes.org>
 <20100322163215.GC18796@elte.hu>
 <20100322192059.GG1940@8bytes.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100322192059.GG1940@8bytes.org>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: 0.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=0.0 required=5.9 tests=none autolearn=no SpamAssassin version=3.2.5
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Joerg Roedel <joro@8bytes.org> wrote:

> On Mon, Mar 22, 2010 at 05:32:15PM +0100, Ingo Molnar wrote:
> > I dont know how you can find the situation of Alpha comparable, which is a 
> > legacy architecture for which no new CPU was manufactored in the past ~10 
> > years.
> > 
> > The negative effects of physical obscolescence cannot be overcome even by the 
> > very best of development models ...
> 
> The maintainers of that architecture could at least continue to maintain it. 
> But that is not the case. Most newer syscalls are not available and overall 
> stability on alpha sucks (kernel crashed when I tried to start Xorg for 
> example) but nobody cares about it. Hardware is still around and there are 
> still some users of it.

You are arguing why maintainers do not act as you suggest, against the huge 
negative effects of physical obscolescence?

Please use common sense: they dont act because ... there are huge negative 
effects due to physical obscolescence?

No amount of development model engineering can offset that negative.

Thanks,

	Ingo
