Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753525Ab0CVF2n (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Mar 2010 01:28:43 -0400
Received: from mail.gmx.net ([213.165.64.20]:52111 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752959Ab0CVF2l (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Mar 2010 01:28:41 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX1+HN39I0lCHSycsImjjwgFPaMRYQY8JWNEao/Jhig
	283SNYilYeeU5f
Subject: Re: [Bug #15192] netperf ~50% regression with 2.6.33-rc1, bisect
 to 1b9508f
From: Mike Galbraith <efault@gmx.de>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Maciej Rutecki <maciej.rutecki@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       Lin Ming <ming.m.lin@intel.com>, Peter Zijlstra <peterz@infradead.org>,
       Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
In-Reply-To: <hTwaxgnIZ2O.A.81F.hQopLB@chimera>
References: <QQGfxbJf48H.A.NFD.uNopLB@chimera>
	 <hTwaxgnIZ2O.A.81F.hQopLB@chimera>
Content-Type: text/plain
Date: Mon, 22 Mar 2010 06:28:37 +0100
Message-Id: <1269235717.19079.4.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1.1 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.52000000000000002
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2010-03-21 at 21:30 +0100, Rafael J. Wysocki wrote:
> This message has been generated automatically as a part of a report
> of regressions introduced between 2.6.32 and 2.6.33.
> 
> The following bug entry is on the current list of known regressions
> introduced between 2.6.32 and 2.6.33.  Please verify if it still should
> be listed and let the tracking team know (either way).
> 
> 
> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=15192
> Subject		: netperf ~50% regression with 2.6.33-rc1, bisect to 1b9508f
> Submitter	: Lin Ming <ming.m.lin@intel.com>
> Date		: 2010-01-25 10:03 (56 days old)
> First-Bad-Commit: http://git.kernel.org/git/linus/1b9508f6831e10d53256825de8904caa22d1ca2c
> References	: http://marc.info/?l=linux-kernel&m=126441481427331&w=4
> Handled-By	: Mike Galbraith <efault@gmx.de>
> 		  Peter Zijlstra <peterz@infradead.org>
> 		  Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
> Patch		: http://patchwork.kernel.org/patch/78544/

That patch swam upstream as d306ebc28649b89877a22158fe0076f06cc46f60.

	-Mike

