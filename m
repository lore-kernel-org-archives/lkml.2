Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754789Ab0EUKvN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 May 2010 06:51:13 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:36192 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752415Ab0EUKvM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 May 2010 06:51:12 -0400
Date: Fri, 21 May 2010 12:51:02 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
       Paul Mackerras <paulus@samba.org>,
       Arnaldo Carvalho de Melo <acme@infradead.org>,
       Steven Rostedt <rostedt@goodmis.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 02/10] perf, trace: Use per-tracepoint-per-cpu hlist to
 track events
Message-ID: <20100521105102.GA11568@elte.hu>
References: <20100521090201.326791353@chello.nl>
 <20100521090710.473188012@chello.nl>
 <20100521094014.GA30108@nowhere>
 <1274436125.1674.1690.camel@laptop>
 <20100521101347.GC30108@nowhere>
 <1274436943.1674.1693.camel@laptop>
 <20100521103840.GA23624@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100521103840.GA23624@elte.hu>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -1.1
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.1 required=5.9 tests=BAYES_05 autolearn=no SpamAssassin version=3.2.5
	-1.1 BAYES_05               BODY: Bayesian spam probability is 1 to 5%
	[score: 0.0222]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Ingo Molnar <mingo@elte.hu> wrote:

> 
> * Peter Zijlstra <peterz@infradead.org> wrote:
> 
> > On Fri, 2010-05-21 at 12:13 +0200, Frederic Weisbecker wrote:
> > > > What exactly is the puzzlement about?
> > 
> > > The fact we use the hlist API not for hlist purpose 
> > > but for a list.
> > 
> > I might miss the confusion, but hlist _are_ lists. Its 
> > just that their structure is slightly different that 
> > the regular struct list_head stuff.
> 
> Using an API in such a mixed way may cause puzzlement 
> ;-)

I take that back - it's clear from the function prototype 
that we are using a mixed API: (hlist,list).

Sorry,

	Ingo
