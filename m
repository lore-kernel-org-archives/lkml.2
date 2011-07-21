Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753639Ab1GUViq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jul 2011 17:38:46 -0400
Received: from mail.openrapids.net ([64.15.138.104]:58462 "EHLO
	blackscsi.openrapids.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752968Ab1GUVin (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jul 2011 17:38:43 -0400
X-Greylist: delayed 438 seconds by postgrey-1.27 at vger.kernel.org; Thu, 21 Jul 2011 17:38:43 EDT
Date: Thu, 21 Jul 2011 17:31:22 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To: ltt-dev@lists.casi.polymtl.ca, linux-kernel@vger.kernel.org,
        freebsd-announce@freebsd.org, rp@svcs.cs.pdx.edu
Cc: Jon Bernard <jbernard@debian.org>
Subject: [RELEASE] Userspace RCU 0.6.4
Message-ID: <20110721213122.GA23832@Krystal>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Editor: vi
X-Info: http://www.efficios.com
X-Operating-System: Linux/2.6.26-2-686 (i686)
X-Uptime: 17:25:43 up 240 days,  2:28,  3 users,  load average: 0.12, 0.04,
	0.01
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
        * uatomic: Fix ARM build errors in uatomic.
        * urcu tests: hold mutex across use of custom allocator.
        * Portability fixes to support FreeBSD 8.2.

Project website: http://lttng.org/urcu
Download link: http://www.lttng.org/files/urcu/

-- 
Mathieu Desnoyers
Operating System Efficiency R&D Consultant
EfficiOS Inc.
http://www.efficios.com
