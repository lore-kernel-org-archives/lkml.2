Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756720Ab2BCOfe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Feb 2012 09:35:34 -0500
Received: from newsmtp5.atmel.com ([204.2.163.5]:62261 "EHLO
	sjogate2.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756678Ab2BCOfd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Feb 2012 09:35:33 -0500
Message-ID: <4F2BF09C.3040208@atmel.com>
Date: Fri, 03 Feb 2012 15:35:08 +0100
From: Nicolas Ferre <nicolas.ferre@atmel.com>
Organization: atmel
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:9.0) Gecko/20111229 Thunderbird/9.0
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>, Olof Johansson <olof@lixom.net>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>
CC: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        Linux Kernel list <linux-kernel@vger.kernel.org>,
        "Wu, Josh" <Josh.wu@atmel.com>, Hong XU <hong.xu@atmel.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Maxim Osipov <maxim.osipov@gmail.com>
Subject: [GIT PULL] at91: devices and boards files update for 3.4
X-Enigmail-Version: 1.3.4
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

This is the "rebased" devices and boards update material that did not make it during 3.3 merge window. Like any other AT91 patch series for 3.4, it is based on top of the at91-3.4-base branch (that includes the "CAP9 removal" patch on top of 3.3-rc2 + depends/rmk/for-armsoc).

The following changes since commit 9918ceafd4a9e013572e03983f528017c29bb1cb:

  ARM: at91: code removal of CAP9 SoC (2012-02-03 13:33:05 +0100)

are available in the git repository at:
  git://github.com/at91linux/linux-at91.git at91-3.4-base+device_board

Hong Xu (1):
      ARM: at91: Update struct atmel_nand_data to support PMECC

Josh Wu (2):
      ARM: at91: add clock selection parameter for at91_add_device_isi()
      ARM: at91: add Atmel ISI and ov2640 support on sam9m10g45 board

Maxim Osipov (1):
      ARM: at91: Add external RTC for Flexibity board

Nicolas Ferre (2):
      ARM: at91/dma: remove platform data from DMA controller
      ARM: at91/dma: DMA controller registering with DT support

 arch/arm/mach-at91/at91sam9263_devices.c |   13 +++-
 arch/arm/mach-at91/at91sam9g45_devices.c |  113 +++++++++++++++++++++++++++---
 arch/arm/mach-at91/at91sam9rl_devices.c  |    8 +--
 arch/arm/mach-at91/board-flexibity.c     |   12 +++-
 arch/arm/mach-at91/board-sam9m10g45ek.c  |   80 ++++++++++++++++++++-
 arch/arm/mach-at91/include/mach/board.h  |    6 ++-
 6 files changed, 209 insertions(+), 23 deletions(-)

Thanks, best regards,
-- 
Nicolas Ferre
