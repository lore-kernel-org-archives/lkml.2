Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754567Ab0EUKix (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 May 2010 06:38:53 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:43487 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753136Ab0EUKiw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 May 2010 06:38:52 -0400
Date: Fri, 21 May 2010 12:38:40 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
       Paul Mackerras <paulus@samba.org>,
       Arnaldo Carvalho de Melo <acme@infradead.org>,
       Steven Rostedt <rostedt@goodmis.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 02/10] perf, trace: Use per-tracepoint-per-cpu hlist to
 track events
Message-ID: <20100521103840.GA23624@elte.hu>
References: <20100521090201.326791353@chello.nl>
 <20100521090710.473188012@chello.nl>
 <20100521094014.GA30108@nowhere>
 <1274436125.1674.1690.camel@laptop>
 <20100521101347.GC30108@nowhere>
 <1274436943.1674.1693.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1274436943.1674.1693.camel@laptop>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -1.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.0 required=5.9 tests=BAYES_20 autolearn=no SpamAssassin version=3.2.5
	-1.0 BAYES_20               BODY: Bayesian spam probability is 5 to 20%
	[score: 0.1292]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Peter Zijlstra <peterz@infradead.org> wrote:

> On Fri, 2010-05-21 at 12:13 +0200, Frederic Weisbecker wrote:
> > > What exactly is the puzzlement about?
> 
> > The fact we use the hlist API not for hlist purpose 
> > but for a list.
> 
> I might miss the confusion, but hlist _are_ lists. Its 
> just that their structure is slightly different that the 
> regular struct list_head stuff.

Using an API in such a mixed way may cause puzzlement ;-)

Fortunately we've got the ultimate anti-puzzlement weapon: 
code comments.

	Ingo
