Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753409Ab0DVIvQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Apr 2010 04:51:16 -0400
Received: from casper.infradead.org ([85.118.1.10]:52955 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752913Ab0DVIvP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Apr 2010 04:51:15 -0400
Subject: Re: [RFC][PATCH 0/4] perf: remove __weak function
 hw_perf_group_sched_in()
From: Peter Zijlstra <peterz@infradead.org>
To: Lin Ming <ming.m.lin@intel.com>
Cc: Ingo Molnar <mingo@elte.hu>, "eranian@gmail.com" <eranian@gmail.com>,
       "Gary.Mohr@Bull.com" <Gary.Mohr@bull.com>,
       Corey Ashford <cjashfor@linux.vnet.ibm.com>, arjan@linux.intel.com,
       "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>,
       Paul Mackerras <paulus@samba.org>,
       "David S. Miller" <davem@davemloft.net>,
       lkml <linux-kernel@vger.kernel.org>
In-Reply-To: <1271922655.30535.106.camel@minggr.sh.intel.com>
References: <1271922655.30535.106.camel@minggr.sh.intel.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 22 Apr 2010 10:29:57 +0200
Message-ID: <1271924997.1776.319.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-04-22 at 15:50 +0800, Lin Ming wrote:

> This patch series is to remove hw_perf_group_sched_in() first.
> 
> patch 1: core, add group scheduling transactional APIs
> patch 2: x86, implement group scheduling transactional APIs
> patch 3: powerpc, implement group scheduling transactional APIs
> patch 4: sparc, implement group scheduling transactional APIs
> 
> Thanks for any comment.

Don't RISC architectures deal better with word sized variables than with
u8? I thought it curious you used u8 for the flags thing instead of int
or long, but I'm not quite sure it really matters one way or the other.

