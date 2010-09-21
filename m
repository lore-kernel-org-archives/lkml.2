Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755203Ab0IUCUV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Sep 2010 22:20:21 -0400
Received: from mail.openrapids.net ([64.15.138.104]:59081 "EHLO
	blackscsi.openrapids.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752322Ab0IUCUU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Sep 2010 22:20:20 -0400
Date: Mon, 20 Sep 2010 22:20:18 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To: ltt-dev@lists.casi.polymtl.ca, linux-kernel@vger.kernel.org
Subject: [RELEASE] LTTng 0.231 for Linux 2.6.35.5
Message-ID: <20100921022018.GA22847@Krystal>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Editor: vi
X-Info: http://www.efficios.com
X-Operating-System: Linux/2.6.26-2-686 (i686)
X-Uptime: 22:07:56 up 241 days,  4:44,  4 users,  load average: 0.24, 0.12,
	0.03
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
* LTTng 0.231 is rebased on kernel 2.6.35.5. All 2.6.35.x LTTng users are
  encouraged to upgrade, as this stable kernel release fixes security issues in
  the Linux kernel mainline x86-64 32-bit compatibility code as well as a
  sigreturn bug on ARM. Please note that the x86-64 security issue affects a
  much wider range of kernel versions. For reference: CVE-2010-3081 affects
  2.6.26-rc1 to 2.6.36-rc4 [1], CVE-2010-3301 affects 2.6.27-rc1 to
  2.6.36-rc4 [2].

  [1] https://access.redhat.com/kb/docs/DOC-40265
  [2] https://access.redhat.com/kb/docs/DOC-40330

Project website: http://lttng.org
Download link: http://lttng.org/content/download
(please refer to the LTTng Manual for installation instructions)

Mathieu

-- 
Mathieu Desnoyers
Operating System Efficiency R&D Consultant
EfficiOS Inc.
http://www.efficios.com
