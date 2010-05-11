Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933318Ab0EKHH1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 May 2010 03:07:27 -0400
Received: from mga03.intel.com ([143.182.124.21]:30804 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753967Ab0EKHH0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 May 2010 03:07:26 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.53,206,1272870000"; 
   d="scan'208";a="275641503"
Subject: Re: [rfc] x86,perf: P4 PMU -- use hash for p4_get_escr_idx
From: Lin Ming <ming.m.lin@intel.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Cyrill Gorcunov <gorcunov@gmail.com>, LKML <linux-kernel@vger.kernel.org>,
       Peter Zijlstra <peterz@infradead.org>,
       Steven Rostedt <rostedt@goodmis.org>,
       Frederic Weisbecker <fweisbec@gmail.com>
In-Reply-To: <1273560424.30322.13.camel@minggr.sh.intel.com>
References: <20100510152708.GS5104@lenovo>
	 <1273558879.30322.8.camel@minggr.sh.intel.com>
	 <20100511063047.GA24365@elte.hu>  <20100511064144.GA29063@elte.hu>
	 <1273560424.30322.13.camel@minggr.sh.intel.com>
Content-Type: text/plain
Date: Tue, 11 May 2010 15:06:46 +0800
Message-Id: <1273561606.30322.17.camel@minggr.sh.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1 (2.24.1-2.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-05-11 at 14:47 +0800, Lin Ming wrote:
> On Tue, 2010-05-11 at 14:41 +0800, Ingo Molnar wrote:
> > * Ingo Molnar <mingo@elte.hu> wrote:
> > 
> > > 
> > > * Lin Ming <ming.m.lin@intel.com> wrote:
> > > 
> > > > On Mon, 2010-05-10 at 23:27 +0800, Cyrill Gorcunov wrote:
> > > > > Hi Ming,
> > > > > 
> > > > > could you give this patch a shot if possible? Compile
> > > > > tested only. I would appreciate review and complains
> > > > > as well :) I know you're busy with other perf task
> > > > > so there is no hurry. Just to share the patch as early
> > > > > as possible.
> > > > 
> > > > Hi, 
> > > > 
> > > > I'm going to test this patch, but current tip/master(c6661c5) seems has
> > > > problem.
> > > 
> > > Does reverting 4fd38e4595e2f6c9d27732c042a0e16b2753049c help?
> > 
> > If not then it would be nice if you could try to do a bisection.
> 
> Yes, it's the commit 4fd38e45 causes the regression.

Cyrill,

After reverting commit 4fd38e45, this patch works well.

Lin Ming

