Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756136Ab1FJR1O (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jun 2011 13:27:14 -0400
Received: from fmailhost03.isp.att.net ([204.127.217.103]:59888 "EHLO
	fmailhost03.isp.att.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752889Ab1FJR1M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jun 2011 13:27:12 -0400
X-Greylist: delayed 875 seconds by postgrey-1.27 at vger.kernel.org; Fri, 10 Jun 2011 13:27:12 EDT
X-Originating-IP: [70.241.89.83]
Date: Fri, 10 Jun 2011 12:13:17 -0500
From: Robert Redelmeier <redelm@sbcglobal.net>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Robert Redelmeier <redelm@sbcglobal.net>
Subject: NEPOTISM_BONUS  yield_to_child() ?
Message-ID: <20110610171317.GA15253@jim.domain_not_set.invalid>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  		[YAFR - Yet Another Feature Request]

Multi-threaded/tasking performance is entirely 
dependent on the OS scheduler.  I searched
	/usr/src/linux/Documentation/scheduler/*
and found no mention of parent or child processes.

Parent- and child-processes are interconnected, and for maximum [SMP] 
performance, these connections should be recognized _optimally._

For example, on some [desktop] systems, an exec() syscall would run
unblocked, an exit() would return the rest of the timeslice to the
parent, yield() would go to child (parent?), etc.  Other servers
might choose the exact opposite.

This connectivity could be implemented by a tuneable scheduler param:

  NEPOTISM_BONUS = int

where positive values would influence the scheduler to run
parents/children/uncles/nieces and negative values would
cause the scheduler to prefer strangers [unrelated procs].


-- Robert in Houston

