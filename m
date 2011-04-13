Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755673Ab1DMNxw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Apr 2011 09:53:52 -0400
Received: from newsmtp5.atmel.com ([204.2.163.5]:50074 "EHLO
	sjogate2.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751080Ab1DMNxv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Apr 2011 09:53:51 -0400
Subject: [GIT PULL] AVR32 fixes and minor updates for 2.6.39
From: Hans-Christian Egtvedt <hans-christian.egtvedt@atmel.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: AVR32 Linux Kernel <kernel@avr32linux.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Organization: Atmel Corporation
Date: Wed, 13 Apr 2011 15:53:36 +0200
Message-ID: <1302702816.10549.7.camel@hcegtvedt>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 8BIT
X-OriginalArrivalTime: 13 Apr 2011 13:53:38.0387 (UTC) FILETIME=[309F6A30:01CBF9E2]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Linus,

please pull

  git://git.kernel.org/pub/scm/linux/kernel/git/egtvedt/avr32-2.6.git for-linus

to receive the following fixes and minor updates for 2.6.39

Andreas Bießmann (1):
      avr32: add ATAG_BOARDINFO

Ben Hutchings (1):
      avr32: Fix .size directive for cpu_enter_idle

Jean-Christophe PLAGNIOL-VILLARD (1):
      avr32: At32ap: pio fix typo "))" on gpio_irq_unmask prototype

Matt Fleming (1):
      avr32: init cannot ignore signals sent by force_sig_info()

Ole Henrik Jahren (1):
      avr32: fix deadlock when reading clock list in debugfs

Uwe Kleine-König (1):
      don't check platform_get_irq's return value against zero

Wanlong Gao (1):
      fix the wrong argument of the functions definition

 arch/avr32/include/asm/setup.h         |    9 +++++++++
 arch/avr32/kernel/setup.c              |   15 +++++++++++++++
 arch/avr32/kernel/traps.c              |   22 ----------------------
 arch/avr32/mach-at32ap/clock.c         |   24 ++++++++++++++++--------
 arch/avr32/mach-at32ap/extint.c        |   22 +++++++++++-----------
 arch/avr32/mach-at32ap/pio.c           |    2 +-
 arch/avr32/mach-at32ap/pm-at32ap700x.S |    2 +-
 7 files changed, 53 insertions(+), 43 deletions(-)

-- 
Hans-Christian Egtvedt

