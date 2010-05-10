Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756344Ab0EJUBN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 May 2010 16:01:13 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:38816 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756066Ab0EJUBK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 May 2010 16:01:10 -0400
Subject: Re: [RFC][PATCH 5/9] perf: arm, convert to new API pmu->init_event
From: Will Deacon <will.deacon@arm.com>
To: Lin Ming <ming.m.lin@intel.com>
Cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
       Frederic Weisbecker <fweisbec@gmail.com>, eranian@gmail.com,
       "Gary.Mohr@Bull.com" <Gary.Mohr@bull.com>,
       Corey Ashford <cjashfor@linux.vnet.ibm.com>, arjan@linux.intel.com,
       "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>,
       Paul Mackerras <paulus@samba.org>,
       "David S. Miller" <davem@davemloft.net>,
       Russell King <rmk+kernel@arm.linux.org.uk>,
       Paul Mundt <lethal@linux-sh.org>, lkml <linux-kernel@vger.kernel.org>
In-Reply-To: <1273485637.15998.67.camel@minggr.sh.intel.com>
References: <1273483672.15998.59.camel@minggr.sh.intel.com>
	 <1273485637.15998.67.camel@minggr.sh.intel.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 10 May 2010 21:01:02 +0100
Message-ID: <1273521662.25588.9.camel@e200755-lin.cambridge.arm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 10 May 2010 20:01:07.0825 (UTC) FILETIME=[877D2610:01CAF07B]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Lin [thanks to Russell for the CC],

On Mon, 2010-05-10 at 11:00 +0100, Lin Ming wrote:
> On Mon, 2010-05-10 at 17:27 +0800, Lin Ming wrote:
> > perf: arm, convert to new API pmu->init_event
> >
> > Signed-off-by: Lin Ming <ming.m.lin@intel.com>
> > ---
> >  arch/arm/kernel/perf_event.c |   28 +++++++++++++++-------------
> >  1 files changed, 15 insertions(+), 13 deletions(-)
> >
 
--------8<--------

The changes I've made to perf_event.c that result in conflicts
with this patch shouldn't cause you any trouble. If you rebase
the patch then everything should work as expected. Please CC me
when you submit the next iteration.

Cheers,

Will

