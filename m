Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751250Ab0HPJMX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Aug 2010 05:12:23 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:38554 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752812Ab0HPJMP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Aug 2010 05:12:15 -0400
Subject: Re: perf, how to support multiple x86 hw pmus?
From: Peter Zijlstra <peterz@infradead.org>
To: Lin Ming <ming.m.lin@intel.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@elte.hu>, Robert Richter <robert.richter@amd.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Don Zickus <dzickus@redhat.com>, Cyrill Gorcunov <gorcunov@gmail.com>,
        "arjan@linux.intel.com" <arjan@linux.intel.com>,
        "Fu, Michael" <michael.fu@intel.com>
In-Reply-To: <1281947959.6555.56.camel@minggr.sh.intel.com>
References: <1281946154.6555.46.camel@minggr.sh.intel.com>
	 <1281947113.1926.1004.camel@laptop>
	 <1281947959.6555.56.camel@minggr.sh.intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Mon, 16 Aug 2010 11:12:05 +0200
Message-ID: <1281949925.1926.1081.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-08-16 at 16:39 +0800, Lin Ming wrote:
> > After that and some patches adding per pmu contexts adding multiple
> > hardware pmus should be simple.
> 
> I didn't see the per pmu contexts patches, are you still working on
> them?
> 
Yes, although 3 weeks of holidays and a week of LinuxCon didn't help to
finish that work ;-)

I hope to be back to that soon ;-)

> > 
> > uncore should not share any code with the regular pmu, since they're
> > mostly unrelated.
> 
> But should they share code like collect_events, schedule_events,
> x86_perf_event_set_period(with some modification) etc...?
> 
Maybe, I'd have to look at the uncore stuff again, I can't remember if
it has much in the way of event scheduling constraints and if the
counter programming is close enough to the regular pmu to make it worth
sharing code over.


