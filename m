Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757495Ab1DXCP6 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Apr 2011 22:15:58 -0400
Received: from mga02.intel.com ([134.134.136.20]:16205 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757467Ab1DXCP5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Apr 2011 22:15:57 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.64,260,1301900400"; 
   d="scan'208";a="737555268"
Date: Sat, 23 Apr 2011 19:15:52 -0700
From: Andi Kleen <ak@linux.intel.com>
To: Stephane Eranian <eranian@google.com>
Cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
        arun@sharma-home.net, Arnaldo Carvalho de Melo <acme@infradead.org>,
        linux-kernel@vger.kernel.org, Lin Ming <ming.m.lin@intel.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>, eranian@gmail.com,
        Arun Sharma <asharma@fb.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [generalized cache events] Re: [PATCH 1/1] perf tools: Add
 missing user space support for config1/config2
Message-ID: <20110424021552.GA3019@alboin.amr.corp.intel.com>
References: <BANLkTikNWgzKefWxp6UUqQ-XdBvgG+QSNQ@mail.gmail.com>
 <20110422092322.GA1948@elte.hu>
 <BANLkTi=G7-v3ysxK2wY_3f8TecbD6ZjKog@mail.gmail.com>
 <20110422105211.GB1948@elte.hu>
 <20110422165007.GA18401@vps.sharma-home.net>
 <20110422203022.GA20573@elte.hu>
 <20110422203222.GA21219@elte.hu>
 <20110423000347.GC9328@tassilo.jf.intel.com>
 <1303545012.2298.44.camel@twins>
 <BANLkTi=pk7J1uqCQvJe+RrTPoi=K1Aa5QQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BANLkTi=pk7J1uqCQvJe+RrTPoi=K1Aa5QQ@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> 
> That is what Andi is referring to. The issue causes bias and thus impacts
> the quality of the samples. On SNB, there is a new INST_RETIRED:PREC_DIST
> event. PREC_DIST=precise distribution. It tries to correct for the skid
> on this event on INST_RETIRED with PEBS (look at Vol3b).

Unfortunately even PDIST doesn't completely fix the problem, but
it only makes it somewhat better. Also it's only statistical,
so you won't get a guaranteed answer for every sample.

-Andi
