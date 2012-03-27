Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754599Ab2C0N4o (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Mar 2012 09:56:44 -0400
Received: from mailout-de.gmx.net ([213.165.64.22]:46659 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754276Ab2C0N4m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Mar 2012 09:56:42 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX19j77Eq14tjl2X+tMk6vlr1pVrS7i4C1c0nWi2OXZ
	8CTulo9UR760Qr
Message-ID: <1332856598.7425.25.camel@marge.simpson.net>
Subject: Re: sched: Avoid SMT siblings in select_idle_sibling() if possible
From: Mike Galbraith <efault@gmx.de>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>, Ingo Molnar <mingo@elte.hu>,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Paul Turner <pjt@google.com>
Date: Tue, 27 Mar 2012 15:56:38 +0200
In-Reply-To: <1332785212.16159.170.camel@twins>
References: <1329764866.2293.376.camhel@twins>
	 <20120305152443.GE26559@linux.vnet.ibm.com>
	 <20120306091410.GD27238@elte.hu>
	 <20120322153205.GA28570@linux.vnet.ibm.com>
	 <1332750960.16159.81.camel@twins>
	 <20120326173533.GA4689@linux.vnet.ibm.com>
	 <1332785212.16159.170.camel@twins>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.1 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-03-26 at 20:06 +0200, Peter Zijlstra wrote:

> The biggest regression came from tbench, wasn't that mostly a random
> number generator anyway?

That's dbench ;-)  Tbench does wiggle around more than you'd like
though.  I've never tracked, but in lots of running the thing, 2-3% you
can forget chasing, and I once bisected a 5% regression to an unrelated
change, reverted and re-applied the suspect a few times in disbelief,
and it tracked.  You can't trust it _too_ much.  I consider it a
reliable indicator that I'd better do more testing.  If others agree,
it's a real regression, if not, it's those damn Elves 'n Gremlins ;-)

-Mike


