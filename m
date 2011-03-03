Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932443Ab1CCVOV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Mar 2011 16:14:21 -0500
Received: from mail.openrapids.net ([64.15.138.104]:49850 "EHLO
	blackscsi.openrapids.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S932290Ab1CCVOT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Mar 2011 16:14:19 -0500
Date: Thu, 3 Mar 2011 16:14:16 -0500
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To: ltt-dev@lists.casi.polymtl.ca, linux-kernel@vger.kernel.org,
        rp@svcs.cs.pdx.edu
Subject: [RELEASE] Userspace RCU 0.5.3
Message-ID: <20110303211416.GA3156@Krystal>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Editor: vi
X-Info: http://www.efficios.com
X-Operating-System: Linux/2.6.26-2-686 (i686)
X-Uptime: 16:09:35 up 100 days,  2:12,  4 users,  load average: 0.08, 0.02,
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

Changelog for v0.5.3:
* Add support for older ARM single-CPU architecturess (pre-ARMv7)
  (thanks to Jason Wessel from WindRiver).
* Fix ARMv7 cmm_rmb/cmm_wmb primitives (use a dmb barrier).
* Remove leftover list_t type from urcu/list.h (namespace cleanup).
* urcu_defer: handle malloc error value.
* Update README file to describe urcu interaction with fork() when not followed
  by an exec() system call.

Project website: http://lttng.org/urcu
Download link: http://www.lttng.org/files/urcu/

-- 
Mathieu Desnoyers
Operating System Efficiency R&D Consultant
EfficiOS Inc.
http://www.efficios.com
