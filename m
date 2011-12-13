Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754700Ab1LMCmR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Dec 2011 21:42:17 -0500
Received: from mail.openrapids.net ([64.15.138.104]:52541 "EHLO
	blackscsi.openrapids.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751106Ab1LMCmQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Dec 2011 21:42:16 -0500
Date: Mon, 12 Dec 2011 21:42:13 -0500
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To: linux-kernel@vger.kernel.org, lttng-dev@lists.lttng.org,
        rp@svcs.cs.pdx.edu
Subject: [RELEASE] Userspace RCU 0.6.7
Message-ID: <20111213024213.GA9719@Krystal>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Editor: vi
X-Info: http://www.efficios.com
X-Operating-System: Linux/2.6.26-2-686 (i686)
X-Uptime: 21:39:16 up 384 days,  7:42,  6 users,  load average: 0.03, 0.01,
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
2011-12-12 Userspace RCU 0.6.7
        * Add compat file for test urcu wfs
        * Add missing compat file for wfq test
        * hlist.h: Add missing stddef.h include for NULL
        * call_rcu: Add missing call_rcu_before_fork and
          call_rcu_after_fork_parent declarations
        * Describe autotools/libtool/automake version dependency
        * Remove m4_ifdef for AC_PROG_LIBTOOL (deprecated)
        * Support older autotools
        * Apply autoupdate to configure.ac
        * Fix build for amd64 environment (for FreeBSD 8.2)
        * Add missing rcu_dereference_sym_bp
        * Install test scripts in the dist tarball

Project website: http://lttng.org/urcu
Download link: http://lttng.org/files/urcu/


-- 
Mathieu Desnoyers
Operating System Efficiency R&D Consultant
EfficiOS Inc.
http://www.efficios.com
