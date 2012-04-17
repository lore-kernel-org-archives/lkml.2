Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754109Ab2DRAVi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Apr 2012 20:21:38 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:14961 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754024Ab2DRAVY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Apr 2012 20:21:24 -0400
Message-Id: <6e201a$5e4ium@wolverine01.qualcomm.com>
X-IronPort-AV: E=McAfee;i="5400,1158,6684"; a="182602710"
From: Richard Kuo <rkuo@codeaurora.org>
Date: Tue, 17 Apr 2012 18:56:01 -0500
Subject: [PATCH 00/10] Hexagon cleanup and misc patches
To: linux-arch@vger.kernel.org, linux-hexagon@vger.kernel.org,
        linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a small collection of patches that I've been sitting on for probably
too long that I'm getting ready to make a pull request for.  It's largely
cleanup and fixes from the original Hexagon upstreaming, with a few
additional enhancements to do_page_fault and SMP startup which have already
been on the mailing lists for some time.

Please let me know if there are any issues, and thanks to everyone who sent
patches.



Jesper Juhl (1):
  Remove unneeded include of version.h from
    arch/hexagon/include/asm/spinlock_types.h

Julia Lawall (1):
  arch/hexagon/kernel/dma.c: make function static

Kautuk Consul (1):
  hexagon/mm/vm_fault.c: Port OOM changes to do_page_fault

Paul Bolle (1):
  hexagon: drop selects of bogus Kconfig symbols

Richard Kuo (4):
  various Kconfig cleanup and old platform build code removal
  Hexagon: misc compile warning/error cleanup due to missing headers
  hexagon:  use renamed tick_nohz_idle_* functions
  hexagon: add missing cpu.h include

Srivatsa S. Bhat (1):
  hexagon/CPU hotplug: Add missing call to notify_cpu_starting()

Thomas Meyer (1):
  Hexagon: Use resource_size function

 arch/hexagon/Kconfig                      |   23 ++++-------------------
 arch/hexagon/Makefile                     |    5 -----
 arch/hexagon/include/asm/spinlock_types.h |    2 --
 arch/hexagon/kernel/dma.c                 |    3 ++-
 arch/hexagon/kernel/process.c             |    6 +++---
 arch/hexagon/kernel/ptrace.c              |    1 +
 arch/hexagon/kernel/smp.c                 |    8 +++++++-
 arch/hexagon/kernel/time.c                |    7 +++----
 arch/hexagon/kernel/vdso.c                |    1 +
 arch/hexagon/mm/vm_fault.c                |   22 +++++++++++++++++-----
 10 files changed, 38 insertions(+), 40 deletions(-)


--

Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.
