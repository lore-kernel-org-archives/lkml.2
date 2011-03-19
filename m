Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757586Ab1CSU5L (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Mar 2011 16:57:11 -0400
Received: from smtp2.it.da.ut.ee ([193.40.5.67]:36016 "EHLO smtp2.it.da.ut.ee"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757493Ab1CSU5K (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Mar 2011 16:57:10 -0400
Date: Sat, 19 Mar 2011 22:57:08 +0200 (EET)
From: Meelis Roos <mroos@linux.ee>
To: Darren Hart <dvhart@linux.intel.com>
cc: David Miller <davem@davemloft.net>, clem@clem.clem-digital.net,
        Linux Kernel list <linux-kernel@vger.kernel.org>,
        sparclinux@vger.kernel.org
Subject: Re: 38-git2-6 -- kernel/futex.c warning
In-Reply-To: <4D847191.7000806@linux.intel.com>
Message-ID: <alpine.SOC.1.00.1103192255440.4548@math.ut.ee>
References: <201103181932.p2IJW5cg002394@clem.clem-digital.net> <20110318.125808.233714688.davem@davemloft.net> <4D847191.7000806@linux.intel.com>
User-Agent: Alpine 1.00 (SOC 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > > Fyi. Have been experiencing the below since 38-git2. Continual scrolling
> > > such that cannot complete system startup. System is i386 UP, Debian
> > > "squeeze".
> > 
> > Looks similar to the problems reported by Meelis, CC:'d
> 
> yes, and the same answer, see Steven Rostedts patch set from March 17th:
> 
> [PATCH 0/2 v2] [GIT PULL] futex: Fix WARN_ON trigging on UP

And applying both his patches on top of 2.6.38-06439-g5bab188 fixed the 
problem for me.

-- 
Meelis Roos (mroos@linux.ee)
