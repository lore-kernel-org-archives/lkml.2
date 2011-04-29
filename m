Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758290Ab1D2C23 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Apr 2011 22:28:29 -0400
Received: from mga09.intel.com ([134.134.136.24]:29243 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756940Ab1D2C22 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Apr 2011 22:28:28 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.64,284,1301900400"; 
   d="scan'208";a="739989262"
Date: Thu, 28 Apr 2011 19:28:19 -0700
From: Andi Kleen <ak@linux.intel.com>
To: Vince Weaver <vweaver1@eecs.utk.edu>
Cc: Ingo Molnar <mingo@elte.hu>, Arnaldo Carvalho de Melo <acme@infradead.org>,
        linux-kernel@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@gmail.com>, Lin Ming <ming.m.lin@intel.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [PATCH 1/1] perf tools: Add missing user space support for
 config1/config2
Message-ID: <20110429022819.GA6750@alboin.amr.corp.intel.com>
References: <1303407662-15564-2-git-send-email-acme@infradead.org>
 <20110422063429.GA16643@elte.hu>
 <20110422080604.GA22611@elte.hu>
 <alpine.DEB.2.00.1104251307010.12389@cl320.eecs.utk.edu>
 <20110425175444.GC28239@elte.hu>
 <alpine.DEB.2.00.1104251736220.12389@cl320.eecs.utk.edu>
 <20110426073847.GB30630@elte.hu>
 <alpine.DEB.2.00.1104261648400.32482@cl320.eecs.utk.edu>
 <20110427065241.GF17079@elte.hu>
 <alpine.DEB.2.00.1104281811400.25779@cl320.eecs.utk.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.1104281811400.25779@cl320.eecs.utk.edu>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> I know it is fun to reinvent the wheel, but you ignored decades of 
> experience in dealing with perf-counters when you ran off and invented 
> perf_events.  It will bite you eventually.

s/eventually//

A good example for that is  perf events counted completely bogus LLC 
generalized cache events for several releases (before the offcore patches 
went in).

And BTW they now completely changed again with Peter's changed, counting
something quite different.

-Andi
