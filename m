Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752860Ab0IFMnl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Sep 2010 08:43:41 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:42063 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751146Ab0IFMnk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Sep 2010 08:43:40 -0400
Date: Mon, 6 Sep 2010 14:43:30 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Avi Kivity <avi@redhat.com>, Tom Zanussi <tzanussi@gmail.com>,
        =?iso-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>, linux-perf-users@vger.kernel.org,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: disabling group leader perf_event
Message-ID: <20100906124330.GA22314@elte.hu>
References: <4C84B088.5050003@redhat.com>
 <1283772256.1930.303.camel@laptop>
 <4C84D1CE.3070205@redhat.com>
 <1283774045.1930.341.camel@laptop>
 <4C84D77B.6040600@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4C84D77B.6040600@redhat.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: 1.0
X-ELTE-SpamLevel: s
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=1.0 required=5.9 tests=BAYES_50 autolearn=no SpamAssassin version=3.2.5
	1.0 BAYES_50               BODY: Bayesian spam probability is 40 to 60%
	[score: 0.4941]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Avi Kivity <avi@redhat.com> wrote:

> > Being able to make histograms in-kernel has been on the todo list 
> > for a long while, its just that I never could come up with a sane 
> > interface.. :/
> 
> Interesting, I thought it was just me.
> 
> One option is to keep the existing filter interface, but recognize 
> those cases and optimize the implementation.  Sort of like a compiler 
> can optimize a large dense switch statement to a jump table.

Yes. The filter engine is a safe, in-kernel interpreted language in the 
making. The C syntax was chosen because it's close to the heart of every 
kernel developer.

It might make sense to bring this concept a few steps further. Looks 
rather complex but also rather cool ...

Thanks,

	Ingo
