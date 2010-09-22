Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752949Ab0IVUSf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Sep 2010 16:18:35 -0400
Received: from mail.openrapids.net ([64.15.138.104]:35552 "EHLO
	blackscsi.openrapids.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750708Ab0IVUSe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Sep 2010 16:18:34 -0400
Date: Wed, 22 Sep 2010 16:18:31 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To: ltt-dev@lists.casi.polymtl.ca, linux-kernel@vger.kernel.org,
        Rp private <rp-private@svcs.cs.pdx.edu>
Cc: "Paul E. McKenney" <paulmck@us.ibm.com>
Subject: [RELEASE] Userspace RCU 0.4.7
Message-ID: <20100922201830.GB7669@Krystal>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Editor: vi
X-Info: http://www.efficios.com
X-Operating-System: Linux/2.6.26-2-686 (i686)
X-Uptime: 16:10:53 up 13 min,  3 users,  load average: 0.08, 0.27, 0.26
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

liburcu is a LGPLv2.1 userspace RCU (read-copy-update) library. This data
synchronization library provides read-side access which scales linearly with the
number of cores. It does so by allowing multiples copies of a given data
structure to live at the same time, and by monitoring the data structure
accesses to detect grace periods after which memory reclamation is possible.

Changelog for Userspace RCU 0.4.7:

- Add wait-free enqueue/push, blocking dequeue/pop list and stack.
- Add lock-free enqueue/dequeue/push/pop list and stack.
- Add ifdef around container_of() definition to kill gcc warnings when building
  UST.

The wait-free enqueue/blocking dequeue will enable creation of the call_rcu()
primitive in a near future.

Project website: http://lttng.org/urcu
Download link: http://www.lttng.org/files/urcu/

-- 
Mathieu Desnoyers
Operating System Efficiency R&D Consultant
EfficiOS Inc.
http://www.efficios.com
