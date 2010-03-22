Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754812Ab0CVTM1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Mar 2010 15:12:27 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:38356 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750861Ab0CVTMY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Mar 2010 15:12:24 -0400
Date: Mon, 22 Mar 2010 20:10:28 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Avi Kivity <avi@redhat.com>
Cc: Joerg Roedel <joro@8bytes.org>, Anthony Liguori <anthony@codemonkey.ws>,
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
Message-ID: <20100322191028.GB21919@elte.hu>
References: <20100319085346.GG12576@elte.hu>
 <4BA3747F.60401@codemonkey.ws>
 <20100321191742.GD25922@elte.hu>
 <4BA67B2F.4030101@redhat.com>
 <20100321203121.GA30194@elte.hu>
 <20100322111040.GL13108@8bytes.org>
 <20100322122228.GH3483@elte.hu>
 <20100322134633.GD1940@8bytes.org>
 <20100322163215.GC18796@elte.hu>
 <4BA7AC6B.3050103@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4BA7AC6B.3050103@redhat.com>
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


* Avi Kivity <avi@redhat.com> wrote:

> On 03/22/2010 06:32 PM, Ingo Molnar wrote:
> >
> > So, what do you think creates code communities and keeps them alive? 
> > Developers and code. And the wellbeing of developers are primarily 
> > influenced by the repository structure and by the development/maintenance 
> > process - i.e. by the 'fun' aspect. (i'm simplifying things there but 
> > that's the crux of it.)
> 
> There is nothing fun about having one repository or two.  Who cares about 
> this anyway?
> 
> tools/kvm/ probably will draw developers, simply because of the glory 
> associated with kernel work.  That's a bug, not a feature.  It means that 
> effort is not distributed according to how it's needed, but because of 
> irrelevant considerations.

And yet your solution to that is to ... do all your work in the kernel space 
and declare the tooling as something that does not interest you? ;-)

> Something I've wanted for a long time is to port kvm_stat to use tracepoints 
> instead of the home-grown instrumentation.  But that is unrelated to this 
> new tracepoint.  Other than that we're satisfied with ftrace.

Despite it being another in-kernel subsystem that by your earlier arguments 
should be done via a user-space package? ;-)

> > You should realize that naturally developers will gravitate towards the 
> > most 'fun' aspects of a project. It is the task of the maintainer to keep 
> > the balance between fun and utility, bugs and features, quality and 
> > code-rot.
> 
> There are plenty of un-fun tasks (like fixing bugs and providing RAS 
> features) that we're doing.  We don't do this for fun but to satisfy our 
> users.

So which one is it, KVM developers are volunteers that do fun stuff and cannot 
be told about project priorities, or KVM developers are pros who do unfun 
stuff because they can be told about priorities?

I posit that it's both: and that priorities can be communicated - if only you 
try as a maintainer. All i'm suggesting is to add 'usable, unified user-space' 
to the list of unfun priorities, because it's possible and because it matters.

	Ingo
