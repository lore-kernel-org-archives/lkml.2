Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761651Ab2CPMRq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Mar 2012 08:17:46 -0400
Received: from david.siemens.de ([192.35.17.14]:28515 "EHLO david.siemens.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761565Ab2CPMRh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Mar 2012 08:17:37 -0400
From: Jan Kiszka <jan.kiszka@siemens.com>
To: Jason Wessel <jason.wessel@windriver.com>
Cc: linux-kernel@vger.kernel.org, kgdb-bugreport@lists.sourceforge.net,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>, x86@kernel.org
Subject: [PATCH 0/4] kgdb: Small usability improvements for x86
Date: Fri, 16 Mar 2012 13:17:10 +0100
Message-Id: <cover.1331900215.git.jan.kiszka@siemens.com>
X-Mailer: git-send-email 1.7.3.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[resent due to wrong list CC in first round]

This cleans up the "info register" result on x86 and adds gdb detach on
reboot/shutdown for this target arch. See patches for details.

CC: "H. Peter Anvin" <hpa@zytor.com>
CC: Ingo Molnar <mingo@redhat.com>
CC: Thomas Gleixner <tglx@linutronix.de>
CC: x86@kernel.org

Jan Kiszka (4):
  kgdb: x86: Return all segment registers also in 64-bit mode
  kgdb: Make gdbstub_exit a nop unless gdb is attached
  kgdb: Respect that flush op is optional
  kgdb: x86: Detach gdb if machine shuts down or reboots

 arch/x86/include/asm/kgdb.h |    6 +++++-
 arch/x86/kernel/kgdb.c      |    6 ++++--
 arch/x86/kernel/reboot.c    |    6 ++++++
 include/linux/kgdb.h        |    1 +
 kernel/debug/gdbstub.c      |    6 +++++-
 5 files changed, 21 insertions(+), 4 deletions(-)

-- 
1.7.3.4

