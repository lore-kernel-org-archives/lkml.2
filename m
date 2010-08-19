Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753473Ab0HSONI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Aug 2010 10:13:08 -0400
Received: from mx1.redhat.com ([209.132.183.28]:20399 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751553Ab0HSONH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Aug 2010 10:13:07 -0400
Date: Thu, 19 Aug 2010 10:12:40 -0400
From: Don Zickus <dzickus@redhat.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Robert Richter <robert.richter@amd.com>,
        Cyrill Gorcunov <gorcunov@gmail.com>, Lin Ming <ming.m.lin@intel.com>,
        Ingo Molnar <mingo@elte.hu>, "fweisbec@gmail.com" <fweisbec@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Huang, Ying" <ying.huang@intel.com>, Yinghai Lu <yinghai@kernel.org>,
        Andi Kleen <andi@firstfloor.org>
Subject: Re: [PATCH -v3] perf, x86: try to handle unknown nmis with running
 perfctrs
Message-ID: <20100819141240.GO4879@redhat.com>
References: <20100804161046.GC5130@lenovo>
 <20100804162026.GU3353@redhat.com>
 <20100804163930.GE5130@lenovo>
 <20100804184806.GL26154@erda.amd.com>
 <20100804192634.GG5130@lenovo>
 <20100806065203.GR26154@erda.amd.com>
 <20100806142131.GA1874@redhat.com>
 <20100809194829.GB26154@erda.amd.com>
 <20100817152225.GQ26154@erda.amd.com>
 <1282214753.1926.4669.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1282214753.1926.4669.camel@laptop>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 19, 2010 at 12:45:53PM +0200, Peter Zijlstra wrote:
> 
> I queued it with that part changed to:

I realized the other day this change doesn't cover the nehalem, core and p4
cases which use

intel_pmu_handle_irq
p4_pmu_handle_irq

as their handlers.  Though that patch can go on top of Robert's.

Cheers,
Don
