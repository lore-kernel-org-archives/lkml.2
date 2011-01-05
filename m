Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753263Ab1AEXkp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jan 2011 18:40:45 -0500
Received: from mail.openrapids.net ([64.15.138.104]:35988 "EHLO
	blackscsi.openrapids.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753222Ab1AEXko (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jan 2011 18:40:44 -0500
Date: Wed, 5 Jan 2011 18:40:41 -0500
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To: ltt-dev@lists.casi.polymtl.ca
Cc: linux-kernel@vger.kernel.org
Subject: [RELEASE/STATUS] LTTng 0.240 for kernel 2.6.36.2
Message-ID: <20110105234041.GA11813@Krystal>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Editor: vi
X-Info: http://www.efficios.com
X-Operating-System: Linux/2.6.26-2-686 (i686)
X-Uptime: 18:10:15 up 43 days,  4:13,  2 users,  load average: 0.07, 0.03,
	0.00
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
- Implement a user-space trace clock into a new clock_gettime() clock id.
  (will be used by the next UST release). It will provide consistent timestamps
  between userspace and kernel traces taken on a LTTng-enabled Linux kernel.
- Moved to stable kernel 2.6.36.2 (last LTTng release targeting 2.6.36.x,
  moving on to 2.6.37 shortly)

Project Status:
- I am currently working on a LTTng redesign to better suit the need of Linux
  distributions. The kernel-side work is very well advanced, and I'm now moving
  on to the following steps: redesign lttd/lttctl/ltt-armall with a more
  integrated approach (lttngtrace), and move LTTV to the new CTF (Common Trace
  Format). I am keeping this redesign separate from the "stable" LTTng versions
  for now, as it removes some of the LTTng-specific instrumentation to bring the
  size of the patchset down to something more appealing to distributions.
  The ongoing redesign is available in the lttng-modules git tree HEAD, but
  depends on a reduced kernel tree LTTng patchset that I have not yet released.

Project website: http://lttng.org
Download link: http://lttng.org/content/download
(please refer to the LTTng Manual for installation instructions)

-- 
Mathieu Desnoyers
Operating System Efficiency R&D Consultant
EfficiOS Inc.
http://www.efficios.com
