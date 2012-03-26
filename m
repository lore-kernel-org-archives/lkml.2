Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757388Ab2CZNIo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Mar 2012 09:08:44 -0400
Received: from newsmtp5.atmel.com ([204.2.163.5]:7123 "EHLO sjogate2.atmel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757263Ab2CZNIn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Mar 2012 09:08:43 -0400
Message-ID: <4F706A3A.1070309@atmel.com>
Date: Mon, 26 Mar 2012 15:08:10 +0200
From: Nicolas Ferre <nicolas.ferre@atmel.com>
Organization: atmel
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:11.0) Gecko/20120310 Thunderbird/11.0
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>, Olof Johansson <olof@lixom.net>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>
CC: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        Ludovic Desroches <ludovic.desroches@atmel.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        herbert@gondor.hengli.com.au, "Koul, Vinod" <vinod.koul@intel.com>,
        Linux Kernel list <linux-kernel@vger.kernel.org>
Subject: [GIT PULL] AT91 drivers Kconfig cleanup
X-Enigmail-Version: 1.4
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(previous email without mailing-lists addresses)

Arnd, Olof,

This is a series which deals with AT91 drivers Kconfig entries. Its goal is
to remove too restrictive dependencies on SoC names.
This will allow to add support for newer SoC seamlessly.
Some very "cosmetic" changes are also added (entry names, comments, etc.).

Some patches are dealing with other subsystem Kconfig files. I have
collected
"Acked-by" and included them in this series.

I have built this pull-request on top of arm-soc/next/dt2 branch for
easy merge with
at91 material that is already queued for 3.4. It is for sure a very late
pull request
for 3.4, event though it is non intrusive. So, feel free to delay it to
3.5 or
a "staging" branch...

The following changes since commit 7d1206bc2859c6e9f46e35ae697c138e7d7858a7:

  Merge branch 'kirkwood/dt' into next/dt2 (2012-03-24 19:16:04 +0000)

are available in the git repository at:


  git://github.com/at91linux/linux-at91.git armsoc-next-dt2+at91-kconfig

for you to fetch changes up to 40ef130751f4438ae73603ab00aa2a2590a3201d:

  hwrng: Kconfig: remove dependency for atmel-rng driver (2012-03-26
14:06:23 +0200)

----------------------------------------------------------------
Nicolas Ferre (12):
      ARM: at91: change AT91 Kconfig entry comment
      ARM: at91/Kconfig: change at91sam9g45 entry
      ARM: at91/Kconfig: add comment to at91sam9x5 family entry
      ARM: at91/Kconfig: add clarifications to AT91SAM9M10G45-EK entry
      ARM: at91/Kconfig: add AT91SAM9x5 family to AT91_EARLY_DBGU0 entry
      ARM: at91/Kconfig: website link for AT91SAM9G20-EK
      dmaengine: Kconfig: fix Atmel at_hdmac entry
      mmc: Kconfig: remove choice between at91_mci and atmel-mci
      mmc: atmel-mci: remove the need for CONFIG_MMC_ATMELMCI_DMA
      rtc: Kconfig: remove dependency for AT91 rtc driver
      Input: Kconfig: remove dependency for atmel_tsadcc driver
      hwrng: Kconfig: remove dependency for atmel-rng driver

 arch/arm/Kconfig                  |    4 ++--
 arch/arm/mach-at91/Kconfig        |   21 ++++++++++++++++-----
 drivers/char/hw_random/Kconfig    |    2 +-
 drivers/dma/Kconfig               |    5 ++---
 drivers/input/touchscreen/Kconfig |    4 ++--
 drivers/mmc/host/Kconfig          |   23 ++---------------------
 drivers/mmc/host/atmel-mci.c      |    2 --
 drivers/rtc/Kconfig               |    2 +-
 8 files changed, 26 insertions(+), 37 deletions(-)

Thanks, best regards,
-- 
Nicolas Ferre
