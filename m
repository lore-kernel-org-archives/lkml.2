Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756869Ab0EJLk5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 May 2010 07:40:57 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:34212 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756825Ab0EJLkz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 May 2010 07:40:55 -0400
Date: Mon, 10 May 2010 12:39:30 +0100
From: Russell King <rmk@arm.linux.org.uk>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Lin Ming <ming.m.lin@intel.com>, Ingo Molnar <mingo@elte.hu>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       "eranian@gmail.com" <eranian@gmail.com>,
       "Gary.Mohr@Bull.com" <Gary.Mohr@bull.com>,
       Corey Ashford <cjashfor@linux.vnet.ibm.com>,
       "arjan@linux.intel.com" <arjan@linux.intel.com>,
       "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>,
       Paul Mackerras <paulus@samba.org>,
       "David S. Miller" <davem@davemloft.net>,
       Paul Mundt <lethal@linux-sh.org>, lkml <linux-kernel@vger.kernel.org>
Subject: Re: [RFC][PATCH 3/9] perf: export registerred pmus via sysfs
Message-ID: <20100510113930.GA28337@flint.arm.linux.org.uk>
References: <1273483623.15998.57.camel@minggr.sh.intel.com> <1273484401.5605.3333.camel@twins> <1273486313.15998.76.camel@minggr.sh.intel.com> <1273486708.5605.3342.camel@twins> <1273487195.15998.85.camel@minggr.sh.intel.com> <1273490824.5605.3379.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1273490824.5605.3379.camel@twins>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This really needs to loop the ARM PMU guys on this topic.  ARM PMU is
not something I know very much about, and I really don't understand
why I'm on the CC list and not the ARM PMU folk.

I may be mis-stating a problem, but I believe that we have issues with
exporting event IDs in that they're SoC implementation specific - but
as I say, the ARM PMU guys know the details not me.

I strongly suggest no further discussion without at least looping Will
Deacon in on this.

-- 
Russell King
 Linux kernel    2.6 ARM Linux   - http://www.arm.linux.org.uk/
 maintainer of:
