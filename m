Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758481Ab0J2QpW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Oct 2010 12:45:22 -0400
Received: from mail.openrapids.net ([64.15.138.104]:35861 "EHLO
	blackscsi.openrapids.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751974Ab0J2QpU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Oct 2010 12:45:20 -0400
Date: Fri, 29 Oct 2010 12:45:18 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To: ltt-dev@lists.casi.polymtl.ca
Cc: linux-kernel@vger.kernel.org
Subject: [RELEASE] LTTng 0.238 and lttng-modules 0.19.2 for kernel 2.6.36
Message-ID: <20101029164518.GA20073@Krystal>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Editor: vi
X-Info: http://www.efficios.com
X-Operating-System: Linux/2.6.26-2-686 (i686)
X-Uptime: 12:44:24 up 36 days, 20:46,  4 users,  load average: 0.18, 0.13,
	0.10
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

LTTng, the Linux Trace Toolkit Next Generation, is a project that aims at
producing a highly efficient full system tracing solution.  It is composed of
several components to allow tracing of the kernel, of userspace, trace viewing
and analysis and trace streaming.  LTTng is open source software. It is being
actively developed with the community.

Changelog:

* LTTng 0.238 and lttng-modules 0.19.2 now reserve the PMU on ARM OMAP2+ when a
  trace session starts. We're playing nice with perf.

Project website: http://lttng.org
Download link: http://lttng.org/content/download
(please refer to the LTTng Manual for installation instructions)

-- 
Mathieu Desnoyers
Operating System Efficiency R&D Consultant
EfficiOS Inc.
http://www.efficios.com
