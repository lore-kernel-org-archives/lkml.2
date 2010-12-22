Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753722Ab0LVQUm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Dec 2010 11:20:42 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:55598 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753247Ab0LVQUk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Dec 2010 11:20:40 -0500
Date: Wed, 22 Dec 2010 17:20:25 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Dan Rosenberg <drosenberg@vsecurity.com>
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        linux-security-module@vger.kernel.org, jmorris@namei.org,
        eric.dumazet@gmail.com, tgraf@infradead.org, eugeneteo@kernel.org,
        kees.cook@canonical.com, davem@davemloft.net, a.p.zijlstra@chello.nl,
        akpm@linux-foundation.org, eparis@parisplace.org,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH v4] kptr_restrict for hiding kernel pointers
Message-ID: <20101222162025.GB20358@elte.hu>
References: <1292708499.10804.89.camel@dan>
 <20101222130349.GB13412@elte.hu>
 <1293023589.9820.186.camel@dan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1293023589.9820.186.camel@dan>
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


* Dan Rosenberg <drosenberg@vsecurity.com> wrote:

> 
> > Hm, why is it off by default? Is there some user-space regression that is caused 
> > by this?
> > 
> > We really want good security measures to be active by default (and to work by 
> > default) - they are not worth much if they are not.
> 
> I agree entirely, but I've received a lot of resistance to these types
> of changes in net.  I'm afraid that if it's enabled by default, no one
> will actually allow use of the %pK specifier where it should be used.

Some specific objections would be needed - which might arrive if the default is 
changed to on.

> As far as I know, there's no actual breakage of anything in userspace,
> but there's a general "it might make it harder to debug things in
> certain limited circumstances" sentiment among some.  I never understood
> why it is necessary for unprivileged users to be able to debug the
> kernel.
> 
> Does anyone else have thoughts on this?

Well, lets just enable it by default and let others argue for less security, hm?

Thanks,

	Ingo
