Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754475Ab2BUKhe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Feb 2012 05:37:34 -0500
Received: from casper.infradead.org ([85.118.1.10]:35927 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754362Ab2BUKhd convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Feb 2012 05:37:33 -0500
Message-ID: <1329820643.2293.386.camel@twins>
Subject: Re: sched: Avoid SMT siblings in select_idle_sibling() if possible
From: Peter Zijlstra <peterz@infradead.org>
To: Mike Galbraith <efault@gmx.de>
Cc: Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@elte.hu>, Paul Turner <pjt@google.com>
Date: Tue, 21 Feb 2012 11:37:23 +0100
In-Reply-To: <1329816093.7333.49.camel@marge.simpson.net>
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
	 <20120221083241.GC5156@linux.vnet.ibm.com>
	 <1329816093.7333.49.camel@marge.simpson.net>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-02-21 at 10:21 +0100, Mike Galbraith wrote:

> I use vmark, find it _somewhat_ useful.  Not a lovely benchmark, but it
> is highly affinity sensitive, and switches heftily.  I don't put much
> value on it though, too extreme for me, but it is a ~decent indicator.
> 
> There are no doubt _lots_ better than vmark for java stuff.
> 
> I toss a variety pack at the box in obsessive-compulsive man mode when
> testing.  Which benchmarks doesn't matter much, just need to be wide
> spectrum and consistent.

http://www.volano.com/benchmarks.html

> No, I use Ingo's pipe-test, but that to measure fastpath overhead.

http://people.redhat.com/mingo/cfs-scheduler/tools/pipe-test.c

Also I think it lives as: perf bench sched pipe
