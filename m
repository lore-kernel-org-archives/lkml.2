Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753139Ab1FZKf4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Jun 2011 06:35:56 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:48478 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752932Ab1FZKft (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Jun 2011 06:35:49 -0400
Date: Sun, 26 Jun 2011 12:35:26 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Turner <pjt@google.com>,
        linux-kernel@vger.kernel.org,
        Bharata B Rao <bharata@linux.vnet.ibm.com>,
        Dhaval Giani <dhaval.giani@gmail.com>,
        Balbir Singh <balbir@linux.vnet.ibm.com>,
        Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>,
        Srivatsa Vaddagiri <vatsa@in.ibm.com>,
        Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>,
        Pavel Emelyanov <xemul@openvz.org>
Subject: Re: [patch 00/16] CFS Bandwidth Control v7
Message-ID: <20110626103526.GA11093@elte.hu>
References: <20110621071649.862846205@google.com>
 <4E01BE6B.2090701@jp.fujitsu.com>
 <1308830816.1022.112.camel@twins>
 <20110623124310.GA15430@elte.hu>
 <4E041C6A.4000701@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4E041C6A.4000701@jp.fujitsu.com>
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


* Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com> wrote:

> -        865.139070 task-clock                #    0.468 CPUs utilized            ( +-  0.22% )
> -           200,167 context-switches          #    0.231 M/sec                    ( +-  0.00% )
> -                 0 CPU-migrations            #    0.000 M/sec                    ( +- 49.62% )
> -               142 page-faults               #    0.000 M/sec                    ( +-  0.07% )
> -     1,671,107,623 cycles                    #    1.932 GHz                      ( +-  0.16% ) [28.23%]
> -       838,554,329 stalled-cycles-frontend   #   50.18% frontend cycles idle     ( +-  0.27% ) [28.21%]
> -       453,526,560 stalled-cycles-backend    #   27.14% backend  cycles idle     ( +-  0.43% ) [28.33%]
> -     1,434,140,915 instructions              #    0.86  insns per cycle
> -                                             #    0.58  stalled cycles per insn  ( +-  0.06% ) [34.01%]
> -       279,485,621 branches                  #  323.053 M/sec                    ( +-  0.06% ) [33.98%]
> -         6,653,998 branch-misses             #    2.38% of all branches          ( +-  0.16% ) [33.93%]
> -       495,463,378 L1-dcache-loads           #  572.698 M/sec                    ( +-  0.05% ) [28.12%]
> -        27,903,270 L1-dcache-load-misses     #    5.63% of all L1-dcache hits    ( +-  0.28% ) [27.84%]
> -           885,210 LLC-loads                 #    1.023 M/sec                    ( +-  3.21% ) [21.80%]
> -             9,479 LLC-load-misses           #    1.07% of all LL-cache hits     ( +-  0.63% ) [ 5.61%]
> -       830,096,007 L1-icache-loads           #  959.494 M/sec                    ( +-  0.08% ) [11.18%]
> -       123,728,370 L1-icache-load-misses     #   14.91% of all L1-icache hits    ( +-  0.06% ) [16.78%]
> -       504,932,490 dTLB-loads                #  583.643 M/sec                    ( +-  0.06% ) [22.30%]
> -         2,056,069 dTLB-load-misses          #    0.41% of all dTLB cache hits   ( +-  2.23% ) [22.20%]
> -     1,579,410,083 iTLB-loads                # 1825.614 M/sec                    ( +-  0.06% ) [22.30%]
> -           394,739 iTLB-load-misses          #    0.02% of all iTLB cache hits   ( +-  0.03% ) [22.27%]
> -         2,286,363 L1-dcache-prefetches      #    2.643 M/sec                    ( +-  0.72% ) [22.40%]
> -           776,096 L1-dcache-prefetch-misses #    0.897 M/sec                    ( +-  1.45% ) [22.54%]
> +        859.259725 task-clock                #    0.472 CPUs utilized            ( +-  0.24% )
> +           200,165 context-switches          #    0.233 M/sec                    ( +-  0.00% )
> +                 0 CPU-migrations            #    0.000 M/sec                    ( +-100.00% )
> +               142 page-faults               #    0.000 M/sec                    ( +-  0.06% )
> +     1,659,371,974 cycles                    #    1.931 GHz                      ( +-  0.18% ) [28.23%]
> +       829,806,955 stalled-cycles-frontend   #   50.01% frontend cycles idle     ( +-  0.32% ) [28.32%]
> +       490,316,435 stalled-cycles-backend    #   29.55% backend  cycles idle     ( +-  0.46% ) [28.34%]
> +     1,445,166,061 instructions              #    0.87  insns per cycle
> +                                             #    0.57  stalled cycles per insn  ( +-  0.06% ) [34.01%]
> +       282,370,988 branches                  #  328.621 M/sec                    ( +-  0.06% ) [33.93%]
> +         5,056,568 branch-misses             #    1.79% of all branches          ( +-  0.19% ) [33.94%]
> +       500,660,789 L1-dcache-loads           #  582.665 M/sec                    ( +-  0.06% ) [28.05%]
> +        26,802,313 L1-dcache-load-misses     #    5.35% of all L1-dcache hits    ( +-  0.26% ) [27.83%]
> +           872,571 LLC-loads                 #    1.015 M/sec                    ( +-  3.73% ) [21.82%]
> +             9,050 LLC-load-misses           #    1.04% of all LL-cache hits     ( +-  0.55% ) [ 5.70%]
> +       794,396,111 L1-icache-loads           #  924.512 M/sec                    ( +-  0.06% ) [11.30%]
> +       130,179,414 L1-icache-load-misses     #   16.39% of all L1-icache hits    ( +-  0.09% ) [16.85%]
> +       511,119,889 dTLB-loads                #  594.837 M/sec                    ( +-  0.06% ) [22.37%]
> +         2,452,378 dTLB-load-misses          #    0.48% of all dTLB cache hits   ( +-  2.31% ) [22.14%]
> +     1,597,897,243 iTLB-loads                # 1859.621 M/sec                    ( +-  0.06% ) [22.17%]
> +           394,366 iTLB-load-misses          #    0.02% of all iTLB cache hits   ( +-  0.03% ) [22.24%]
> +         1,897,401 L1-dcache-prefetches      #    2.208 M/sec                    ( +-  0.64% ) [22.38%]
> +           879,391 L1-dcache-prefetch-misses #    1.023 M/sec                    ( +-  0.90% ) [22.54%]
> 
> -       1.847093132 seconds time elapsed                                          ( +-  0.19% )
> +       1.822131534 seconds time elapsed                                          ( +-  0.21% )
> =====
> 
> As Peter have expected, the number of branches is slightly increased.
> 
> -       279,485,621 branches                  #  323.053 M/sec                    ( +-  0.06% ) [33.98%]
> +       282,370,988 branches                  #  328.621 M/sec                    ( +-  0.06% ) [33.93%]
> 
> However, looking overall, I think there is no significant problem on
> the score with this patch set.  I'd love to hear from maintainers.

Yeah, these numbers look pretty good. Note that the percentages in 
the third column (the amount of time that particular event was 
measured) is pretty low, and it would be nice to eliminate it: i.e. 
now that we know the ballpark figures do very precise measurements 
that do not over-commit the PMU.

One such measurement would be:

	-e cycles -e instructions -e branches

This should also bring the stddev percentages down i think, to below 
0.1%.

Another measurement would be to test not just the feature-enabled but 
also the feature-disabled cost - so that we document the rough 
overhead that users of this new scheduler feature should expect.

Organizing it into neat before/after numbers and percentages, 
comparing it with noise (stddev) [i.e. determining that the effect we 
measure is above noise] and putting it all into the changelog would 
be the other goal of these measurements.

Thanks,

	Ingo
