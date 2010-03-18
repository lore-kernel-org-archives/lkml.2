Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752589Ab0CRU5I (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Mar 2010 16:57:08 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:51176 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751421Ab0CRU5E (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Mar 2010 16:57:04 -0400
Date: Thu, 18 Mar 2010 21:56:55 +0100
From: Ingo Molnar <mingo@elte.hu>
To: drepper@gmail.com
Cc: Anthony Liguori <anthony@codemonkey.ws>, Avi Kivity <avi@redhat.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, linux-kernel@vger.kernel.org,
       kvm@vger.kernel.org, Marcelo Tosatti <mtosatti@redhat.com>,
       Joerg Roedel <joro@8bytes.org>, Jes Sorensen <Jes.Sorensen@redhat.com>,
       Gleb Natapov <gleb@redhat.com>, Zachary Amsden <zamsden@redhat.com>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Fr?d?ric Weisbecker <fweisbec@gmail.com>
Subject: Re: [RFC] Unify KVM kernel-space and user-space code into a single
 project
Message-ID: <20100318205655.GB4821@elte.hu>
References: <20100318201826.GA20588@elte.hu>
 <g6y0y1gaeew5bcwbUYAxe124vaj_firegpg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <g6y0y1gaeew5bcwbUYAxe124vaj_firegpg@mail.gmail.com>
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


* drepper@gmail.com <drepper@gmail.com> wrote:

> > For example, just to state the obvious: libaio has been written 8 years 
> > ago in 2002 and has been used in apps early on. Why arent those kernel 
> > APIs, while not being a full/complete solution, supported by glibc, and 
> > wrapped to pthreads based emulation on kernels that dont support it?
> 
> You never looked at the glibc code in use and didn't read what I wrote 
> before.  We do have an implementation of libaio using those interfaces.  
> They exist in the Fedora/RHEL glibc and are probably copied elsewhere, too.  
> The code is not upstream because it is not general enough.  It simply 
> doesn't work in all situations.

So it's good enough to be in Fedora/RHEL but not good enough to be in upstream 
glibc? How is that possible? Isnt that a double standard?

Upstream libc presence is really what is needed for an API to be ubiquitous to 
apps. That is what 'closes the loop' in the the positive feedback cycle loop 
and creates real back pressure and demand on the kernel to get its act 
together.

Again, i state it for the third time, the KAIO situation is mostly the 
kernel's fault. But glibc is certainly not being helpful in that situation 
either and your earlier claim that you are only waiting for the patches is 
rather dishonest.

Thanks,

	Ingo
