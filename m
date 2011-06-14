Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753739Ab1FNMds (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jun 2011 08:33:48 -0400
Received: from newsmtp5.atmel.com ([204.2.163.5]:8436 "EHLO sjogate2.atmel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750912Ab1FNMdr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jun 2011 08:33:47 -0400
Subject: [GIT PULL] AVR32 update for 3.0
From: Hans-Christian Egtvedt <hans-christian.egtvedt@atmel.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: AVR32 Linux Kernel <kernel@avr32linux.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Organization: Atmel Corporation
Date: Tue, 14 Jun 2011 14:33:16 +0200
Message-ID: <1308054796.16682.14.camel@hcegtvedt.norway.atmel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 14 Jun 2011 12:33:20.0424 (UTC) FILETIME=[3E811A80:01CC2A8F]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

please pull

  git://git.kernel.org/pub/scm/linux/kernel/git/egtvedt/avr32-2.6.git for-linus

to receive the following updates for 3.0

Hans-Christian Egtvedt (4):
      avr32: fix use of non-existing portnr variable in at32_map_usart()
      avr32/at32ap: fix mapping of platform device id for USART
      avr32: set CONFIG_CC_OPTIMIZE_FOR_SIZE=y for all defconfigs
      avr32: make intc_resume() return void to conform to syscore_ops

Mathias Krause (1):
      avr32, exec: remove redundant set_fs(USER_DS)

Nicolas Ferre (1):
      avr32: add some more at91 to cpu.h definition

 arch/avr32/configs/atngw100_defconfig              |    1 -
 arch/avr32/configs/atngw100_evklcd100_defconfig    |    1 -
 arch/avr32/configs/atngw100_evklcd101_defconfig    |    1 -
 arch/avr32/configs/atngw100_mrmt_defconfig         |    1 -
 arch/avr32/configs/atngw100mkii_defconfig          |    1 -
 .../avr32/configs/atngw100mkii_evklcd100_defconfig |    1 -
 .../avr32/configs/atngw100mkii_evklcd101_defconfig |    1 -
 arch/avr32/configs/atstk1002_defconfig             |    1 -
 arch/avr32/configs/atstk1003_defconfig             |    1 -
 arch/avr32/configs/atstk1004_defconfig             |    1 -
 arch/avr32/configs/atstk1006_defconfig             |    1 -
 arch/avr32/configs/favr-32_defconfig               |    1 -
 arch/avr32/configs/hammerhead_defconfig            |    1 -
 arch/avr32/configs/merisc_defconfig                |    1 -
 arch/avr32/configs/mimc200_defconfig               |    1 -
 arch/avr32/include/asm/processor.h                 |    1 +
 arch/avr32/mach-at32ap/at32ap700x.c                |    3 +--
 arch/avr32/mach-at32ap/include/mach/cpu.h          |   12 ------------
 arch/avr32/mach-at32ap/intc.c                      |    4 +++-
 19 files changed, 5 insertions(+), 30 deletions(-)

-- 
Hans-Christian Egtvedt

