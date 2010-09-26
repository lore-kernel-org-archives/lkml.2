Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752018Ab0IZInA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Sep 2010 04:43:00 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:37460 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751462Ab0IZIm6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Sep 2010 04:42:58 -0400
Date: Sun, 26 Sep 2010 10:42:33 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Peter Zijlstra <peterz@infradead.org>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Venkatesh Pallipadi <venki@google.com>,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        linux-kernel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH] generic-ipi: fix deadlock in __smp_call_function_single
Message-ID: <20100926084233.GA28809@elte.hu>
References: <20100909135050.GB2228@osiris.boeblingen.de.ibm.com>
 <1284116817.402.33.camel@laptop>
 <20100910172805.a4fe5c7f.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100910172805.a4fe5c7f.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: 0.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=0.5 required=5.9 tests=BAYES_40 autolearn=no SpamAssassin version=3.2.5
	0.5 BAYES_40               BODY: Bayesian spam probability is 20 to 40%
	[score: 0.2794]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Andrew Morton <akpm@linux-foundation.org> wrote:

> Maybe.  Or maybe it papers over a scheduler bug by gratuitously adding 
> additional code which no present callsites actually need.

Hm, indeed.

We now have the scheduler bug fixed upstream. Do we really need this 
patch?

> The patch didn't update the __smp_call_function_single() kerneldoc. 
> Compare it with smp_call_function_single() and note the subtle 
> difference between "a specific CPU" and the now incorrect "on another 
> CPU".

In any case this feedback didnt get addressed AFAICS.

	Ingo
