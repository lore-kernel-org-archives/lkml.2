Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753141Ab1AYJwM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jan 2011 04:52:12 -0500
Received: from 124x34x33x190.ap124.ftth.ucom.ne.jp ([124.34.33.190]:46816 "EHLO
	master.linux-sh.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751829Ab1AYJwJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jan 2011 04:52:09 -0500
Date: Tue, 25 Jan 2011 18:52:00 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-sh@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [GIT PULL] sh updates for 2.6.38-rc3
Message-ID: <20110125095200.GA18488@linux-sh.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Please pull from:

	master.kernel.org:/pub/scm/linux/kernel/git/lethal/sh-2.6.git sh-fixes-for-linus

Which contains:

Aurelien Jarno (1):
      sh: Fix sh build failure when CONFIG_SFC=m

Guennadi Liakhovetski (1):
      sh: fix MSIOF0 SPI on ecovec: it conflicts with VOU

Magnus Damm (1):
      sh: update INTC to clear IRQ sense valid flag

Nobuhiro Iwamatsu (1):
      sh: Fix build of sh7750 base boards

Paul Mundt (2):
      sh: Fix up breakage from asm-generic/pgtable.h changes.
      sh: support XZ-compressed kernel.

 arch/sh/Kconfig                       |    1 +
 arch/sh/Makefile                      |    3 ++-
 arch/sh/boards/mach-ecovec24/setup.c  |    2 ++
 arch/sh/boot/Makefile                 |   11 +++++++++--
 arch/sh/boot/compressed/Makefile      |    4 +++-
 arch/sh/boot/compressed/misc.c        |    4 ++++
 arch/sh/include/asm/pgtable.h         |    1 +
 arch/sh/kernel/cpu/sh4/setup-sh7750.c |    6 +++---
 arch/sh/kernel/topology.c             |    1 +
 drivers/sh/intc/chip.c                |    6 ++++--
 10 files changed, 30 insertions(+), 9 deletions(-)
