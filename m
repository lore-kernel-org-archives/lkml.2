Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753870Ab0LVQVh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Dec 2010 11:21:37 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:55739 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753247Ab0LVQVg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Dec 2010 11:21:36 -0500
Date: Wed, 22 Dec 2010 17:21:18 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Eric Dumazet <eric.dumazet@gmail.com>
Cc: Dan Rosenberg <drosenberg@vsecurity.com>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, linux-security-module@vger.kernel.org,
        jmorris@namei.org, tgraf@infradead.org, eugeneteo@kernel.org,
        kees.cook@canonical.com, davem@davemloft.net, a.p.zijlstra@chello.nl,
        akpm@linux-foundation.org, eparis@parisplace.org,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH v4] kptr_restrict for hiding kernel pointers
Message-ID: <20101222162118.GC20358@elte.hu>
References: <1292708499.10804.89.camel@dan>
 <20101222130349.GB13412@elte.hu>
 <1293023589.9820.186.camel@dan>
 <1293025688.3027.82.camel@edumazet-laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1293025688.3027.82.camel@edumazet-laptop>
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


* Eric Dumazet <eric.dumazet@gmail.com> wrote:

> Le mercredi 22 décembre 2010 à 08:13 -0500, Dan Rosenberg a écrit :
> > > Hm, why is it off by default? Is there some user-space regression that is caused by 
> > > this?
> > > 
> > > We really want good security measures to be active by default (and to work by 
> > > default) - they are not worth much if they are not.
> > > 
> > 
> > I agree entirely, but I've received a lot of resistance to these types
> > of changes in net.  I'm afraid that if it's enabled by default, no one
> > will actually allow use of the %pK specifier where it should be used.
> > 
> 
> Actually, "net resistance" was against your first patches, using quick
> and dirty techniques (Should I remind you some of them ?)
> 
> Now you have a helper, it should be easier to integrate the changes.

Great - if the concept itself wasnt objected to then i think we should flip the 
default to on.

Thanks,

	Ingo
