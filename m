Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753534Ab2BWLya (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Feb 2012 06:54:30 -0500
Received: from e28smtp06.in.ibm.com ([122.248.162.6]:53692 "EHLO
	e28smtp06.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752135Ab2BWLy3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Feb 2012 06:54:29 -0500
Date: Thu, 23 Feb 2012 17:02:24 +0530
From: Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Mike Galbraith <efault@gmx.de>, Peter Zijlstra <peterz@infradead.org>,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Paul Turner <pjt@google.com>
Subject: Re: sched: Avoid SMT siblings in select_idle_sibling() if possible
Message-ID: <20120223113224.GB8454@linux.vnet.ibm.com>
Reply-To: Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>
References: <1321544313.6308.25.camel@marge.simson.net>
 <1321545376.2495.1.camel@laptop>
 <1321547917.6308.48.camel@marge.simson.net>
 <1321551381.15339.21.camel@sbsiddha-desk.sc.intel.com>
 <1321629267.7080.13.camel@marge.simson.net>
 <1329748861.2293.345.camel@twins>
 <1329761661.6276.146.camel@marge.simpson.net>
 <20120223104959.GA8454@linux.vnet.ibm.com>
 <20120223112005.GA7645@linux.vnet.ibm.com>
 <20120223112650.GA23844@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20120223112650.GA23844@elte.hu>
User-Agent: Mutt/1.5.21 (2010-09-15)
x-cbid: 12022311-9574-0000-0000-0000017F1506
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Ingo Molnar <mingo@elte.hu> [2012-02-23 12:26:50]:

> pro perf tip of the day: did you know that it's possible to run:
> 
>   perf stat --repeat 10 --null perf bench sched pipe

Ah yes ..had forgotten that! What is the recommended # of iterations 
to run?

> and get meaningful, normalized stddev calculations for free:
> 
>        5.486491487 seconds time elapsed                                          ( +-  5.50% )
> 
> the percentage at the end shows the level of standard deviation.
> 
> You can add "--sync" as well, which will cause perf stat to call 
> sync() - this gives extra stability of individual iterations and 
> makes sure all IO cost is accounted to the right run.

Ok ..thanks for the 'pro' tip!! Will use it in my subsequent runs!

- vatsa

