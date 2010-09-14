Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752899Ab0INQZ7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Sep 2010 12:25:59 -0400
Received: from tomts22-srv.bellnexxia.net ([209.226.175.184]:58206 "EHLO
	tomts22-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751993Ab0INQZ6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Sep 2010 12:25:58 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AvsEAM85j0xGGNlj/2dsb2JhbAChUHLEcYVABA
Date: Tue, 14 Sep 2010 12:20:18 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To: ltt-dev@lists.casi.polymtl.ca, linux-kernel@vger.kernel.org
Subject: [RELEASE] LTTng 0.230 for kernel 2.6.35.4
Message-ID: <20100914162018.GA13035@Krystal>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.27.31-grsec (i686)
X-Uptime: 12:13:05 up 160 days,  2:03,  4 users,  load average: 0.16, 0.17,
	0.17
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

LTTng, the Linux Trace Toolkit Next Generation, is a project that aims
at producing a highly efficient full system tracing solution.  It is
composed of several components to allow tracing of the kernel, of
userspace, trace viewing and analysis and trace streaming.  LTTng is
open source software. It is being actively developed with the community.

Changelog:

LTTng 0.230 kernel tree:

- moves the arch-specific KVM tracing headers to /include/trace, so
  lttng-modules can access them. This is for the forthcoming KVM tracing
  probes.
- fix a recent rebase issue with Kconfig trace clock options (were under
  the cgroups menu).

Project website: http://lttng.org
Download link: http://lttng.org/content/download
(please refer to the LTTng Manual for installation instructions)

-- 
Mathieu Desnoyers
Operating System Efficiency R&D Consultant
EfficiOS Inc.
http://www.efficios.com
