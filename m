Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757952Ab1D3RMj (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Apr 2011 13:12:39 -0400
Received: from mail.openrapids.net ([64.15.138.104]:51399 "EHLO
	blackscsi.openrapids.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751297Ab1D3RMi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Apr 2011 13:12:38 -0400
Date: Sat, 30 Apr 2011 13:12:35 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To: ltt-dev@lists.casi.polymtl.ca
Cc: linux-kernel@vger.kernel.org
Subject: [RELEASE] LTTng development snapshot 20110430 for kernel 2.6.38.4
Message-ID: <20110430171235.GA6788@Krystal>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Editor: vi
X-Info: http://www.efficios.com
X-Operating-System: Linux/2.6.26-2-686 (i686)
X-Uptime: 12:56:49 up 157 days, 21:59,  5 users,  load average: 0.10, 0.03,
	0.01
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

LTTng, the Linux Trace Toolkit Next Generation, is a project that aims
at producing a highly efficient full system tracing solution. It is
composed of several components to allow tracing of the kernel, of
userspace, trace viewing and analysis and trace streaming. LTTng is
open source software. It is being actively developed with the community.

* LTTng development snapshot 20110430 for kernel 2.6.38.4

- This is an update the the development snapshot of the next LTTng
  generation (that would probably make it LTTngng, LTTnng or LTT(ng)^2)
  for kernel 2.6.38.4. The goals of this development phase are as
  follows:

1) The size of the kernel patchset has been shrinked for Linux
   distributions by removing all LTTng-specific instrumentation from the
   tree.

2) The lttng-modules package now implements an ABI based on anonymous
   file descriptors (inspired from perf) rather than the full-blown VFS tree
   the previous LTTng versions were implementing.

3) lttng-modules now exports trace data and metadata in the CTF (Common
   Trace Format).

4) lttng-modules now uses the Generic Ring Buffer Library.

The kernel tree snapshot is available as a tarball at:
http://lttng.org/files/lttng/patch-2.6.38.4-lttng-dev-snapshot-20110430.tar.bz2

Please note that the patches within this patchset are elected as the
first items from the LTTng project to eventually get into the mainline
Linux kernel. This includes TRACE_EVENT() changes, the LTTng trace
clocks and the Generic Ring Buffer Library.

The LTTng kernel patchset is needed to build the current lttng-modules
git tree (a kernel module package). To fetch it:

git clone git://git.lttng.org/lttng-modules.git

Work is ongoing for the new unified LTTng/UST user interface. The
current development can be found at:
http://git.lttng.org/?p=lttng-tools.git

Thanks,

Mathieu

-- 
Mathieu Desnoyers
Operating System Efficiency R&D Consultant
EfficiOS Inc.
http://www.efficios.com
