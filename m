Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753382Ab1FMOFL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jun 2011 10:05:11 -0400
Received: from mail.openrapids.net ([64.15.138.104]:53368 "EHLO
	blackscsi.openrapids.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752452Ab1FMOFJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jun 2011 10:05:09 -0400
Date: Mon, 13 Jun 2011 10:05:07 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To: "ltt-dev@lists.casi.polymtl.ca" <ltt-dev@lists.casi.polymtl.ca>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "rp@svcs.cs.pdx.edu" <rp@svcs.cs.pdx.edu>
Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        "Cui, Dexuan" <dexuan.cui@intel.com>
Subject: [RELEASE] Userspace RCU 0.6.1
Message-ID: <20110613140507.GC29349@Krystal>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Editor: vi
X-Info: http://www.efficios.com
X-Operating-System: Linux/2.6.26-2-686 (i686)
X-Uptime: 10:02:55 up 201 days, 19:06,  7 users,  load average: 0.23, 0.13,
	0.03
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

Changelog for 0.6.1:

* Add missing headers into release tarball:
    urcu-call-rcu-impl.h and urcu-defer-impl.h

Project website: http://lttng.org/urcu
Download link: http://www.lttng.org/files/urcu/

-- 
Mathieu Desnoyers
Operating System Efficiency R&D Consultant
EfficiOS Inc.
http://www.efficios.com
