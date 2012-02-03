Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754017Ab2BCDnu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Feb 2012 22:43:50 -0500
Received: from mail.openrapids.net ([64.15.138.104]:37532 "EHLO
	blackscsi.openrapids.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750756Ab2BCDns (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Feb 2012 22:43:48 -0500
Date: Thu, 2 Feb 2012 22:43:46 -0500
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To: linux-kernel@vger.kernel.org, lttng-dev@lists.lttng.org
Subject: [RELEASE] LTTng 2.0 prerelease bundle 20120202
Message-ID: <20120203034346.GA4673@Krystal>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Editor: vi
X-Info: http://www.efficios.com
X-Operating-System: Linux/2.6.26-2-686 (i686)
X-Uptime: 22:37:17 up 436 days,  8:40,  4 users,  load average: 0.10, 0.04,
	0.01
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

LTTng, the Linux Trace Toolkit Next Generation, is a highly efficient
full system tracing solution toolchain. It is composed of several
components to allow tracing of the kernel, of userspace, trace viewing
and analysis and trace streaming. LTTng is open source software.

This bundle (20120202) contains:

lttng-modules-2.0-pre12.tar.bz2   - Linux kernel tracer
lttng-ust-1.9.5.tar.gz            - User-space tracing
lttng-tools-2.0-pre19.tar.bz2     - Tracer control (for kernel and
                                    userspace tracing)
babeltrace-0.9.tar.bz2            - Trace to text pretty printer
userspace-rcu-0.6.7.tar.bz2       - User-level synchronization lib

This will be the last prerelease bundle before Release Candidate 1. From
rc1, LTTng 2.0 will enter in feature-freeze mode until 2.0 final, which
is expected around Feb. 15. Testing is therefore more than very
welcome!

You can get a the current release "bundle" (recommanded set of packages)
at the following URL:

http://lttng.org/bundles/

Project website: http://lttng.org
Download link: http://lttng.org/lttng2.0
(please refer to the README files for installation instructions and
lttng-tools doc/quickstart.txt for usage information)

-- 
Mathieu Desnoyers
Operating System Efficiency R&D Consultant
EfficiOS Inc.
http://www.efficios.com
