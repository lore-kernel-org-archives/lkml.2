Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755493Ab2BUO7A (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Feb 2012 09:59:00 -0500
Received: from e28smtp03.in.ibm.com ([122.248.162.3]:46431 "EHLO
	e28smtp03.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755456Ab2BUO67 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Feb 2012 09:58:59 -0500
Date: Tue, 21 Feb 2012 20:28:08 +0530
From: Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Mike Galbraith <efault@gmx.de>, Suresh Siddha <suresh.b.siddha@intel.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@elte.hu>, Paul Turner <pjt@google.com>
Subject: Re: sched: Avoid SMT siblings in select_idle_sibling() if possible
Message-ID: <20120221145808.GC9289@linux.vnet.ibm.com>
Reply-To: Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>
References: <1321547917.6308.48.camel@marge.simson.net>
 <1321551381.15339.21.camel@sbsiddha-desk.sc.intel.com>
 <1321629267.7080.13.camel@marge.simson.net>
 <1329748861.2293.345.camel@twins>
 <1329761661.6276.146.camel@marge.simpson.net>
 <1329764866.2293.376.camel@twins>
 <1329802998.7333.1.camel@marge.simpson.net>
 <20120221083241.GC5156@linux.vnet.ibm.com>
 <1329816093.7333.49.camel@marge.simpson.net>
 <1329820643.2293.386.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <1329820643.2293.386.camel@twins>
User-Agent: Mutt/1.5.21 (2010-09-15)
x-cbid: 12022114-3864-0000-0000-0000017B619B
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Peter Zijlstra <peterz@infradead.org> [2012-02-21 11:37:23]:

> http://www.volano.com/benchmarks.html

For some reason, volanomark stops working (client hangs waiting for data
to arrive on socket) in 3rd iteration when run on latest tip. I don't see that 
with 2.6.32 based kernel though. Checking which commit may have caused
this ..

- vatsa

