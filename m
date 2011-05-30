Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756350Ab1E3IWS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 May 2011 04:22:18 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:38064 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756141Ab1E3IWR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 May 2011 04:22:17 -0400
Date: Mon, 30 May 2011 10:22:05 +0200
From: Ingo Molnar <mingo@elte.hu>
To: David Ahern <dsahern@gmail.com>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        LKML <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: perf: h/w counters not counted and no error/info reported to user
Message-ID: <20110530082205.GL27557@elte.hu>
References: <4DDECFC8.7090903@gmail.com>
 <20110527095036.GK21386@elte.hu>
 <4DDFBD83.3020105@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4DDFBD83.3020105@gmail.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.3.1
	-2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* David Ahern <dsahern@gmail.com> wrote:

> 
> 
> On 05/27/2011 03:50 AM, Ingo Molnar wrote:
> > 
> > * David Ahern <dsahern@gmail.com> wrote:
> > 
> >> By default (tip-perf-core) perf-stat enables a number of H/W counters:
> >>
> >> perf stat  -- sleep 1
> > 
> > did you mean to do 'perf stat -a sleep 1' ?
> 
> Adding the -a has its own problems. It blocks reading from fd=0 
> (stdin); I have to type Ctrl-D to see the results. The FD array 
> gets initialized to 0 and some case is not erroring out or setting 
> the fd.

Ok, that's a bug (and you sent the fix for it already) - weird that i 
havent seen this before, i use perf stat -a sleep 1 type of analysis 
all the time.

Thanks,

	Ingo
