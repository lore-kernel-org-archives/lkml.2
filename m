Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752804Ab2BUFnY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Feb 2012 00:43:24 -0500
Received: from mailout-de.gmx.net ([213.165.64.22]:39166 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751800Ab2BUFnW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Feb 2012 00:43:22 -0500
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX18ab6Y7N30a94CiQEohpb6aRIjHKDQ2SreCzMWE6F
	NG4BZubdL4MoRr
Message-ID: <1329802998.7333.1.camel@marge.simpson.net>
Subject: Re: sched: Avoid SMT siblings in select_idle_sibling() if possible
From: Mike Galbraith <efault@gmx.de>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Suresh Siddha <suresh.b.siddha@intel.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@elte.hu>, Paul Turner <pjt@google.com>,
        Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>
Date: Tue, 21 Feb 2012 06:43:18 +0100
In-Reply-To: <1329764866.2293.376.camel@twins>
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
	 <1329748861.2293.345.camel@twins>
	 <1329761661.6276.146.camel@marge.simpson.net>
	 <1329764866.2293.376.camel@twins>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.1 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-02-20 at 20:07 +0100, Peter Zijlstra wrote: 
> On Mon, 2012-02-20 at 19:14 +0100, Mike Galbraith wrote:
> > Enabling SD_BALANCE_WAKE used to be decidedly too expensive to consider.
> > Maybe that has changed, but I doubt it.
> 
> Right, I through I remembered some such, you could see it on wakeup
> heavy things like pipe-bench and that java msg passing thing, right?

Yeah, it beat up switch heavy buddies pretty bad.

-Mike


