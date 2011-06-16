Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754080Ab1FPGy0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jun 2011 02:54:26 -0400
Received: from linux-sh.org ([111.68.239.195]:57814 "EHLO linux-sh.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752034Ab1FPGyW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jun 2011 02:54:22 -0400
Date: Thu, 16 Jun 2011 15:53:42 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-sh@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [GIT PULL] rmobile fixes for 3.0-rc4
Message-ID: <20110616065338.GA17860@linux-sh.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Please pull from:

	master.kernel.org:/pub/scm/linux/kernel/git/lethal/sh-3.x.git rmobile-fixes-for-linus

Which contains:

Kuninori Morimoto (1):
      ARM: mach-shmobile: mackerel: tidyup usbhs driver settings

Magnus Damm (3):
      ARM: mach-shmobile: AG5EVM SDHI1 platform data update
      ARM: mach-shmobile: Mackerel USB platform data update
      ARM: mach-shmobile: sh73a0 gic_arch_extn.irq_set_wake() fix

Paul Mundt (1):
      ARM: mach-shmobile: Correct SCIF port types for SH7367.

 arch/arm/mach-shmobile/board-ag5evm.c   |    4 +-
 arch/arm/mach-shmobile/board-mackerel.c |  208 ++++++++++++++++++++++---------
 arch/arm/mach-shmobile/intc-sh73a0.c    |    6 +
 arch/arm/mach-shmobile/setup-sh7367.c   |   14 +-
 4 files changed, 161 insertions(+), 71 deletions(-)
