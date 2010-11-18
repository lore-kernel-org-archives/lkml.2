Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760501Ab0KRVCh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Nov 2010 16:02:37 -0500
Received: from mail.openrapids.net ([64.15.138.104]:51463 "EHLO
	blackscsi.openrapids.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1759090Ab0KRVCf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Nov 2010 16:02:35 -0500
Date: Thu, 18 Nov 2010 16:02:33 -0500
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To: David Goulet <david.goulet@polymtl.ca>
Cc: ltt-dev@lists.casi.polymtl.ca, linux-kernel@vger.kernel.org
Subject: [RELEASE] Userspace RCU 0.5.0
Message-ID: <20101118210232.GA10632@Krystal>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Editor: vi
X-Info: http://www.efficios.com
X-Operating-System: Linux/2.6.26-2-686 (i686)
X-Uptime: 15:59:16 up 57 days,  1:01,  3 users,  load average: 0.25, 0.13,
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

Changelog:

* Version 0.5.0 changes the API presented by memory model, architecture
  abstraction and data structure primitives in headers. The prefixes are,
  respectively:
  - cmm_ : Concurrent Memory Model
  - caa_ : Concurrent Architecture Abstraction
  - cds_ : Concurrent Data Structures

This will make UST's life easier for instrumentation of large projects like
MariaDB and qemu.

Project website: http://lttng.org/urcu
Download link: http://www.lttng.org/files/urcu/


-- 
Mathieu Desnoyers
Operating System Efficiency R&D Consultant
EfficiOS Inc.
http://www.efficios.com
