Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755403Ab0ICOaj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Sep 2010 10:30:39 -0400
Received: from mail.openrapids.net ([64.15.138.104]:57864 "EHLO
	blackscsi.openrapids.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754521Ab0ICOai (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Sep 2010 10:30:38 -0400
Date: Fri, 3 Sep 2010 10:30:36 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To: ltt-dev@lists.casi.polymtl.ca
Cc: linux-kernel@vger.kernel.org
Subject: [RELEASE] LTTng 0.228, lttng-modules 0.17
Message-ID: <20100903143036.GA14137@Krystal>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Editor: vi
X-Info: http://www.efficios.com
X-Operating-System: Linux/2.6.26-2-686 (i686)
X-Uptime: 10:25:13 up 223 days, 17:01,  5 users,  load average: 0.09, 0.06,
	0.01
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

LTTng, the Linux Trace Toolkit Next Generation, is a project that aims at
producing a highly efficient full system tracing solution.  It is composed of
several components to allow tracing of the kernel, of userspace, trace viewing
and analysis and trace streaming.

Changelog:
* LTTng kernel patchset is cleaned up in 0.228. Brought down from approx. 400
  patches down to 223.
* lttng-modules now supports architectures without LTTng table dump.

Project website: http://lttng.org
Download link: http://lttng.org/content/download
(please refer to the LTTng Manual for installation instructions)

-- 
Mathieu Desnoyers
Operating System Efficiency R&D Consultant
EfficiOS Inc.
http://www.efficios.com
