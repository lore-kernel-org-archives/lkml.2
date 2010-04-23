Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755311Ab0DWCWm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Apr 2010 22:22:42 -0400
Received: from mga03.intel.com ([143.182.124.21]:19416 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755058Ab0DWCWk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Apr 2010 22:22:40 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.52,259,1270450800"; 
   d="scan'208";a="269169800"
Subject: Re: [RFC][PATCH 0/4] perf: remove __weak function
 hw_perf_group_sched_in()
From: Lin Ming <ming.m.lin@intel.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@elte.hu>, "eranian@gmail.com" <eranian@gmail.com>,
       "Gary.Mohr@Bull.com" <Gary.Mohr@bull.com>,
       Corey Ashford <cjashfor@linux.vnet.ibm.com>,
       "arjan@linux.intel.com" <arjan@linux.intel.com>,
       "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>,
       Paul Mackerras <paulus@samba.org>,
       "David S. Miller" <davem@davemloft.net>,
       lkml <linux-kernel@vger.kernel.org>
In-Reply-To: <1271924997.1776.319.camel@laptop>
References: <1271922655.30535.106.camel@minggr.sh.intel.com>
	 <1271924997.1776.319.camel@laptop>
Content-Type: text/plain
Date: Fri, 23 Apr 2010 10:23:04 +0800
Message-Id: <1271989384.3412.22.camel@minggr.sh.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1 (2.24.1-2.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-04-22 at 16:29 +0800, Peter Zijlstra wrote:
> On Thu, 2010-04-22 at 15:50 +0800, Lin Ming wrote:
> 
> > This patch series is to remove hw_perf_group_sched_in() first.
> > 
> > patch 1: core, add group scheduling transactional APIs
> > patch 2: x86, implement group scheduling transactional APIs
> > patch 3: powerpc, implement group scheduling transactional APIs
> > patch 4: sparc, implement group scheduling transactional APIs
> > 
> > Thanks for any comment.
> 
> Don't RISC architectures deal better with word sized variables than with
> u8? I thought it curious you used u8 for the flags thing instead of int
> or long, but I'm not quite sure it really matters one way or the other.

Will change it to "unsigned int".

Thanks.

