Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754213Ab1AFWBe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jan 2011 17:01:34 -0500
Received: from mail.openrapids.net ([64.15.138.104]:55239 "EHLO
	blackscsi.openrapids.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751988Ab1AFWBc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jan 2011 17:01:32 -0500
Date: Thu, 6 Jan 2011 17:01:30 -0500
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To: ltt-dev@lists.casi.polymtl.ca
Cc: linux-kernel@vger.kernel.org
Subject: [RELEASE] LTTng 0.241 and lttng-modules 0.19.4 for Linux 2.6.37
Message-ID: <20110106220130.GA3926@Krystal>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Editor: vi
X-Info: http://www.efficios.com
X-Operating-System: Linux/2.6.26-2-686 (i686)
X-Uptime: 16:57:28 up 44 days,  3:00,  5 users,  load average: 0.00, 0.00,
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
- LTTng 0.241 has been rebased on Linux kernel 2.6.37.
- lttng-modules 0.19.4 network probe has been adapted to the name change of the
  0.241 lttng tracepoint (caused by a clash with the tracepoints added by
  mainline). We should eventually sort out which tracepoints should stay and
  which should be removed, but given that the distributed traces synchronization
  algorithm depends on network events in LTTV, I prefer to leave the merging of
  these tracepoints to someone who has time testing the implication of these
  changes on the LTTV trace synchronization algorithm.

Project website: http://lttng.org
Download link: http://lttng.org/content/download
(please refer to the LTTng Manual for installation instructions)

-- 
Mathieu Desnoyers
Operating System Efficiency R&D Consultant
EfficiOS Inc.
http://www.efficios.com
