Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759985Ab1CDRgk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Mar 2011 12:36:40 -0500
Received: from mail.openrapids.net ([64.15.138.104]:35455 "EHLO
	blackscsi.openrapids.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1758960Ab1CDRgj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Mar 2011 12:36:39 -0500
Date: Fri, 4 Mar 2011 12:36:35 -0500
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To: ltt-dev@lists.casi.polymtl.ca, linux-kernel@vger.kernel.org,
        rp@svcs.cs.pdx.edu
Subject: [RELEASE] Userspace RCU 0.5.4
Message-ID: <20110304173635.GA13194@Krystal>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Editor: vi
X-Info: http://www.efficios.com
X-Operating-System: Linux/2.6.26-2-686 (i686)
X-Uptime: 12:34:12 up 100 days, 22:37,  4 users,  load average: 0.13, 0.06,
	0.01
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

liburcu is a LGPLv2.1 userspace RCU (read-copy-update) library. This data
synchronization library provides read-side access which scales linearly with the
number of cores. It does so by allowing multiples copies of a given data
structure to live at the same time, and by monitoring the data structure
accesses to detect grace periods after which memory reclamation is possible.

Changelog for v0.5.4:

 *  urcu-bp: Update fork() handling
    
    Introduce
    
    extern void rcu_bp_before_fork(void);
    extern void rcu_bp_after_fork_parent(void);
    extern void rcu_bp_after_fork_child(void);
    
    to handle fork gracefully. These disable signals and hold the registry mutex
    across forks. (this flavor of the liburcu library ("bp" for "bulletproof")
    is mainly used by UST, the user-space tracer).

Project website: http://lttng.org/urcu
Download link: http://www.lttng.org/files/urcu/

-- 
Mathieu Desnoyers
Operating System Efficiency R&D Consultant
EfficiOS Inc.
http://www.efficios.com
