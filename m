Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752436Ab2H0MVQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Aug 2012 08:21:16 -0400
Received: from mail.openrapids.net ([64.15.138.104]:36662 "EHLO
	blackscsi.openrapids.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751801Ab2H0MVP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Aug 2012 08:21:15 -0400
Date: Mon, 27 Aug 2012 08:21:11 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To: linux-kernel@vger.kernel.org, lttng-dev@lists.lttng.org,
        rp@svcs.cs.pdx.edu
Cc: Ralf Baechle <ralf@linux-mips.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Lai Jiangshan <laijs@cn.fujitsu.com>,
        Stephen Hemminger <shemminger@vyatta.com>
Subject: [RELEASE] Userspace RCU 0.7.4
Message-ID: <20120827122111.GA1935@Krystal>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Editor: vi
X-Info: http://www.efficios.com
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

liburcu is a LGPLv2.1 userspace RCU (read-copy-update) library. This
data synchronization library provides read-side access which scales
linearly with the number of cores. It does so by allowing multiples
copies of a given data structure to live at the same time, and by
monitoring the data structure accesses to detect grace periods after
which memory reclamation is possible.

liburcu-cds provides efficient data structures based on RCU and
lock-free algorithms. Those structures include hash tables, queues,
stacks, and doubly-linked lists.

The main change in this version is the added support for MIPS,
contributed by Ralf Baechle.

Changelog:
2012-08-27 Userspace RCU 0.7.4
        * rculfhash API documentation: document destroy RCU read-lock constraint
        * Fix: rculfhash should be offline while waiting for resize to complete
        * Add missing entry to gitignore
        * urcu: move busy-wait code and name it ___cds_wfq_node_sync_next()
        * urcu: fix compat_futex_noasync()
        * urcu: add hint to DEFINE_URCU_TLS() for compound types
        * Fix: CAA_BUILD_BUG_ON should refer to CAA_BUILD_BUG_ON_ZERO
        * Add MIPS support
        * Compatibility: remove bash-ismsm from test scripts
        * Fix inappropriate lib behavior: don't call exit()
        * Fix: re-enable compatibility with autoconf < 2.64
        * Fix c99 compatibility: use __asm__ and __volatile__ in public headers
        * Fix c99 compatibility: use __typeof__ instead of typeof in public headers
        * warning fix: tests urcutorture for NetBSD 5

-- 
Mathieu Desnoyers
Operating System Efficiency R&D Consultant
EfficiOS Inc.
http://www.efficios.com
