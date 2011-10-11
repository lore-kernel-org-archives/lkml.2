Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751147Ab1JKVws (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Oct 2011 17:52:48 -0400
Received: from e5.ny.us.ibm.com ([32.97.182.145]:38818 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750747Ab1JKVwr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Oct 2011 17:52:47 -0400
Subject: [GIT PULL] Small time related cleanups for 3.2
From: john stultz <johnstul@us.ibm.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: lkml <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 11 Oct 2011 14:52:41 -0700
Message-ID: <1318369961.3375.101.camel@work-vm>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
x-cbid: 11101121-5930-0000-0000-00000042906D
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey Thomas,

Just wanted to send you some small time cleanups I've got queued for
3.2.

thanks
-john


The patches are available in the git repository at:
  git://git.linaro.org/people/jstultz/linux.git fortglx/3.2/tip/timers/core

Jamie Iles (1):
      dw_apb_timer: constify clocksource name

John Stultz (1):
      time: Cleanup old CONFIG_GENERIC_TIME references that snuck in

 arch/arm/Kconfig                    |    4 ----
 arch/mn10300/Kconfig                |    3 ---
 arch/tile/Kconfig                   |    3 ---
 arch/tile/configs/tilegx_defconfig  |    1 -
 arch/tile/configs/tilepro_defconfig |    1 -
 arch/um/defconfig                   |    1 -
 arch/xtensa/configs/iss_defconfig   |    1 -
 arch/xtensa/configs/s6105_defconfig |    1 -
 drivers/clocksource/dw_apb_timer.c  |    2 +-
 include/linux/dw_apb_timer.h        |    2 +-
 10 files changed, 2 insertions(+), 17 deletions(-)


