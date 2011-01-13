Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932921Ab1AMJpT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Jan 2011 04:45:19 -0500
Received: from 124x34x33x190.ap124.ftth.ucom.ne.jp ([124.34.33.190]:42871 "EHLO
	master.linux-sh.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932815Ab1AMJoy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Jan 2011 04:44:54 -0500
Date: Thu, 13 Jan 2011 18:42:45 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-sh@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [GIT PULL] rmobile updates for 2.6.38-rc1, part 2.
Message-ID: <20110113094245.GA20807@linux-sh.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Please pull from:

	master.kernel.org:/pub/scm/linux/kernel/git/lethal/sh-2.6.git rmobile-latest

Which contains:

Arnd Hannemann (1):
      ARM: mach-shmobile: sh7372 Enable SDIO IRQs

Magnus Damm (4):
      ARM: mach-shmobile: sh7367 Enable SDIO IRQs
      ARM: mach-shmobile: sh7377 Enable SDIO IRQs
      ARM: mach-shmobile: sh7372 Enable SDIO IRQs for Mackerel
      ARM: mach-shmobile: Kill off unused !gpio_is_valid() case

Simon Horman (2):
      ARM: mach-shmobile: mackerel: SCIF port for earlyprintk when using zboot
      ARM: mach-shmobile: ap4eb: SCIF port for earlyprintk when using zboot

Tony SIM (1):
      ARM: mach-shmobile: mackerel: Add touchscreen ST1232 support

Yusuke Goda (1):
      ARM: mach-shmobile: mackerel: Add support get_cd in CN23

 arch/arm/mach-shmobile/board-ap4evb.c              |    8 ++---
 arch/arm/mach-shmobile/board-g4evm.c               |   15 ++++++++
 arch/arm/mach-shmobile/board-mackerel.c            |   35 ++++++++++++++++----
 .../arm/mach-shmobile/include/mach/head-ap4evb.txt |    7 ++++
 .../mach-shmobile/include/mach/head-mackerel.txt   |    7 ++++
 arch/arm/mach-shmobile/intc-sh7367.c               |    6 ++--
 arch/arm/mach-shmobile/intc-sh7372.c               |    4 +-
 arch/arm/mach-shmobile/intc-sh7377.c               |    4 +-
 8 files changed, 67 insertions(+), 19 deletions(-)
