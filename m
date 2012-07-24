Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754506Ab2GXOBI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jul 2012 10:01:08 -0400
Received: from mx1.redhat.com ([209.132.183.28]:45734 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752616Ab2GXOBH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jul 2012 10:01:07 -0400
Subject: [GIT PULL] C6X changes for v3.6
From: Mark Salter <msalter@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>
Date: Tue, 24 Jul 2012 10:01:03 -0400
Organization: Red Hat, Inc
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-ID: <1343138464.3672.12.camel@deneb.redhat.com>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit 84a1caf1453c3d44050bd22db958af4a7f99315c:

  Linux 3.5-rc7 (2012-07-14 15:40:28 -0700)

are available in the git repository at:

  git://linux-c6x.org/git/projects/linux-c6x-upstreaming.git tags/for-linus

for you to fetch changes up to b9b8722d4704137d1c85b8e62364b487cbbe8bf0:

  C6X: clean up compiler warning (2012-07-18 23:52:54 -0400)

----------------------------------------------------------------
C6X changes for 3.6 merge window.

  - remove use of legacy irqs which really wasn't needed
  - add support for C66x SoC on EVMC6678 board
  - clean up compiler warning

----------------------------------------------------------------
Ken Cox (1):
      C6X: add basic support for TMS320C6678 SoC

Mark Salter (3):
      C6X: remove megamod-pic requirement on direct-mapped core pic
      C6X: remove dependence on legacy IRQs
      C6X: clean up compiler warning

 arch/c6x/boot/dts/evmc6678.dts      |   83 ++++++++++++++++++++
 arch/c6x/boot/dts/tms320c6678.dtsi  |  146 +++++++++++++++++++++++++++++++++++
 arch/c6x/configs/evmc6678_defconfig |   42 ++++++++++
 arch/c6x/include/asm/irq.h          |    2 -
 arch/c6x/kernel/irq.c               |   21 +++---
 arch/c6x/kernel/setup.c             |    4 +
 arch/c6x/kernel/signal.c            |    2 -
 arch/c6x/platforms/Kconfig          |    4 +
 arch/c6x/platforms/megamod-pic.c    |   28 +++++--
 arch/c6x/platforms/plldata.c        |   65 ++++++++++++++++
 10 files changed, 373 insertions(+), 24 deletions(-)
 create mode 100644 arch/c6x/boot/dts/evmc6678.dts
 create mode 100644 arch/c6x/boot/dts/tms320c6678.dtsi
 create mode 100644 arch/c6x/configs/evmc6678_defconfig


