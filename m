Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756540Ab0CVVbO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Mar 2010 17:31:14 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:36571 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754693Ab0CVVbM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Mar 2010 17:31:12 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Mike Galbraith <efault@gmx.de>
Subject: Re: [Bug #14950] tbench regression with 2.6.33-rc1
Date: Mon, 22 Mar 2010 22:34:19 +0100
User-Agent: KMail/1.12.4 (Linux/2.6.34-rc2-rjw; KDE/4.3.5; x86_64; ; )
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Maciej Rutecki <maciej.rutecki@gmail.com>,
       Lin Ming <ming.m.lin@intel.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>
References: <QQGfxbJf48H.A.NFD.uNopLB@chimera> <hTwaxgnIZ2O.A.jSG.TTopLB@chimera> <1269240110.13618.26.camel@marge.simson.net>
In-Reply-To: <1269240110.13618.26.camel@marge.simson.net>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Message-Id: <201003222234.19722.rjw@sisk.pl>
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
> > Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=14950
> > Subject		: tbench regression with 2.6.33-rc1
> > Submitter	: Lin Ming <ming.m.lin@intel.com>
> > Date		: 2009-12-25 11:11 (87 days old)
> > References	: http://marc.info/?l=linux-kernel&m=126174044213172&w=4
> 
> This needs retest in tip.  I submitted some patchlets to shave a few
> cycles, with which my box (fwtw) shows zero regression 2.6.31 ->
> tip.today, whereas there was nothing but regression of up to ~6% in
> between, magnitude seemingly depending on phase-of-moon.  Actually,
> patched tip at submission time was a fraction above 31 throughput.
> Retesting today, it's a fraction of a percent below again (tbench is
> annoyingly jittery).
> 
> Hopefully, this tbench regression is on it's way to retirement.

Thanks for the update.

Rafael
