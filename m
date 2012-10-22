Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752481Ab2JVJQQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Oct 2012 05:16:16 -0400
Received: from mx1.redhat.com ([209.132.183.28]:38053 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751125Ab2JVJQP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Oct 2012 05:16:15 -0400
Date: Mon, 22 Oct 2012 11:15:58 +0200
From: Jiri Olsa <jolsa@redhat.com>
To: Namhyung Kim <namhyung@kernel.org>
Cc: Ingo Molnar <mingo@kernel.org>, linux-kernel@vger.kernel.org,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
        Paul Mackerras <paulus@samba.org>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: Re: [PATCH 00/11] perf tool: Add PERF_SAMPLE_READ sample read support
Message-ID: <20121022091557.GC6759@krava.brq.redhat.com>
References: <1350743599-4805-1-git-send-email-jolsa@redhat.com>
 <20121021163848.GB28726@gmail.com>
 <20121022080930.GB984@krava.brq.redhat.com>
 <87a9vekhze.fsf@sejong.aot.lge.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87a9vekhze.fsf@sejong.aot.lge.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 22, 2012 at 05:51:01PM +0900, Namhyung Kim wrote:
> On Mon, 22 Oct 2012 10:09:31 +0200, Jiri Olsa wrote:
> > On Sun, Oct 21, 2012 at 06:38:49PM +0200, Ingo Molnar wrote:
> >> >   #
> >> >   # Samples: 86  of event 'anon group { cycles, cache-misses }'
> >> >   # Event count (approx.): 34863674
> >> >   #
> >> >   #         Overhead                    Period  Command      Shared Object                            Symbol
> >> >   # ................  ........................  .......  .................  ................................
> >> 
> >> Might make sense to consider this column enumeration:
> >> 
> >>     #
> >>     #   cycles
> >>     #   |       cache-misses
> >>     #   |       |
> >> >   #   v       v
> >> >   #
> >> >       16.56%  19.47%       5773450         475       ls  [kernel.kallsyms]  [k] native_sched_clock          
> >> >       10.87%   0.74%       3789088          18       ls  [kernel.kallsyms]  [k] rtl8169_interrupt           
> >
> > no problem in '--stdio' mode I guess.. not sure in '--tui/--gtk', Namhyung?
> 
> I thought a similar way but met a problem.  We have other output columns
> than 'overhead' like 'period' in this example.  What about others?
> Adding all event names for each column will just increase the column
> width so bothers user IMHO - especially for pmu format events.

how about each event name is in special row as outlined above

should be no problem in stdio and could be optional (key toggled) in tui

jirka
