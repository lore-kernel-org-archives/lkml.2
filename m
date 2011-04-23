Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757033Ab1DWAEk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Apr 2011 20:04:40 -0400
Received: from mga01.intel.com ([192.55.52.88]:6088 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755396Ab1DWAEi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Apr 2011 20:04:38 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.64,256,1301900400"; 
   d="scan'208";a="682754645"
Date: Fri, 22 Apr 2011 17:03:47 -0700
From: Andi Kleen <ak@linux.intel.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: arun@sharma-home.net, Stephane Eranian <eranian@google.com>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        linux-kernel@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>,
        Lin Ming <ming.m.lin@intel.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, eranian@gmail.com,
        Arun Sharma <asharma@fb.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [generalized cache events] Re: [PATCH 1/1] perf tools: Add
 missing user space support for config1/config2
Message-ID: <20110423000347.GC9328@tassilo.jf.intel.com>
References: <BANLkTikNWgzKefWxp6UUqQ-XdBvgG+QSNQ@mail.gmail.com>
 <20110422092322.GA1948@elte.hu>
 <BANLkTi=G7-v3ysxK2wY_3f8TecbD6ZjKog@mail.gmail.com>
 <20110422105211.GB1948@elte.hu>
 <20110422165007.GA18401@vps.sharma-home.net>
 <20110422203022.GA20573@elte.hu>
 <20110422203222.GA21219@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110422203222.GA21219@elte.hu>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > Yes, and note that with instructions events we even have skid-less PEBS 
> > profiling so seeing the precise .
>                                   - location of instructions is possible.

It was better when it was eaten. PEBS does not actually eliminated
skid unfortunately. The interrupt still occurs later, so the
instruction location is off.

PEBS merely gives you more information.

-Andi
