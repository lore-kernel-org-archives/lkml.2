Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752567Ab1BVAaA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Feb 2011 19:30:00 -0500
Received: from e6.ny.us.ibm.com ([32.97.182.146]:59737 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751104Ab1BVA37 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Feb 2011 19:29:59 -0500
Subject: [GIT PULL] 2.6.39 clocksource cleanups for tip/timers/clocksource
From: john stultz <johnstul@us.ibm.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: lkml <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 21 Feb 2011 16:29:55 -0800
Message-ID: <1298334595.4222.19.camel@work-vm>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey Thomas,
	Here's my current 2.6.39 clocksource queue for testing in -tip. Let me
know if there's any tweaks you need.

thanks
-john

  git://git.linaro.org/people/jstultz/linux.git fortglx/39/tip/timers/clocksource

John Stultz (7):
      x86: Convert remaining x86 clocksources to clocksource_register_hz/khz
      ia64: convert to clocksource_register_hz/khz
      microblaze: convert to clocksource_register_hz/khz
      alpha: convert to clocksource_register_hz
      sparc: convert to clocksource_register_hz/khz
      mips: convert to clocksource_register_hz/khz
      blackfin: convert to clocksource_register_hz

Russell King - ARM Linux (1):
      Make clocksource name const

 arch/alpha/kernel/time.c                        |    3 +-
 arch/blackfin/kernel/time-ts.c                  |   35 +---------------------
 arch/ia64/kernel/cyclone.c                      |    6 +---
 arch/ia64/kernel/time.c                         |    9 +----
 arch/ia64/sn/kernel/sn2/timer.c                 |    6 +---
 arch/microblaze/kernel/timer.c                  |    6 +---
 arch/mips/alchemy/common/time.c                 |    3 +-
 arch/mips/cavium-octeon/csrc-octeon.c           |    3 +-
 arch/mips/include/asm/time.h                    |    6 ----
 arch/mips/jz4740/time.c                         |    3 +-
 arch/mips/kernel/cevt-txx9.c                    |    3 +-
 arch/mips/kernel/csrc-bcm1480.c                 |    3 +-
 arch/mips/kernel/csrc-ioasic.c                  |    4 +--
 arch/mips/kernel/csrc-powertv.c                 |   35 ++---------------------
 arch/mips/kernel/csrc-r4k.c                     |    4 +--
 arch/mips/kernel/csrc-sb1250.c                  |    3 +-
 arch/mips/kernel/i8253.c                        |    5 +--
 arch/mips/loongson/common/cs5536/cs5536_mfgpt.c |    5 +--
 arch/mips/sgi-ip27/ip27-timer.c                 |    3 +-
 arch/sparc/kernel/time_64.c                     |    4 +--
 arch/x86/kernel/apb_timer.c                     |   10 +------
 arch/x86/kernel/i8253.c                         |    6 +---
 arch/x86/kernel/kvmclock.c                      |    6 +---
 arch/x86/lguest/boot.c                          |    4 +--
 arch/x86/platform/uv/uv_time.c                  |    6 +---
 arch/x86/xen/time.c                             |    6 +---
 drivers/char/hpet.c                             |    6 +---
 drivers/clocksource/cyclone.c                   |   10 +-----
 include/linux/clocksource.h                     |    2 +-
 29 files changed, 33 insertions(+), 172 deletions(-)


