Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754747Ab0CVMpF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Mar 2010 08:45:05 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:43187 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754550Ab0CVMpA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Mar 2010 08:45:00 -0400
Date: Mon, 22 Mar 2010 13:44:28 +0100
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
       Fr?d?ric Weisbecker <fweisbec@gmail.com>,
       Gregory Haskins <ghaskins@novell.com>
Subject: Re: [RFC] Unify KVM kernel-space and user-space code into a single
 project
Message-ID: <20100322124428.GA12475@elte.hu>
References: <20100319085346.GG12576@elte.hu>
 <4BA47AD0.2010509@redhat.com>
 <20100321190656.GC25922@elte.hu>
 <4BA68009.5010906@redhat.com>
 <20100321205531.GC30194@elte.hu>
 <4BA692C3.7010408@redhat.com>
 <20100321215455.GB13219@elte.hu>
 <4BA7187E.3050405@redhat.com>
 <20100322111411.GC3483@elte.hu>
 <4BA7629B.7020604@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4BA7629B.7020604@redhat.com>
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

> On 03/22/2010 01:14 PM, Ingo Molnar wrote:
> >
> >>I think we agree at last.  Neither I nor my employer are interested in
> >>running qemu as a desktop-on-desktop tool, therefore I don't invest any
> >>effort in that direction, or require it from volunteers.
> >Obviously your employer at least in part defers to you when it comes to KVM
> >priorities.
> 
> In part, yes.
> 
> > So, just to make this really clear, _you_ are not interested in running 
> > qemu as a desktop-on-desktop tool, subsequently this kind of 
> > disinterest-for-desktop-usability trickled through the whole KVM stack and 
> > poisoned your attitude and your contributor's attitude.
> 
> I am also disinterested in ppc virtualization, yet it happened.  I am 
> disinterested in ia64 virtualization, yet it happened.  I am disinterested 
> in s390 virtualization, yet it happened.
> 
> Linus doesn't care about virtualization, yet it happened.

You should know the answer yourself: the difference is that usability is a 
core quality of any project.

I as a maintainer can be neutral towards a number of features and patch 
attributes that i dont consider key aspects. (although they can grow out to 
become key features in the future. SMP was a fringe thing 15 years ago.)

Usability is not an attribute you can ignore and i for sure am never neutral 
towards usability deficiencies in patches - i consider usability a key 
quality.

> I don't tell my contributor what to be interested in, only whether their 
> patches are good or not. [...]

Whether a feature is usable or not is sure a metric of 'goodness'.

You have restricted your metric of goodness artificially to not include 
usability. You do that by claiming that the user-space tooling of KVM, while 
being functionally absolutely essential for any user to even try out KVM, is 
'separate' and has no quality connection with the kernel bits of KVM.

It is a convenient argument that allows you to do the kernel bits only. It is 
absolutely catastrophic to the user who'd like to see a usable solution and a 
single project who stands behind their tech.

Thus, _today_, after years of neglect, you can claim that none of the dozens 
of usability problems of KVM has anything to do with the features you are 
working on today. It's in a separate project (the so-called 'Qemu' package) 
after all - none of KVM's business.

In reality if you consider it a single project then those bugs were all 
usability problems introduced earlier on, years ago, when a piece of 
functionality was exposed via KVM. It adds up and now you claim they have 
nothing to do with current work.

This is why i consider that line of argument rather dishonest ...

	Ingo
