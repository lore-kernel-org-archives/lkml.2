Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753738Ab0CUVzI (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Mar 2010 17:55:08 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:45835 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753534Ab0CUVzF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Mar 2010 17:55:05 -0400
Date: Sun, 21 Mar 2010 22:54:55 +0100
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
Message-ID: <20100321215455.GB13219@elte.hu>
References: <20100318170223.GB9756@elte.hu>
 <4BA25E66.2050800@redhat.com>
 <20100318172805.GB26067@elte.hu>
 <4BA32E1A.2060703@redhat.com>
 <20100319085346.GG12576@elte.hu>
 <4BA47AD0.2010509@redhat.com>
 <20100321190656.GC25922@elte.hu>
 <4BA68009.5010906@redhat.com>
 <20100321205531.GC30194@elte.hu>
 <4BA692C3.7010408@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4BA692C3.7010408@redhat.com>
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

> On 03/21/2010 10:55 PM, Ingo Molnar wrote:
> >
> >Of course you could say the following:
> >
> >   ' Thanks, I'll mark this for v2.6.36 integration. Note that we are not
> >     able to add this to the v2.6.35 kernel queue anymore as the ongoing
> >     usability work already takes up all of the project's maintainer and
> >     testing bandwidth. If you want the feature to be merged sooner than that
> >     then please help us cut down on the TODO and BUGS list that can be found
> >     at XYZ. There's quite a few low hanging fruits there. '
> 
> That would be shooting at my own foot as well as the contributor's since I 
> badly want that RCU stuff, and while a GUI would be nice, that itch isn't on 
> my back.

I think this sums up the root cause of all the problems i see with KVM pretty 
well.

Thanks,

	Ingo
