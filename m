Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755935Ab1BJMQU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Feb 2011 07:16:20 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:45375 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752748Ab1BJMQS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Feb 2011 07:16:18 -0500
Date: Thu, 10 Feb 2011 13:15:59 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Mike Galbraith <efault@gmx.de>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>, mingo@redhat.com,
        hpa@zytor.com, paulus@samba.org, eranian@google.com,
        linux-kernel@vger.kernel.org, tzanussi@gmail.com, peterz@infradead.org,
        fweisbec@gmail.com, tglx@linutronix.de,
        linux-tip-commits@vger.kernel.org
Subject: Re: [tip:perf/core] perf annotate: Fix annotate context lines
 regression
Message-ID: <20110210121559.GA26094@elte.hu>
References: <new-submission>
 <tip-d5e3d747007fdb541e57ed72e020ff0b94db3470@git.kernel.org>
 <1297224378.8035.7.camel@marge.simson.net>
 <20110209164154.GA15607@ghostprotocols.net>
 <1297309313.7996.11.camel@marge.simson.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1297309313.7996.11.camel@marge.simson.net>
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


* Mike Galbraith <efault@gmx.de> wrote:

> Initial impression: can I have a pony too? :)
> 
> I like this a lot, great for live rummaging.  One thing that would help with large 
> files maybe - a jump to next spot hotter than N%, but as is is quite nice.
> 
> I managed to lock it up once, but shiny new gizmos usually do hiccup.

The TUI locked up or the kernel? If it's the TUI then a gdb dump of the lockup would 
be nice.

Thanks,

	Ingo
