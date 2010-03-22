Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755528Ab0CVRno (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Mar 2010 13:43:44 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:34911 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755513Ab0CVRnm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Mar 2010 13:43:42 -0400
Date: Mon, 22 Mar 2010 18:43:28 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: "Frank Ch. Eigler" <fche@redhat.com>, Joerg Roedel <joro@8bytes.org>,
       Avi Kivity <avi@redhat.com>, Anthony Liguori <anthony@codemonkey.ws>,
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
Message-ID: <20100322174328.GA26949@elte.hu>
References: <4BA3747F.60401@codemonkey.ws>
 <20100321191742.GD25922@elte.hu>
 <4BA67B2F.4030101@redhat.com>
 <20100321203121.GA30194@elte.hu>
 <20100322111040.GL13108@8bytes.org>
 <20100322122228.GH3483@elte.hu>
 <20100322134633.GD1940@8bytes.org>
 <20100322163215.GC18796@elte.hu>
 <y0mmxy0wa1r.fsf@fche.csb>
 <84144f021003221027t1a3e7d6ft64612654c5e50da@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <84144f021003221027t1a3e7d6ft64612654c5e50da@mail.gmail.com>
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


* Pekka Enberg <penberg@cs.helsinki.fi> wrote:

> Hi Frank,
> 
> On Mon, Mar 22, 2010 at 7:17 PM, Frank Ch. Eigler <fche@redhat.com> wrote:
> > In your very previous paragraphs, you enumerate two separate causes:
> > "repository structure" and "development/maintenance process" as being
> > sources of "fun". ?Please simply accept that the former is considered
> > by many as absolutely trivial compared to the latter, and additional
> > verbose repetition of your thesis will not change this.
> 
> I can accept that many people consider it trivial but the problem is that we 
> have _real data_ on kmemtrace and now perf that the amount of contributors 
> is significantly smaller when your code is outside the kernel repository. 
> Now admittedly both of them are pretty intimate with the kernel but Ingo's 
> suggestion of putting kvm-qemu in tools/ is an interesting idea 
> nevertheless.

Correct.

> It's kinda funny to see people argue that having an external repository is 
> not a problem and that it's not a big deal if building something from the 
> repository is slightly painful as long as it doesn't require a PhD when we 
> have _real world_ experience that it _does_ limit developer base in some 
> cases. Whether or not that applies to kvm remains to be seen but I've yet to 
> see a convincing argument why it doesn't.

Yeah.

Also, if in fact the claim that the 'repository does not matter' is true then 
it doesnt matter that it's hosted in tools/kvm/ either, right?

I.e. it's a win-win situation. Worst-case nothing happens beyond a Git URI 
change. Best-case the project is propelled to never seen heights due to 
contribution advantages not contemplated and not experienced by the KVM guys 
before ...

	Ingo
