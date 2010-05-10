Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756027Ab0EJJkC (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 May 2010 05:40:02 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:46131 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756013Ab0EJJjz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 May 2010 05:39:55 -0400
Date: Mon, 10 May 2010 10:38:05 +0100
From: Russell King <rmk@arm.linux.org.uk>
To: Lin Ming <ming.m.lin@intel.com>
Cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       "eranian@gmail.com" <eranian@gmail.com>,
       "Gary.Mohr@Bull.com" <Gary.Mohr@bull.com>,
       Corey Ashford <cjashfor@linux.vnet.ibm.com>,
       "arjan@linux.intel.com" <arjan@linux.intel.com>,
       "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>,
       Paul Mackerras <paulus@samba.org>,
       "David S. Miller" <davem@davemloft.net>,
       Paul Mundt <lethal@linux-sh.org>, lkml <linux-kernel@vger.kernel.org>
Subject: Re: [RFC][PATCH 5/9] perf: arm, convert to new API pmu->init_event
Message-ID: <20100510093805.GB11675@flint.arm.linux.org.uk>
References: <1273483672.15998.59.camel@minggr.sh.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1273483672.15998.59.camel@minggr.sh.intel.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 10, 2010 at 05:27:52PM +0800, Lin Ming wrote:
> perf: arm, convert to new API pmu->init_event

Unfortunately, this seems to clash with a rework of the ARM PMU/oprofile
code.  You also really need to copy the guys doing this work, eg the
authors of arch/arm/kernel/perf_event.c - Will Deacon.

-- 
Russell King
 Linux kernel    2.6 ARM Linux   - http://www.arm.linux.org.uk/
 maintainer of:
