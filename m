Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758883Ab1DYTqD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Apr 2011 15:46:03 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:44679 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758152Ab1DYTqB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Apr 2011 15:46:01 -0400
Date: Mon, 25 Apr 2011 21:45:42 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Stephane Eranian <eranian@google.com>
Cc: Dehao Chen <danielcdh@gmail.com>, Andi Kleen <ak@linux.intel.com>,
        Peter Zijlstra <peterz@infradead.org>, arun@sharma-home.net,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        linux-kernel@vger.kernel.org, Lin Ming <ming.m.lin@intel.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>, eranian@gmail.com,
        Arun Sharma <asharma@fb.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [generalized cache events] Re: [PATCH 1/1] perf tools: Add
 missing user space support for config1/config2
Message-ID: <20110425194542.GA391@elte.hu>
References: <20110422165007.GA18401@vps.sharma-home.net>
 <20110422203022.GA20573@elte.hu>
 <20110422203222.GA21219@elte.hu>
 <20110423000347.GC9328@tassilo.jf.intel.com>
 <1303545012.2298.44.camel@twins>
 <20110424021907.GB3019@alboin.amr.corp.intel.com>
 <20110425174110.GB28239@elte.hu>
 <BANLkTiks31-pMJe4zCKrppsrA1d6KanJFA@mail.gmail.com>
 <20110425180528.GA30724@elte.hu>
 <BANLkTimUFP68L2CwEwoLDPMwJSO_aK_Qvg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BANLkTimUFP68L2CwEwoLDPMwJSO_aK_Qvg@mail.gmail.com>
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


* Stephane Eranian <eranian@google.com> wrote:

> > This certainly does not match the results i'm seeing on real applications, 
> > using "-e instructions:pp" PEBS+LBR profiling. How do you explain that? 
> > Also, can you demonstrate your claim with a real example?
> 
> LBR removes the off-by-1 IP problem, it does not remove the shadow effect, 
> i.e., that blind spot of N cycles caused by the PEBS arming mechanism.

I really think you are grasping at straws here - unless you are able to 
demonstrate clear problems - which you have failed to do so far. The pure act
of profiling probably disturbs a typical workload statistically more than a
few cycles skew of the period.

I could imagine artifacts with realy short periods and artificially short and 
dominant hotpaths - but in those cases the skew does not matter much in 
practice: a short and dominant hotpath is pinpointed very easily ...

So i really think it's a non-issue in practice - but you can certainly prove me 
wrong by demonstrating whatever problems you suspect.

Thanks,

	Ingo
