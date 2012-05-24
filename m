Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965379Ab2EXV1U (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 May 2012 17:27:20 -0400
Received: from mail.openrapids.net ([64.15.138.104]:50973 "EHLO
	blackscsi.openrapids.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1758309Ab2EXV1S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 May 2012 17:27:18 -0400
Date: Thu, 24 May 2012 17:27:15 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To: linux-kernel@vger.kernel.org, lttng-dev@lists.lttng.org,
        rp@svcs.cs.pdx.edu
Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Lai Jiangshan <laijs@cn.fujitsu.com>,
        Stephen Hemminger <shemminger@vyatta.com>
Subject: Re: [RELEASE] Userspace RCU 0.7.2
Message-ID: <20120524212715.GA11757@Krystal>
References: <20120524172249.GA27643@Krystal>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120524172249.GA27643@Krystal>
X-Editor: vi
X-Info: http://www.efficios.com
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There goes 0.7.2, fixing an unforeseen library binary compatibility
issue between 0.6.x lib versions and 0.7.x (we did not intend to break
binary compatibility between those two).

2012-05-24 Userspace RCU 0.7.2
        * Fix library compatibility

Thanks for everyone reporting issues,

Mathieu

* Mathieu Desnoyers (mathieu.desnoyers@efficios.com) wrote:
> liburcu is a LGPLv2.1 userspace RCU (read-copy-update) library. This
> data synchronization library provides read-side access which scales
> linearly with the number of cores. It does so by allowing multiples
> copies of a given data structure to live at the same time, and by
> monitoring the data structure accesses to detect grace periods after
> which memory reclamation is possible.
> 
> liburcu-cds provides efficient data structures based on RCU and
> lock-free algorithms. Those structures include hash tables, queues,
> stacks, and doubly-linked lists.
> 
> This is a compile-fix release, fixing a compile issue introduced a few
> days before the 0.7.0 release. We plan to deploy a continuous
> integration test setup to catch this kind of issue earlier in a very
> near future.
> 
> Changelog:
> 2012-05-24 Userspace RCU 0.7.1
>         * fix: uatomic_set return value compile fix for non-x86 arch.
> 
> -- 
> Mathieu Desnoyers
> Operating System Efficiency R&D Consultant
> EfficiOS Inc.
> http://www.efficios.com

-- 
Mathieu Desnoyers
Operating System Efficiency R&D Consultant
EfficiOS Inc.
http://www.efficios.com
