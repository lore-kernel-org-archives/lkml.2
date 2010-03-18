Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752528Ab0CRWQa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Mar 2010 18:16:30 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:38988 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751450Ab0CRWQ3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Mar 2010 18:16:29 -0400
Date: Thu, 18 Mar 2010 23:16:17 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: drepper@gmail.com, Anthony Liguori <anthony@codemonkey.ws>,
       Avi Kivity <avi@redhat.com>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
       Marcelo Tosatti <mtosatti@redhat.com>, Joerg Roedel <joro@8bytes.org>,
       Jes Sorensen <Jes.Sorensen@redhat.com>, Gleb Natapov <gleb@redhat.com>,
       Zachary Amsden <zamsden@redhat.com>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Fr?d?ric Weisbecker <fweisbec@gmail.com>
Subject: Re: [RFC] Unify KVM kernel-space and user-space code into a single
 project
Message-ID: <20100318221617.GB19669@elte.hu>
References: <20100318201826.GA20588@elte.hu>
 <g6y0y1gaeew5bcwbUYAxe124vaj_firegpg@mail.gmail.com>
 <20100318205655.GB4821@elte.hu>
 <20100318220654.4305b9e0@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100318220654.4305b9e0@lxorguk.ukuu.org.uk>
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


* Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:

> > So it's good enough to be in Fedora/RHEL but not good enough to be in 
> > upstream glibc? How is that possible? Isnt that a double standard?
> 
> Yes its a double standard
> 
> Glibc has a higher standard than Fedora/RHEL.
>
> Just like the Ubuntu kernel ships various ugly unfit for upstream kernel 
> drivers.

There's a world of a difference between a fugly driver and a glibc patch.

Also, we tend to upstream even fugly kernel drivers if they are important and 
are deployed by a major distro - see Noveau.

> > kernel's fault. But glibc is certainly not being helpful in that situation 
> > either and your earlier claim that you are only waiting for the patches is 
> > rather dishonest.
> 
> I am sure Ulrich is being totally honest, but send him the patches and 
> you'll find out. Plus you will learn what the API should look like when you 
> try and create them ...

I was there and extended/fixed bits of the kaio/libaio code when they were 
written so yes i already know something about it. To say that the glibc 
reaction was less than enthusiastic back then is a strong euphemism ;-)

So after 8 years some of the bits made its way into Fedora/RHEL.

I think this is a pretty good demonstration of the points i made ;-)

Thanks,

	Ingo
