Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752863Ab0KEB3k (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Nov 2010 21:29:40 -0400
Received: from mga02.intel.com ([134.134.136.20]:34979 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752559Ab0KEB3h (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Nov 2010 21:29:37 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.58,299,1286175600"; 
   d="scan'208";a="674515324"
Subject: Re: [DRAFT PATCH 2/3] perf: Implement Nehalem uncore pmu
From: Lin Ming <ming.m.lin@intel.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Stephane Eranian <eranian@google.com>, Ingo Molnar <mingo@redhat.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Arjan van de Ven <arjan@infradead.org>,
        "robert.richter@amd.com" <robert.richter@amd.com>,
        Cyrill Gorcunov <gorcunov@gmail.com>,
        "paulus@samba.org" <paulus@samba.org>,
        Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        lkml <linux-kernel@vger.kernel.org>
In-Reply-To: <1288898929.2039.78.camel@laptop>
References: <1288682905.12061.109.camel@minggr.sh.intel.com>
	 <AANLkTimyTYNczZqV5gPmKfL6iYjNf3wpYYFi+5US8bP3@mail.gmail.com>
	 <1288712023.2457.25.camel@localhost>
	 <AANLkTi=GVVWxOpZ9Gorn4_r2tASAqOV5+BT7o92xrwJJ@mail.gmail.com>
	 <1288898929.2039.78.camel@laptop>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 05 Nov 2010 09:30:29 +0800
Message-ID: <1288920629.2430.0.camel@minggr.sh.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-11-05 at 03:28 +0800, Peter Zijlstra wrote:
> On Tue, 2010-11-02 at 17:59 +0100, Stephane Eranian wrote:
> > I think using uncore PMU to measure per-thread is pretty much useless.
> > Maybe it should not even be allowed. There is no way you can correlate
> > the counts you're getting to a place in your program. Or put differently,
> > sampling in per-thread mode using uncore is useless. 
> 
> Right, per-task uncore event should not be allowed. I think it as simple
> as setting pmu::task_ctx_nr = perf_invalid_context.

Thanks for the comments from you and Stephane.
I'll update the patches.

Lin Ming


