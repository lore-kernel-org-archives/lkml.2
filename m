Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933591Ab2FASFl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jun 2012 14:05:41 -0400
Received: from mail.openrapids.net ([64.15.138.104]:45797 "EHLO
	blackscsi.openrapids.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S933565Ab2FASFg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jun 2012 14:05:36 -0400
Date: Fri, 1 Jun 2012 14:05:33 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To: linux-kernel@vger.kernel.org, lttng-dev@lists.lttng.org,
        rp@svcs.cs.pdx.edu
Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Lai Jiangshan <laijs@cn.fujitsu.com>,
        Stephen Hemminger <shemminger@vyatta.com>
Subject: [RELEASE] Userspace RCU 0.7.3
Message-ID: <20120601180533.GA15522@Krystal>
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

This is a minor compatibility-related release, fixing build issues with
FreeBSD and NetBSD. On Linux, only the test_perthreadlock fix could
change the result of make check (which could previously fail due to
non-initialized mutexes), but it does not impact anything installed on
the system.

Changelog:
2012-06-01 Userspace RCU 0.7.3
        * Fix tests: make dist lib dependency
        * Update README for OS supported, tests dependency
        * Add CodingStyle to tarball
        * Add coding style document
        * Test fix: test_perthreadlock uninitialized mutex
        * tests: support FreeBSD short "time" args
        * freebsd 8.2 fix: define MAP_ANONYMOUS for compatibility

Project website: http://lttng.org/urcu
Download link: http://lttng.org/files/urcu/

-- 
Mathieu Desnoyers
Operating System Efficiency R&D Consultant
EfficiOS Inc.
http://www.efficios.com
