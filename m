Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757205Ab1AMUit (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Jan 2011 15:38:49 -0500
Received: from newsmtp5.atmel.com ([204.2.163.5]:17948 "EHLO
	sjogate2.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756950Ab1AMUio (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Jan 2011 15:38:44 -0500
Subject: [GIT PULL] AVR32 update for 2.6.38
From: Hans-Christian Egtvedt <hans-christian.egtvedt@atmel.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: AVR32 Linux Kernel <kernel@avr32linux.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Organization: Atmel Corporation
Date: Thu, 13 Jan 2011 21:02:26 +0100
Message-ID: <1294948946.26709.8.camel@hcegtvedt>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 13 Jan 2011 20:02:27.0825 (UTC) FILETIME=[CD9E2E10:01CBB35C]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull

  git://git.kernel.org/pub/scm/linux/kernel/git/egtvedt/avr32-2.6.git for-linus

to receive the following updates for 2.6.38.

Hans-Christian Egtvedt (4):
      avr32: disable kprobes for all default configurations
      avr32: use syscall prototypes from asm-generic instead of arch
      avr32: make architecture sys_clone prototype match asm-generic prototype
      avr32: update default configuration files for Atmel boards

John Stultz (1):
      avr32: Convert to clocksource_register_hz

Vasiliy Kulikov (1):
      avr32: boards: setup: use IS_ERR() instead of NULL check

 arch/avr32/boards/atngw100/setup.c                 |    2 +-
 arch/avr32/boards/atstk1000/atstk1002.c            |    2 +-
 arch/avr32/boards/favr-32/setup.c                  |    2 +-
 arch/avr32/boards/hammerhead/setup.c               |    2 +-
 arch/avr32/boards/merisc/setup.c                   |    2 +-
 arch/avr32/boards/mimc200/setup.c                  |    2 +-
 arch/avr32/configs/atngw100_defconfig              |   23 ++---
 arch/avr32/configs/atngw100_evklcd100_defconfig    |   17 ++--
 arch/avr32/configs/atngw100_evklcd101_defconfig    |   17 ++--
 arch/avr32/configs/atngw100mkii_defconfig          |   22 ++--
 .../avr32/configs/atngw100mkii_evklcd100_defconfig |   17 ++--
 .../avr32/configs/atngw100mkii_evklcd101_defconfig |   17 ++--
 arch/avr32/configs/atstk1002_defconfig             |   25 ++---
 arch/avr32/configs/atstk1003_defconfig             |   41 ++++----
 arch/avr32/configs/atstk1004_defconfig             |  109 +++++++++++++++++---
 arch/avr32/configs/atstk1006_defconfig             |   23 ++---
 arch/avr32/configs/favr-32_defconfig               |    2 +-
 arch/avr32/configs/hammerhead_defconfig            |    2 +-
 arch/avr32/include/asm/syscalls.h                  |   14 ---
 arch/avr32/kernel/process.c                        |    9 +-
 arch/avr32/kernel/time.c                           |    5 +-
 21 files changed, 206 insertions(+), 149 deletions(-)

-- 
Best regards,
Hans-Christian Egtvedt

