Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757061Ab0EKGbc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 May 2010 02:31:32 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:37202 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756916Ab0EKGba (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 May 2010 02:31:30 -0400
Date: Tue, 11 May 2010 08:30:47 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Lin Ming <ming.m.lin@intel.com>
Cc: Cyrill Gorcunov <gorcunov@gmail.com>, LKML <linux-kernel@vger.kernel.org>,
       Peter Zijlstra <peterz@infradead.org>,
       Steven Rostedt <rostedt@goodmis.org>,
       Frederic Weisbecker <fweisbec@gmail.com>
Subject: Re: [rfc] x86,perf: P4 PMU -- use hash for p4_get_escr_idx
Message-ID: <20100511063047.GA24365@elte.hu>
References: <20100510152708.GS5104@lenovo>
 <1273558879.30322.8.camel@minggr.sh.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1273558879.30322.8.camel@minggr.sh.intel.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Lin Ming <ming.m.lin@intel.com> wrote:

> On Mon, 2010-05-10 at 23:27 +0800, Cyrill Gorcunov wrote:
> > Hi Ming,
> > 
> > could you give this patch a shot if possible? Compile
> > tested only. I would appreciate review and complains
> > as well :) I know you're busy with other perf task
> > so there is no hurry. Just to share the patch as early
> > as possible.
> 
> Hi, 
> 
> I'm going to test this patch, but current tip/master(c6661c5) seems has
> problem.

Does reverting 4fd38e4595e2f6c9d27732c042a0e16b2753049c help?

	Ingo
