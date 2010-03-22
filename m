Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756520Ab0CVVaB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Mar 2010 17:30:01 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:36551 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754552Ab0CVVaA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Mar 2010 17:30:00 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Mike Galbraith <efault@gmx.de>
Subject: Re: [Bug #15192] netperf ~50% regression with 2.6.33-rc1, bisect to 1b9508f
Date: Mon, 22 Mar 2010 22:33:06 +0100
User-Agent: KMail/1.12.4 (Linux/2.6.34-rc2-rjw; KDE/4.3.5; x86_64; ; )
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Maciej Rutecki <maciej.rutecki@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       Lin Ming <ming.m.lin@intel.com>, Peter Zijlstra <peterz@infradead.org>,
       Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
References: <QQGfxbJf48H.A.NFD.uNopLB@chimera> <hTwaxgnIZ2O.A.81F.hQopLB@chimera> <1269235717.19079.4.camel@marge.simson.net>
In-Reply-To: <1269235717.19079.4.camel@marge.simson.net>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Message-Id: <201003222233.07010.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 22 March 2010, Mike Galbraith wrote:
> On Sun, 2010-03-21 at 21:30 +0100, Rafael J. Wysocki wrote:
> > This message has been generated automatically as a part of a report
> > of regressions introduced between 2.6.32 and 2.6.33.
> > 
> > The following bug entry is on the current list of known regressions
> > introduced between 2.6.32 and 2.6.33.  Please verify if it still should
> > be listed and let the tracking team know (either way).
> > 
> > 
> > Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=15192
> > Subject		: netperf ~50% regression with 2.6.33-rc1, bisect to 1b9508f
> > Submitter	: Lin Ming <ming.m.lin@intel.com>
> > Date		: 2010-01-25 10:03 (56 days old)
> > First-Bad-Commit: http://git.kernel.org/git/linus/1b9508f6831e10d53256825de8904caa22d1ca2c
> > References	: http://marc.info/?l=linux-kernel&m=126441481427331&w=4
> > Handled-By	: Mike Galbraith <efault@gmx.de>
> > 		  Peter Zijlstra <peterz@infradead.org>
> > 		  Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
> > Patch		: http://patchwork.kernel.org/patch/78544/
> 
> That patch swam upstream as d306ebc28649b89877a22158fe0076f06cc46f60.

Thanks, closed.

Rafael
