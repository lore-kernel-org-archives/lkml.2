Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754091Ab0IHN4i (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Sep 2010 09:56:38 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:49540 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751360Ab0IHN4h convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Sep 2010 09:56:37 -0400
Subject: Re: [RFC][PATCH 13/19] perf: Per cpu-context rotation timer
From: Peter Zijlstra <peterz@infradead.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: paulus <paulus@samba.org>, stephane eranian <eranian@googlemail.com>,
        Robert Richter <robert.richter@amd.com>,
        Will Deacon <will.deacon@arm.com>, Paul Mundt <lethal@linux-sh.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Cyrill Gorcunov <gorcunov@gmail.com>, Lin Ming <ming.m.lin@intel.com>,
        Yanmin <yanmin_zhang@linux.intel.com>,
        Deng-Cheng Zhu <dengcheng.zhu@gmail.com>,
        David Miller <davem@davemloft.net>, Ingo Molnar <mingo@elte.hu>,
        linux-kernel@vger.kernel.org,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>
In-Reply-To: <alpine.LFD.2.00.1009081547270.2477@localhost6.localdomain6>
References: <20100907164633.879932949@chello.nl>
	 <20100907165011.939993481@chello.nl> <1283879247.1930.1629.camel@laptop>
	 <alpine.LFD.2.00.1009071932540.2477@localhost6.localdomain6>
	 <1283880975.1930.1662.camel@laptop>
	 <alpine.LFD.2.00.1009081547270.2477@localhost6.localdomain6>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Wed, 08 Sep 2010 15:56:17 +0200
Message-ID: <1283954177.23762.24.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-09-08 at 15:50 +0200, Thomas Gleixner wrote:
> > Because some people (Corey) want to be able to have different rotation
> > periods per pmu driver, so a timer per context was the easy way out.
> 
> Makes sense. If you want it fully aligned with the tick, then you just
> might get the real tick time from the tick code and make it proper
> aligned. 

Right, I'll go see if I can make that work nicely.
