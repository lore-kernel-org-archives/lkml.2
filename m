Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752631Ab0CZJQt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Mar 2010 05:16:49 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:57737 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752013Ab0CZJQr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Mar 2010 05:16:47 -0400
Date: Fri, 26 Mar 2010 10:16:39 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [PATCH] lockdep: Make lockstats counting per cpu
Message-ID: <20100326091639.GG27394@elte.hu>
References: <1269570142-13965-1-git-send-regression-fweisbec@gmail.com>
 <1269573118-11120-1-git-send-regression-fweisbec@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1269573118-11120-1-git-send-regression-fweisbec@gmail.com>
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


* Frederic Weisbecker <fweisbec@gmail.com> wrote:

> +DEFINE_PER_CPU(local_t, chain_lookup_hits);
> +DEFINE_PER_CPU(local_t, chain_lookup_misses);
> +DEFINE_PER_CPU(local_t, hardirqs_on_events);
> +DEFINE_PER_CPU(local_t, hardirqs_off_events);
> +DEFINE_PER_CPU(local_t, redundant_hardirqs_on);
> +DEFINE_PER_CPU(local_t, redundant_hardirqs_off);
> +DEFINE_PER_CPU(local_t, softirqs_on_events);
> +DEFINE_PER_CPU(local_t, softirqs_off_events);
> +DEFINE_PER_CPU(local_t, redundant_softirqs_on);
> +DEFINE_PER_CPU(local_t, redundant_softirqs_off);
> +DEFINE_PER_CPU(local_t, nr_unused_locks);
> +DEFINE_PER_CPU(local_t, nr_cyclic_checks);
> +DEFINE_PER_CPU(local_t, nr_find_usage_forwards_checks);
> +DEFINE_PER_CPU(local_t, nr_find_usage_backwards_checks);

btw., i think this should really be cleaned up and put into a helper struct.

'struct lockdep_stats' or so?

	Ingo
