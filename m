Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761304Ab1EASBL (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 May 2011 14:01:11 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:52128 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755358Ab1EASBI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 May 2011 14:01:08 -0400
Date: Sun, 1 May 2011 20:00:38 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Andi Kleen <ak@linux.intel.com>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Pekka Enberg <penberg@kernel.org>,
        Vince Weaver <vweaver1@eecs.utk.edu>, torvalds@linux-foundation.org,
        linux-kernel@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@gmail.com>, Carl Love <carll@us.ibm.com>
Subject: Re: re-enable Nehalem raw Offcore-Events support
Message-ID: <20110501180038.GB27830@elte.hu>
References: <alpine.DEB.2.00.1104291056220.22212@cl320.eecs.utk.edu>
 <BANLkTimjmYUJMGw0aB+w+E76H+kxSpqFZg@mail.gmail.com>
 <20110429172525.GA2745@tassilo.jf.intel.com>
 <alpine.LFD.2.02.1104291938240.3005@ionos>
 <4DBC6BC1.5090102@linux.vnet.ibm.com>
 <20110501044551.GB16177@alboin.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110501044551.GB16177@alboin.amr.corp.intel.com>
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


* Andi Kleen <ak@linux.intel.com> wrote:

> > I would say that most if not all of the events are not generalizable
> > in the sense that you are talking about; the events are very
> > specific to the Torrent chip.  For example, the Torrent chip
> 
> It's similar also on Intel chips. [...]

You seem to be seriously misinformed about Intel CPUs.

There are a fair number of events on Intel CPUs that can be generalized and 
which we have already generalized. Here's a selection:

 Performance counter stats for './fill_1b':

       2829.562519 task-clock               #    0.994 CPUs utilized          
                27 context-switches         #    0.000 M/sec                  
                52 CPU-migrations           #    0.000 M/sec                  
                99 page-faults              #    0.000 M/sec                  
     8,559,062,611 cycles                   #    3.025 GHz                      (20.02%)
     2,530,761,381 stalled-cycles-frontend  #   29.57% frontend cycles idle     (30.03%)
       423,070,037 stalled-cycles-backend   #    4.94% backend  cycles idle     (40.04%)
    18,043,436,126 instructions             #    2.11  insns per cycle        
                                            #    0.14  stalled cycles per insn  (50.04%)
     1,007,704,770 branches                 #  356.134 M/sec                    (60.04%)
           521,894 branch-misses            #    0.05% of all branches          (60.02%)
         9,424,849 L1-dcache-loads          #    3.331 M/sec                    (50.03%)
         1,028,884 L1-dcache-load-misses    #   10.92% of all L1-dcache hits    (50.02%)
           490,266 LLC-loads                #    0.173 M/sec                    (39.99%)
           133,226 LLC-load-misses          #    0.047 M/sec                    (10.01%)

        2.846836822  seconds time elapsed

Thanks,

	Ingo
