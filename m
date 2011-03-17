Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752951Ab1CQJkJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Mar 2011 05:40:09 -0400
Received: from eu1sys200aog117.obsmtp.com ([207.126.144.143]:55338 "EHLO
	eu1sys200aog117.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753232Ab1CQJjx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Mar 2011 05:39:53 -0400
From: <philippe.langlais@stericsson.com>
To: <linux-kernel@vger.kernel.org>
Cc: <rostedt@goodmis.org>, <STEricsson_nomadik_linux@list.st.com>,
        <pierre.peiffer@stericsson.com>, <lee.jones@linaro.org>,
        Philippe Langlais <philippe.langlais@linaro.org>
Subject: [PATCH 0/3] MIPI System Trace Module (STM) char driver
Date: Thu, 17 Mar 2011 10:36:51 +0100
Message-ID: <1300354614-24056-1-git-send-email-philippe.langlais@stericsson.com>
X-Mailer: git-send-email 1.7.3.1
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Philippe Langlais <philippe.langlais@linaro.org>

The following series provides a start point for a generic STM char driver compliant to MIPI System Trace Protocol v1.0,
all the necessary for its instanciation on ST-Ericsson Ux500 platforms
and few hooks in the standard kernel tracing infrastructure.
For complete description see embedded Documentation/trace/stm-trace.txt.

Philippe

Philippe Langlais (3):
  STM: MIPI System Trace Module char driver
  mach-ux500: MIPI System Trace Module platform dependent driver part
  trace: add STM trace hooks for printk, trace_printk, trace_function, 
       stack trace and scheduler wakeup/context switch tracing

 Documentation/trace/stm-trace.txt              |  193 ++++++
 arch/arm/mach-ux500/cpu-db5500.c               |    4 +
 arch/arm/mach-ux500/cpu-db8500.c               |    4 +
 arch/arm/mach-ux500/devices-db8500.c           |  181 ++++++
 arch/arm/mach-ux500/include/mach/db5500-regs.h |    2 +
 arch/arm/mach-ux500/include/mach/devices.h     |    1 +
 arch/arm/mach-ux500/include/mach/prcmu-regs.h  |    4 +
 drivers/misc/Kconfig                           |    1 +
 drivers/misc/Kconfig.stm                       |  114 ++++
 drivers/misc/Makefile                          |    1 +
 drivers/misc/stm.c                             |  797 ++++++++++++++++++++++++
 include/Kbuild                                 |    1 +
 include/trace/Kbuild                           |    1 +
 include/trace/stm.h                            |  223 +++++++
 kernel/printk.c                                |    4 +
 kernel/trace/trace.c                           |   10 +
 kernel/trace/trace_events.c                    |    3 +
 kernel/trace/trace_sched_switch.c              |   10 +
 18 files changed, 1554 insertions(+), 0 deletions(-)
 create mode 100644 Documentation/trace/stm-trace.txt
 create mode 100644 drivers/misc/Kconfig.stm
 create mode 100644 drivers/misc/stm.c
 create mode 100644 include/trace/Kbuild
 create mode 100644 include/trace/stm.h

-- 
1.7.3.1

