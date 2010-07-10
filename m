Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752284Ab0GJUpr (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Jul 2010 16:45:47 -0400
Received: from mail.openrapids.net ([64.15.138.104]:37948 "EHLO
	blackscsi.openrapids.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751158Ab0GJUpp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Jul 2010 16:45:45 -0400
Date: Sat, 10 Jul 2010 16:45:42 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To: Maciej Rutecki <maciej.rutecki@gmail.com>
Cc: mingo@elte.hu, linux-kernel@vger.kernel.org, Ma Ling <ling.ma@intel.com>,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [BUG -tip bisected] x86, mem: Optimize memcpy by avoiding
	memory false dependece
Message-ID: <20100710204542.GA13334@Krystal>
References: <20100707220325.GA27738@Krystal> <201007102156.30347.maciej.rutecki@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201007102156.30347.maciej.rutecki@gmail.com>
X-Editor: vi
X-Info: http://www.efficios.com
X-Operating-System: Linux/2.6.26-2-686 (i686)
X-Uptime: 16:44:32 up 168 days, 23:21,  5 users,  load average: 0.10, 0.04,
	0.01
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Maciej Rutecki (maciej.rutecki@gmail.com) wrote:
> On czwartek, 8 lipca 2010 o 00:03:25 Mathieu Desnoyers wrote:
> > Hi Ingo,
> > 
> > I just bisected the cause of boot hard lockup on my Intel Xeon E5405 to
> > this commit recently added to -tip:
> > 
> > a1e5278e40f16a4611264f8da9e557c16cb6f6ed is the first bad commit
> > Merge branch 'x86/mem'
> > 
> 
> I created a Bugzilla entry at 
> https://bugzilla.kernel.org/show_bug.cgi?id=16364
> for your bug report, please add your address to the CC list in there, thanks!

This bug report is incorrect. The problem does not affect mainline, as I caught
it in -tip and it has been reverted before it's been pulled into Linus tree.

Thanks,

Mathieu


-- 
Mathieu Desnoyers
Operating System Efficiency R&D Consultant
EfficiOS Inc.
http://www.efficios.com
