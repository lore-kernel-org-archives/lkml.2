Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752934Ab0LVNEo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Dec 2010 08:04:44 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:39651 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752021Ab0LVNEm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Dec 2010 08:04:42 -0500
Date: Wed, 22 Dec 2010 14:03:49 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Dan Rosenberg <drosenberg@vsecurity.com>
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        linux-security-module@vger.kernel.org, jmorris@namei.org,
        eric.dumazet@gmail.com, tgraf@infradead.org, eugeneteo@kernel.org,
        kees.cook@canonical.com, davem@davemloft.net, a.p.zijlstra@chello.nl,
        akpm@linux-foundation.org, eparis@parisplace.org,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH v4] kptr_restrict for hiding kernel pointers
Message-ID: <20101222130349.GB13412@elte.hu>
References: <1292708499.10804.89.camel@dan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1292708499.10804.89.camel@dan>
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

> +kptr_restrict:
> +
> +This toggle indicates whether restrictions are placed on
> +exposing kernel addresses via /proc and other interfaces.  When
> +kptr_restrict is set to (0), the default, there are no
> +restrictions.  When kptr_restrict is set to (1), kernel pointers
> +printed using the %pK format specifier will be replaced with 0's
> +unless the user has CAP_SYSLOG.  When kptr_restrict is set to
> +(2), kernel pointers printed using %pK will be replaced with 0's
> +regardless of privileges.

Hm, why is it off by default? Is there some user-space regression that is caused by 
this?

We really want good security measures to be active by default (and to work by 
default) - they are not worth much if they are not.

Thanks,

	Ingo
