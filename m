Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753243Ab1KRRms (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Nov 2011 12:42:48 -0500
Received: from mailout-de.gmx.net ([213.165.64.23]:49395 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1750949Ab1KRRmr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Nov 2011 12:42:47 -0500
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX1+dOLhqAxOd8ECm+TshotEbfN/jmjZvUMj9Zqka1I
	Qh6ZJL93JwPhRx
Subject: Re: [patch 3/6] sched: use rq->avg_event to resurrect nohz
 ratelimiting
From: Mike Galbraith <efault@gmx.de>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Suresh Siddha <suresh.b.siddha@intel.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@elte.hu>, Paul Turner <pjt@google.com>,
        "Van De Ven, Arjan" <arjan.van.de.ven@intel.com>
In-Reply-To: <1321630619.2197.16.camel@twins>
References: <1321350377.1421.55.camel@twins>
	 <1321406062.16760.60.camel@sbsiddha-desk.sc.intel.com>
	 <1321435455.5072.64.camel@marge.simson.net>
	 <1321468646.11680.2.camel@sbsiddha-desk.sc.intel.com>
	 <1321495153.5100.7.camel@marge.simson.net>
	 <1321544313.6308.25.camel@marge.simson.net>
	 <1321545376.2495.1.camel@laptop>
	 <1321547917.6308.48.camel@marge.simson.net>
	 <1321551381.15339.21.camel@sbsiddha-desk.sc.intel.com>
	 <1321629267.7080.13.camel@marge.simson.net>
	 <1321629562.7080.17.camel@marge.simson.net>
	 <1321630619.2197.16.camel@twins>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 18 Nov 2011 18:42:26 +0100
Message-ID: <1321638146.6238.20.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.1 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-11-18 at 16:36 +0100, Peter Zijlstra wrote:
> On Fri, 2011-11-18 at 16:19 +0100, Mike Galbraith wrote:
> > Entering nohz at high frequency eats cycles, ratelimit it
> > just as we do idle_balance(), and for the same reason.
> > 
> > Signed-off-by: Mike Galbraith <efault@gmx.de>
> 
> Arjan, can we do something smart with the idle governor which already
> guestimates the idle duration for us?

That would be great.  Won't help my Intel Q6600 though, the intel_idle
governor doesn't support it.  Other idle_governor gizmos really need to
get smarter too.

	-Mike

