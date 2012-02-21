Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751862Ab2BUGhU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Feb 2012 01:37:20 -0500
Received: from mailout-de.gmx.net ([213.165.64.22]:56940 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1750804Ab2BUGhS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Feb 2012 01:37:18 -0500
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX19/DCQnK91/LHI9PcDAAlocWrRasrFJ5HE5yG6y7J
	Pwo5+7jLDNsi8m
Message-ID: <1329806234.7333.16.camel@marge.simpson.net>
Subject: Re: sched: Avoid SMT siblings in select_idle_sibling() if possible
From: Mike Galbraith <efault@gmx.de>
To: Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>
Cc: Peter Zijlstra <peterz@infradead.org>,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@elte.hu>, Paul Turner <pjt@google.com>
Date: Tue, 21 Feb 2012 07:37:14 +0100
In-Reply-To: <20120221000622.GH2350@linux.vnet.ibm.com>
References: <1321468646.11680.2.camel@sbsiddha-desk.sc.intel.com>
	 <1321495153.5100.7.camel@marge.simson.net>
	 <1321544313.6308.25.camel@marge.simson.net>
	 <1321545376.2495.1.camel@laptop>
	 <1321547917.6308.48.camel@marge.simson.net>
	 <1321551381.15339.21.camel@sbsiddha-desk.sc.intel.com>
	 <1321629267.7080.13.camel@marge.simson.net>
	 <1329748861.2293.345.camel@twins>
	 <20120220150348.GC2350@linux.vnet.ibm.com>
	 <1329762343.6276.156.camel@marge.simpson.net>
	 <20120221000622.GH2350@linux.vnet.ibm.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.1 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-02-21 at 05:36 +0530, Srivatsa Vaddagiri wrote:

> fwiw the patch I had sent does a wakeup balance within prev_cpu's
> cache_domain (and not outside).

Yeah, the testing I did was turn on the flag, and measure.  With single
domain scans, maybe select_idle_sibling() could just go away.  It ain't
free either.

-Mike

