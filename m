Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753051Ab2BUIcy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Feb 2012 03:32:54 -0500
Received: from e23smtp07.au.ibm.com ([202.81.31.140]:36893 "EHLO
	e23smtp07.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752299Ab2BUIcx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Feb 2012 03:32:53 -0500
Date: Tue, 21 Feb 2012 14:02:41 +0530
From: Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>
To: Mike Galbraith <efault@gmx.de>
Cc: Peter Zijlstra <peterz@infradead.org>,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@elte.hu>, Paul Turner <pjt@google.com>
Subject: Re: sched: Avoid SMT siblings in select_idle_sibling() if possible
Message-ID: <20120221083241.GC5156@linux.vnet.ibm.com>
Reply-To: Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>
References: <1321495153.5100.7.camel@marge.simson.net>
 <1321544313.6308.25.camel@marge.simson.net>
 <1321545376.2495.1.camel@laptop>
 <1321547917.6308.48.camel@marge.simson.net>
 <1321551381.15339.21.camel@sbsiddha-desk.sc.intel.com>
 <1321629267.7080.13.camel@marge.simson.net>
 <1329748861.2293.345.camel@twins>
 <1329761661.6276.146.camel@marge.simpson.net>
 <1329764866.2293.376.camel@twins>
 <1329802998.7333.1.camel@marge.simpson.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <1329802998.7333.1.camel@marge.simpson.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
x-cbid: 12022022-0260-0000-0000-0000009248EA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Mike Galbraith <efault@gmx.de> [2012-02-21 06:43:18]:

> On Mon, 2012-02-20 at 20:07 +0100, Peter Zijlstra wrote: 
> > On Mon, 2012-02-20 at 19:14 +0100, Mike Galbraith wrote:
> > > Enabling SD_BALANCE_WAKE used to be decidedly too expensive to consider.
> > > Maybe that has changed, but I doubt it.
> > 
> > Right, I through I remembered some such, you could see it on wakeup
> > heavy things like pipe-bench and that java msg passing thing, right?
> 
> Yeah, it beat up switch heavy buddies pretty bad.

Do you have pointer to the java benchmark? Also is pipe-bench the same
as the one described below?

http://freecode.com/projects/pipebench

- vatsa

