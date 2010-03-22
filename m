Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754157Ab0CVGl4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Mar 2010 02:41:56 -0400
Received: from mail.gmx.net ([213.165.64.20]:36557 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751538Ab0CVGly (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Mar 2010 02:41:54 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX18yZfAHz44yOZqL0k6RV1GCAfX+s3RgIXILlLzWCo
	NWCC1okjVL3qSK
Subject: Re: [Bug #14950] tbench regression with 2.6.33-rc1
From: Mike Galbraith <efault@gmx.de>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Maciej Rutecki <maciej.rutecki@gmail.com>,
       Lin Ming <ming.m.lin@intel.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>
In-Reply-To: <hTwaxgnIZ2O.A.jSG.TTopLB@chimera>
References: <QQGfxbJf48H.A.NFD.uNopLB@chimera>
	 <hTwaxgnIZ2O.A.jSG.TTopLB@chimera>
Content-Type: text/plain
Date: Mon, 22 Mar 2010 07:41:50 +0100
Message-Id: <1269240110.13618.26.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1.1 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.51000000000000001
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
> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=14950
> Subject		: tbench regression with 2.6.33-rc1
> Submitter	: Lin Ming <ming.m.lin@intel.com>
> Date		: 2009-12-25 11:11 (87 days old)
> References	: http://marc.info/?l=linux-kernel&m=126174044213172&w=4

This needs retest in tip.  I submitted some patchlets to shave a few
cycles, with which my box (fwtw) shows zero regression 2.6.31 ->
tip.today, whereas there was nothing but regression of up to ~6% in
between, magnitude seemingly depending on phase-of-moon.  Actually,
patched tip at submission time was a fraction above 31 throughput.
Retesting today, it's a fraction of a percent below again (tbench is
annoyingly jittery).

Hopefully, this tbench regression is on it's way to retirement.

	-Mike

