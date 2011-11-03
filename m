Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934171Ab1KCQyd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Nov 2011 12:54:33 -0400
Received: from mail.openrapids.net ([64.15.138.104]:42473 "EHLO
	blackscsi.openrapids.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S934073Ab1KCQyc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Nov 2011 12:54:32 -0400
Date: Thu, 3 Nov 2011 12:54:29 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To: linux-kernel@vger.kernel.org, ltt-dev@lists.casi.polymtl.ca,
        rp@svcs.cs.pdx.edu
Subject: [RELEASE] Userspace RCU 0.6.6
Message-ID: <20111103165429.GA8864@Krystal>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Editor: vi
X-Info: http://www.efficios.com
X-Operating-System: Linux/2.6.26-2-686 (i686)
X-Uptime: 12:52:07 up 344 days, 21:55,  7 users,  load average: 0.07, 0.02,
	0.00
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

Changelog:

2011-11-03 Userspace RCU 0.6.6
        * qsbr vs call_rcu : remove exit assertion
        * Rename likely/unlikely to caa_likely/caa_unlikely
        * Reinsert missing test_urcu_*.c files (missing in rename)
        * rename test_qsbr to test_urcu_qsbr
        * urcu-pointer: fix rcu_set_pointer unset return value
        * Enhance API.txt documentation, add to Makefile as EXTRA_DIST

Project website: http://lttng.org/urcu
Download link: http://lttng.org/files/urcu/

-- 
Mathieu Desnoyers
Operating System Efficiency R&D Consultant
EfficiOS Inc.
http://www.efficios.com
