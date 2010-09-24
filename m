Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757564Ab0IXVHF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Sep 2010 17:07:05 -0400
Received: from mail.openrapids.net ([64.15.138.104]:52111 "EHLO
	blackscsi.openrapids.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1757481Ab0IXVHD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Sep 2010 17:07:03 -0400
Date: Fri, 24 Sep 2010 17:06:59 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To: ltt-dev@lists.casi.polymtl.ca, linux-kernel@vger.kernel.org,
        Rp private <rp-private@svcs.cs.pdx.edu>
Cc: "Paul E. McKenney" <paulmck@us.ibm.com>
Subject: [RELEASE] Userspace RCU 0.4.8
Message-ID: <20100924210659.GA14449@Krystal>
References: <20100922201830.GB7669@Krystal>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100922201830.GB7669@Krystal>
X-Editor: vi
X-Info: http://www.efficios.com
X-Operating-System: Linux/2.6.26-2-686 (i686)
X-Uptime: 17:05:48 up 2 days,  1:07,  1 user,  load average: 0.14, 0.15,
	0.10
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

liburcu is a LGPLv2.1 userspace RCU (read-copy-update) library. This data
synchronization library provides read-side access which scales linearly with the
number of cores. It does so by allowing multiples copies of a given data
structure to live at the same time, and by monitoring the data structure
accesses to detect grace periods after which memory reclamation is possible.

Changelog for Userspace RCU 0.4.8:

- Add missing header to package, fix build error introduced in 0.4.7.

Project website: http://lttng.org/urcu
Download link: http://www.lttng.org/files/urcu/

-- 
Mathieu Desnoyers
Operating System Efficiency R&D Consultant
EfficiOS Inc.
http://www.efficios.com
