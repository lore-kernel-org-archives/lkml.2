Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752824Ab2BUIKF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Feb 2012 03:10:05 -0500
Received: from e23smtp01.au.ibm.com ([202.81.31.143]:36883 "EHLO
	e23smtp01.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751307Ab2BUIKD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Feb 2012 03:10:03 -0500
Date: Tue, 21 Feb 2012 13:39:54 +0530
From: Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>
To: Mike Galbraith <efault@gmx.de>
Cc: Peter Zijlstra <peterz@infradead.org>,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@elte.hu>, Paul Turner <pjt@google.com>
Subject: Re: sched: Avoid SMT siblings in select_idle_sibling() if possible
Message-ID: <20120221080954.GJ2350@linux.vnet.ibm.com>
Reply-To: Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>
References: <1321544313.6308.25.camel@marge.simson.net>
 <1321545376.2495.1.camel@laptop>
 <1321547917.6308.48.camel@marge.simson.net>
 <1321551381.15339.21.camel@sbsiddha-desk.sc.intel.com>
 <1321629267.7080.13.camel@marge.simson.net>
 <1329748861.2293.345.camel@twins>
 <20120220150348.GC2350@linux.vnet.ibm.com>
 <1329762343.6276.156.camel@marge.simpson.net>
 <20120221000622.GH2350@linux.vnet.ibm.com>
 <1329806234.7333.16.camel@marge.simpson.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <1329806234.7333.16.camel@marge.simpson.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
x-cbid: 12022022-1618-0000-0000-000000DAC44D
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Mike Galbraith <efault@gmx.de> [2012-02-21 07:37:14]:

> On Tue, 2012-02-21 at 05:36 +0530, Srivatsa Vaddagiri wrote:
> 
> > fwiw the patch I had sent does a wakeup balance within prev_cpu's
> > cache_domain (and not outside).
> 
> Yeah, the testing I did was turn on the flag, and measure.  With single
> domain scans, maybe select_idle_sibling() could just go away.

Yeah that's what I was thinking. Essentially find_idlest_group/cpu
should accomplish that job pretty much for us ...

> It ain't free either.

Will find out how much difference it makes ..

- vatsa

