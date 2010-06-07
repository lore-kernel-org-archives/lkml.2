Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753171Ab0FGSbG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jun 2010 14:31:06 -0400
Received: from mail-px0-f174.google.com ([209.85.212.174]:61071 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751451Ab0FGSbF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jun 2010 14:31:05 -0400
From: Himanshu Chauhan <hschauhan@nulltrace.org>
To: ralf@linux-mips.org
Cc: linux-kernel@vger.kernel.org, linux-mips@linux-mips.org,
       Himanshu Chauhan <hschauhan@nulltrace.org>
Subject: [PATCH] Kprobes support for MIPS architecture.
Date: Mon,  7 Jun 2010 22:03:59 +0530
Message-Id: <1275928440-21052-1-git-send-email-hschauhan@nulltrace.org>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an initial draft of Kprobes support for MIPS architecture.
It is based on a patch series submitted on CELinux mailing list
from Sony for 2.6.16 series. Since then many things changed including
APIs and file paths. So this is essentially a patch replayed on
latest series.

Please review and provide your feedback.

Signed-off-by: Himanshu Chauhan <hschauhan@nulltrace.org>
---
Himanshu Chauhan (1):
  MIPS: KProbes support v0.1

 arch/mips/Kconfig               |   13 ++
 arch/mips/include/asm/kdebug.h  |    5 +
 arch/mips/include/asm/kprobes.h |   85 +++++++++
 arch/mips/kernel/Makefile       |    2 +
 arch/mips/kernel/genex.S        |    6 +
 arch/mips/kernel/kprobes.c      |  380 +++++++++++++++++++++++++++++++++++++++
 arch/mips/kernel/traps.c        |   40 ++++-
 arch/mips/mm/fault.c            |   11 +-
 8 files changed, 539 insertions(+), 3 deletions(-)
 create mode 100644 arch/mips/include/asm/kprobes.h
 create mode 100644 arch/mips/kernel/kprobes.c

