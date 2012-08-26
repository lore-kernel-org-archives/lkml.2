Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754573Ab2HZOep (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Aug 2012 10:34:45 -0400
Received: from antcom.de ([188.40.178.216]:36423 "EHLO chuck.antcom.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753315Ab2HZOeo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Aug 2012 10:34:44 -0400
Message-ID: <503A3402.7090508@antcom.de>
Date: Sun, 26 Aug 2012 16:34:42 +0200
From: Roland Stigge <stigge@antcom.de>
Organization: ANTCOM Open Source Research and Development
User-Agent: Mozilla/5.0 (X11; Linux i686 on x86_64; rv:10.0.5) Gecko/20120624 Icedove/10.0.5
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>
CC: "arm@kernel.org" <arm@kernel.org>, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, bigeasy@linutronix.de,
        aletes.xgr@gmail.com, kevin.wells@nxp.com, srinivas.bakki@nxp.com,
        Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
Subject: Re: [GIT PULL] ARM: mach-pnx4008: Remove architecture
References: <1345724548-18130-1-git-send-email-stigge@antcom.de> <50378084.3080102@antcom.de> <201208260441.25905.arnd@arndb.de>
In-Reply-To: <201208260441.25905.arnd@arndb.de>
X-Enigmail-Version: 1.4.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 26/08/12 06:41, Arnd Bergmann wrote:
> On Friday 24 August 2012, Roland Stigge wrote:
>> On 23/08/12 14:22, Roland Stigge wrote:
>>> This patch removes the ARM architecture mach-pnx4008. No direct support or user
>>> feedback since 2006. Acknowledgements from NXP/Philips and Linux arm-soc
>>> maintainers.
>>>
>>> Signed-off-by: Roland Stigge <stigge@antcom.de>
>>
>> The patch was a bit too big for the mailing list - sorry.
>>
>> Now re-proposing via pull request, below.
> 
> I think the removal of the frame buffer driver should go separately via the
> framebuffer maintainer (Florian Schandinat), I can take the rest through the
> arm-soc tree.

Fine - consider the new pull request for arch-pnx4008, below.

(Patch for video is separate, now.)

Thanks,

Roland


The following changes since commit fea7a08acb13524b47711625eebea40a0ede69a0:

  Linux 3.6-rc3 (2012-08-22 13:29:06 -0700)

are available in the git repository at:

  git://git.antcom.de/linux-2.6.git pnx4008-removal

for you to fetch changes up to d684f05f2d55655eee93d86974e9271010aaed09:

  ARM: mach-pnx4008: Remove architecture (2012-08-26 16:30:37 +0200)

----------------------------------------------------------------
Roland Stigge (1):
      ARM: mach-pnx4008: Remove architecture

 arch/arm/Kconfig                                  |    8 -
 arch/arm/Makefile                                 |    1 -
 arch/arm/configs/pnx4008_defconfig                |  472 -----------------------------
 arch/arm/mach-pnx4008/Makefile                    |   12 -
 arch/arm/mach-pnx4008/Makefile.boot               |    4 -
 arch/arm/mach-pnx4008/clock.c                     | 1001 ------------------------------------------------------------
 arch/arm/mach-pnx4008/clock.h                     |   43 ---
 arch/arm/mach-pnx4008/core.c                      |  290 ------------------
 arch/arm/mach-pnx4008/dma.c                       | 1105 -------------------------------------------------------------------
 arch/arm/mach-pnx4008/gpio.c                      |  328 --------------------
 arch/arm/mach-pnx4008/i2c.c                       |   86 ------
 arch/arm/mach-pnx4008/include/mach/clock.h        |   62 ----
 arch/arm/mach-pnx4008/include/mach/debug-macro.S  |   21 --
 arch/arm/mach-pnx4008/include/mach/dma.h          |  160 ----------
 arch/arm/mach-pnx4008/include/mach/entry-macro.S  |  116 -------
 arch/arm/mach-pnx4008/include/mach/gpio-pnx4008.h |  241 ---------------
 arch/arm/mach-pnx4008/include/mach/hardware.h     |   32 --
 arch/arm/mach-pnx4008/include/mach/irq.h          |   42 ---
 arch/arm/mach-pnx4008/include/mach/irqs.h         |  215 -------------
 arch/arm/mach-pnx4008/include/mach/param.h        |   21 --
 arch/arm/mach-pnx4008/include/mach/platform.h     |   69 -----
 arch/arm/mach-pnx4008/include/mach/pm.h           |   33 --
 arch/arm/mach-pnx4008/include/mach/timex.h        |   19 --
 arch/arm/mach-pnx4008/include/mach/uncompress.h   |   46 ---
 arch/arm/mach-pnx4008/irq.c                       |  121 --------
 arch/arm/mach-pnx4008/pm.c                        |  153 ----------
 arch/arm/mach-pnx4008/serial.c                    |   67 -----
 arch/arm/mach-pnx4008/sleep.S                     |  195 ------------
 arch/arm/mach-pnx4008/time.c                      |  134 ---------
 arch/arm/mach-pnx4008/time.h                      |   70 -----
 arch/arm/tools/mach-types                         |    1 -
 drivers/i2c/busses/Kconfig                        |    2 +-
 drivers/usb/Kconfig                               |    1 -
 drivers/usb/host/Kconfig                          |    2 +-
 drivers/usb/host/ohci-hcd.c                       |    2 +-
 drivers/usb/host/ohci-nxp.c                       |   84 +-----
 drivers/watchdog/Kconfig                          |    6 +-
 37 files changed, 7 insertions(+), 5258 deletions(-)
 delete mode 100644 arch/arm/configs/pnx4008_defconfig
 delete mode 100644 arch/arm/mach-pnx4008/Makefile
 delete mode 100644 arch/arm/mach-pnx4008/Makefile.boot
 delete mode 100644 arch/arm/mach-pnx4008/clock.c
 delete mode 100644 arch/arm/mach-pnx4008/clock.h
 delete mode 100644 arch/arm/mach-pnx4008/core.c
 delete mode 100644 arch/arm/mach-pnx4008/dma.c
 delete mode 100644 arch/arm/mach-pnx4008/gpio.c
 delete mode 100644 arch/arm/mach-pnx4008/i2c.c
 delete mode 100644 arch/arm/mach-pnx4008/include/mach/clock.h
 delete mode 100644 arch/arm/mach-pnx4008/include/mach/debug-macro.S
 delete mode 100644 arch/arm/mach-pnx4008/include/mach/dma.h
 delete mode 100644 arch/arm/mach-pnx4008/include/mach/entry-macro.S
 delete mode 100644 arch/arm/mach-pnx4008/include/mach/gpio-pnx4008.h
 delete mode 100644 arch/arm/mach-pnx4008/include/mach/hardware.h
 delete mode 100644 arch/arm/mach-pnx4008/include/mach/irq.h
 delete mode 100644 arch/arm/mach-pnx4008/include/mach/irqs.h
 delete mode 100644 arch/arm/mach-pnx4008/include/mach/param.h
 delete mode 100644 arch/arm/mach-pnx4008/include/mach/platform.h
 delete mode 100644 arch/arm/mach-pnx4008/include/mach/pm.h
 delete mode 100644 arch/arm/mach-pnx4008/include/mach/timex.h
 delete mode 100644 arch/arm/mach-pnx4008/include/mach/uncompress.h
 delete mode 100644 arch/arm/mach-pnx4008/irq.c
 delete mode 100644 arch/arm/mach-pnx4008/pm.c
 delete mode 100644 arch/arm/mach-pnx4008/serial.c
 delete mode 100644 arch/arm/mach-pnx4008/sleep.S
 delete mode 100644 arch/arm/mach-pnx4008/time.c
 delete mode 100644 arch/arm/mach-pnx4008/time.h
