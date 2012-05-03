Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756863Ab2ECOp7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 May 2012 10:45:59 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:45805 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756752Ab2ECOp5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 May 2012 10:45:57 -0400
From: Magnus Damm <magnus.damm@gmail.com>
To: linux-arm-kernel@lists.infradead.org
Cc: horms@verge.net.au, linux@arm.linux.org.uk, arnd@arndb.de,
        linux-sh@vger.kernel.org, linux-kernel@vger.kernel.org, rjw@sisk.pl,
        lethal@linux-sh.org, olof@lixom.net,
        Magnus Damm <magnus.damm@gmail.com>
Date: Thu, 03 May 2012 23:46:45 +0900
Message-Id: <20120503144645.6390.62303.sendpatchset@w520>
Subject: [PATCH 00/02] mach-shmobile: Emma Mobile EV2 - first shot
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

mach-shmobile: Emma Mobile EV2 - first shot

[PATCH 01/02] mach-shmobile: Emma Mobile EV2 SoC base support
[PATCH 02/02] mach-shmobile: KZM9D board prototype support

This series adds experimental Emma Mobile EV2 support to
mach-shmobile. Yet another dual core Cortex-A9 SoC.

At this point only serial and timer is supported. Future work
includes GPIO, network device, SMP and DT support. If possible
it would be nice to use the common clocks on this platform.

To boot this on actual hardware you also need the following:
"[PATCH] serial8250-em: Emma Mobile UART driver V2"
"[PATCH] clocksource: em_sti: Emma Mobile STI driver"

Any reason to not put this in mach-shmobile?

Partially-signed-off-by: Magnus Damm <damm@opensource.se>
---

 Does unfortunately not apply cleanly to the renesas
 git repository, so we need to figure out how to let
 this coexist with the new boards...
 
 arch/arm/mach-shmobile/Kconfig               |    9 +
 arch/arm/mach-shmobile/Makefile              |    2 
 arch/arm/mach-shmobile/board-kzm9d.c         |   44 +++++
 arch/arm/mach-shmobile/clock-emev2.c         |  206 ++++++++++++++++++++++++++
 arch/arm/mach-shmobile/include/mach/common.h |    6 
 arch/arm/mach-shmobile/intc-emev2.c          |   36 ++++
 arch/arm/mach-shmobile/setup-emev2.c         |  187 +++++++++++++++++++++++
 7 files changed, 490 insertions(+)
