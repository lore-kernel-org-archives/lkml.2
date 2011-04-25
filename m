Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758742Ab1DYSF7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Apr 2011 14:05:59 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:57577 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754005Ab1DYSF6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Apr 2011 14:05:58 -0400
Date: Mon, 25 Apr 2011 20:05:28 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Dehao Chen <danielcdh@gmail.com>
Cc: Andi Kleen <ak@linux.intel.com>, Peter Zijlstra <peterz@infradead.org>,
        arun@sharma-home.net, Stephane Eranian <eranian@google.com>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        linux-kernel@vger.kernel.org, Lin Ming <ming.m.lin@intel.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>, eranian@gmail.com,
        Arun Sharma <asharma@fb.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [generalized cache events] Re: [PATCH 1/1] perf tools: Add
 missing user space support for config1/config2
Message-ID: <20110425180528.GA30724@elte.hu>
References: <BANLkTi=G7-v3ysxK2wY_3f8TecbD6ZjKog@mail.gmail.com>
 <20110422105211.GB1948@elte.hu>
 <20110422165007.GA18401@vps.sharma-home.net>
 <20110422203022.GA20573@elte.hu>
 <20110422203222.GA21219@elte.hu>
 <20110423000347.GC9328@tassilo.jf.intel.com>
 <1303545012.2298.44.camel@twins>
 <20110424021907.GB3019@alboin.amr.corp.intel.com>
 <20110425174110.GB28239@elte.hu>
 <BANLkTiks31-pMJe4zCKrppsrA1d6KanJFA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BANLkTiks31-pMJe4zCKrppsrA1d6KanJFA@mail.gmail.com>
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


* Dehao Chen <danielcdh@gmail.com> wrote:

> > ... and the resulting low level of noise in the average period length is 
> > what matters. The instruction itself will still be one of the hotspot 
> > instructions, statistically.
> 
> Not true. This skid will lead to some aggregation and shadow effects on some 
> certain instructions. To make things worse, these effects are deterministic 
> and cannot be removed by either sampling for multiple times or by averaging 
> among instructions within a basic block. As a result, some actual "hot spot" 
> are not sampled at all. You can simply try to collect a basic block level 
> CPI, and you'll get a very misleading profile.

This certainly does not match the results i'm seeing on real applications, 
using "-e instructions:pp" PEBS+LBR profiling. How do you explain that? Also, 
can you demonstrate your claim with a real example?

Thanks,

	Ingo
