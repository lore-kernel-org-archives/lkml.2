Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946127Ab2JYP5q (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2012 11:57:46 -0400
Received: from casper.infradead.org ([85.118.1.10]:55184 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932678Ab2JYP5o convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2012 11:57:44 -0400
Message-ID: <1351180603.12171.31.camel@twins>
Subject: Re: [RFC PATCH 00/13] sched: Integrating Per-entity-load-tracking
 with the core scheduler
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Preeti U Murthy <preeti@linux.vnet.ibm.com>
Cc: svaidy@linux.vnet.ibm.com, linux-kernel@vger.kernel.org, mingo@kernel.org,
        venki@google.com, robin.randhawa@arm.com, linaro-dev@lists.linaro.org,
        mjg59@srcf.ucam.org, viresh.kumar@linaro.org,
        akpm@linux-foundation.org, amit.kucheria@linaro.org,
        deepthi@linux.vnet.ibm.com, paul.mckenney@linaro.org,
        arjan@linux.intel.com, paulmck@linux.vnet.ibm.com,
        srivatsa.bhat@linux.vnet.ibm.com, vincent.guittot@linaro.org,
        tglx@linutronix.de, Arvind.Chauhan@arm.com, pjt@google.com,
        Morten.Rasmussen@arm.com, linux-arm-kernel@lists.infradead.org,
        suresh.b.siddha@intel.com
Date: Thu, 25 Oct 2012 17:56:43 +0200
In-Reply-To: <20121025102045.21022.92489.stgit@preeti.in.ibm.com>
References: <20121025102045.21022.92489.stgit@preeti.in.ibm.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

OK, so I tried reading a few patches and I'm completely failing.. maybe
its late and my brain stopped working, but it simply doesn't make any
sense.

Most changelogs and comments aren't really helping either. At best they
mention what you're doing, not why and how. This means I get to
basically duplicate your entire thought pattern and I might as well do
the patches myself.

I also don't see the 'big' picture of what you're doing, you start out
by some weird avoid short running task movement.. why is that a good
start?

I would have expected a series like this to replace rq->cpu_load /
rq->load with a saner metric and go from there.. instead it looks like
its going about at things completely backwards. Fixing small details
instead of the big things.

Do explain..
