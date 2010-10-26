Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758274Ab0JZImZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Oct 2010 04:42:25 -0400
Received: from newsmtp5.atmel.com ([204.2.163.5]:60073 "EHLO
	sjogate2.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751095Ab0JZImY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Oct 2010 04:42:24 -0400
Message-ID: <4CC69443.9090109@atmel.com>
Date: Tue, 26 Oct 2010 10:41:39 +0200
From: Nicolas Ferre <nicolas.ferre@atmel.com>
Organization: atmel
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; fr; rv:1.9.2.11) Gecko/20101013 Lightning/1.0b2 Thunderbird/3.1.5
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Andrew Victor <linux@maxim.org.za>,
        Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        "'linux-arm-kernel@lists.infradead.org'" 
	<linux-arm-kernel@lists.infradead.org>,
        Linux Kernel list <linux-kernel@vger.kernel.org>,
        Peter Horton <phorton@bitbox.co.uk>, pgsellmann@portner-elektronik.at
Subject: [GITT PULL] AT91: 2.6.37 merge window
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Could you please pull the following:

  git://github.com/at91linux/linux-2.6-at91.git for_linus

This contains a set of AT91 updates for 2.6.37 merge 
window. All has been discussed on the arm-linux mailing 
list. It is based on your tree:
commit b18cae4224bde7e5a332c19bc99247b2098ea232

Nicolas Ferre (7):
      AT91: trivial: align comment of at91sam9g20_reset with one more tab
      AT91: reset routine cleanup, remove not needed icache flush
      AT91: reset: extend alternate reset procedure to several chips
      AT91: pm: use plain cpu_do_idle() for "wait for interrupt"
      AT91: pm: make sure that r0 is 0 when dealing with cache operations
      at91/atmel-mci: inclusion of sd/mmc driver in at91sam9g45 chip and board
      AT91: rtc: enable built-in RTC in Kconfig for at91sam9g45 family

Peter Gsellmann (1):
      AT91: add board support for Pcontrol_G20

Peter Horton (1):
      AT91: Fix AT91SAM9G20 reset as per the errata in the data sheet

 arch/arm/configs/pcontrol_g20_defconfig  |  175 ++++++++++++++++
 arch/arm/mach-at91/Kconfig               |    6 +
 arch/arm/mach-at91/Makefile              |   13 +-
 arch/arm/mach-at91/at91sam9260.c         |    7 +-
 arch/arm/mach-at91/at91sam9261.c         |    7 +-
 arch/arm/mach-at91/at91sam9263.c         |    7 +-
 arch/arm/mach-at91/at91sam9_alt_reset.S  |   48 +++++
 arch/arm/mach-at91/at91sam9g45_devices.c |  165 +++++++++++++++
 arch/arm/mach-at91/at91sam9rl.c          |    7 +-
 arch/arm/mach-at91/board-pcontrol-g20.c  |  322 ++++++++++++++++++++++++++++++
 arch/arm/mach-at91/board-sam9m10g45ek.c  |   24 +++
 arch/arm/mach-at91/generic.h             |    3 +
 arch/arm/mach-at91/pm.c                  |   15 +-
 arch/arm/mach-at91/pm.h                  |    5 +
 arch/arm/mach-at91/pm_slowclock.S        |    1 +
 drivers/mmc/host/Kconfig                 |    2 +-
 drivers/rtc/Kconfig                      |   12 +-
 17 files changed, 778 insertions(+), 41 deletions(-)
 create mode 100644 arch/arm/configs/pcontrol_g20_defconfig
 create mode 100644 arch/arm/mach-at91/at91sam9_alt_reset.S
 create mode 100644 arch/arm/mach-at91/board-pcontrol-g20.c

Thanks a lot, best regards,
-- 
Nicolas Ferre

