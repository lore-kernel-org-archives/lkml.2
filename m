Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756538Ab1DGSms (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Apr 2011 14:42:48 -0400
Received: from linux-sh.org ([111.68.239.195]:35319 "EHLO linux-sh.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754889Ab1DGSmr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Apr 2011 14:42:47 -0400
Date: Fri, 8 Apr 2011 03:42:41 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-sh@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [GIT PULL] sh fixes for 2.6.39-rc3
Message-ID: <20110407184241.GF8052@linux-sh.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Please pull from:

	master.kernel.org:/pub/scm/linux/kernel/git/lethal/sh-2.6.git sh-fixes-for-linus

Which contains:

Alexandre Courbot (1):
      serial: sh-sci: prevent setup of uninitialized serial console

Nobuhiro Iwamatsu (3):
      sh: sh-sci: Fix double initialization by serial_console_setup
      sh: landisk: Remove mv_nr_irqs
      sh: landisk: Remove whitespace

Paul Mundt (1):
      sh: select ARCH_NO_SYSDEV_OPS.

Yoshihiro Shimoda (2):
      dma: shdma: add checking the DMAOR_AE in sh_dmae_err
      sh: fix build error in board-sh7757lcr.c

 arch/sh/Kconfig                     |    1 +
 arch/sh/boards/board-sh7757lcr.c    |    2 +-
 arch/sh/boards/mach-landisk/setup.c |    5 ++---
 drivers/dma/shdma.c                 |    7 ++++++-
 drivers/tty/serial/sh-sci.c         |   25 ++++++++++++-------------
 5 files changed, 22 insertions(+), 18 deletions(-)
