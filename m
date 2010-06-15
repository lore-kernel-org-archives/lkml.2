Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758006Ab0FORMJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jun 2010 13:12:09 -0400
Received: from mail-ww0-f46.google.com ([74.125.82.46]:65499 "EHLO
	mail-ww0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754136Ab0FORMI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jun 2010 13:12:08 -0400
From: Himanshu Chauhan <hschauhan@nulltrace.org>
To: linux-kernel@vger.kernel.org
Cc: ralf@linux-mips.org, linux-mips@linux-mips.org, ddaney@caviumnetworks.com
Subject: [PATCH 0/2] MIPS: Kprobes and Kretprobes Support
Date: Tue, 15 Jun 2010 20:12:47 +0530
Message-Id: <1276612969-13508-1-git-send-email-hschauhan@nulltrace.org>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a set of 2 patches for adding support of kprobes
and kretprobes support on MIPS architecture. All my tests
are done on Qemu's MALTA board. If somebody has _real_ MIPS
machine, I would appreciate a try on the machine.

Signed-off-by: Himanshu Chauhan <hschauhan@nulltrace.org>

---
Himanshu Chauhan (2):
  MIPS: KProbes Support
  MIPS: Kretprobe support

 arch/mips/Kconfig               |   14 ++
 arch/mips/include/asm/break.h   |    2 +
 arch/mips/include/asm/kdebug.h  |    5 +
 arch/mips/include/asm/kprobes.h |   86 +++++++
 arch/mips/kernel/Makefile       |    2 +
 arch/mips/kernel/kprobes.c      |  493 +++++++++++++++++++++++++++++++++++++++
 arch/mips/kernel/traps.c        |   43 ++++-
 arch/mips/mm/fault.c            |   12 +-
 8 files changed, 654 insertions(+), 3 deletions(-)
 create mode 100644 arch/mips/include/asm/kprobes.h
 create mode 100644 arch/mips/kernel/kprobes.c

