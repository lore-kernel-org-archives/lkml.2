Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753773Ab1KVEDK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Nov 2011 23:03:10 -0500
Received: from e37.co.us.ibm.com ([32.97.110.158]:57897 "EHLO
	e37.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752573Ab1KVEDJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Nov 2011 23:03:09 -0500
Message-ID: <1321934562.4694.4.camel@js-netbook>
Subject: [GIT PULL] time/clocksource changes for 3.3
From: John Stultz <john.stultz@linaro.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: lkml <linux-kernel@vger.kernel.org>, Deepak Saxena <dsaxena@linaro.org>
Date: Mon, 21 Nov 2011 20:02:42 -0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.1- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
x-cbid: 11112204-7408-0000-0000-000000FAD9EA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey Thomas,
	Just wanted to get my current 3.3 queue pulled into -tip for testing.
The clocksource changes have in a few cases been tested and acked by
maintainers, but others have been ignored despite sending them out
periodically over the last year. If you'd rather they go through the
maintainer trees, let me know and I'll yank them. 

thanks
-john

The patches are available in the git repository at:
  git://git.linaro.org/people/jstultz/linux.git fortglx/3.3/tip/timers/core

Dan McGee (1):
      time: fix bogus comment in timekeeping_get_ns_raw

Deepak Saxena (4):
      time: x86: Remove CLOCK_TICK_RATE from tsc code
      time: x86: Remove CLOCK_TICK_RATE from mach_timer.h
      time: x86: Remove CLOCK_TICK_RATE from acpi_pm clocksource driver
      time: x86: Replace LATCH with PIT_LATCH in i8253 clocksource driver

John Stultz (7):
      time: Fix spelling mistakes in new comments
      clocksource: m86k: Convert to clocksource_register_hz/khz
      clocksource: parisc: Convert to clocksource_register_hz/khz
      clocksource: um: Convert to clocksource_register_hz/khz
      clocksource: xtensa: Convert to clocksource_register_hz/khz
      clocksource: cris: Convert to clocksource_register_khz
      clocksource: Convert tcb_clksrc to use clocksource_register_hz/khz

 arch/cris/arch-v32/kernel/time.c        |    4 +---
 arch/m68k/platform/68328/timers.c       |    4 +---
 arch/m68k/platform/coldfire/dma_timer.c |    5 +----
 arch/m68k/platform/coldfire/pit.c       |    4 +---
 arch/m68k/platform/coldfire/sltimers.c  |    4 +---
 arch/m68k/platform/coldfire/timers.c    |    4 +---
 arch/parisc/kernel/time.c               |    6 +-----
 arch/um/kernel/time.c                   |    6 ++----
 arch/x86/include/asm/mach_timer.h       |    2 +-
 arch/x86/kernel/tsc.c                   |    4 ++--
 arch/xtensa/kernel/time.c               |   13 +------------


