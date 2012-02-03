Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756712Ab2BCOy0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Feb 2012 09:54:26 -0500
Received: from newsmtp5.atmel.com ([204.2.163.5]:43788 "EHLO
	sjogate2.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751425Ab2BCOyZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Feb 2012 09:54:25 -0500
Message-ID: <4F2BF512.4020602@atmel.com>
Date: Fri, 03 Feb 2012 15:54:10 +0100
From: Nicolas Ferre <nicolas.ferre@atmel.com>
Organization: atmel
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:9.0) Gecko/20111229 Thunderbird/9.0
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>, Olof Johansson <olof@lixom.net>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>
CC: Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        Linux Kernel list <linux-kernel@vger.kernel.org>
Subject: [GIT PULL] at91: at91sam9x5 family basic support
X-Enigmail-Version: 1.3.4
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Here is the pull request for inclusion of at91sam9x5 family basic support.
I add the cover letter of the patch series that I sent some time ago:

The at91sam9x5 family is an ARM926 based SoC family from Atmel.
five different products are available: sam9g15, sam9g25, sam9g35 sam9x25 and sam9x35.
Evaluation Kits are composed of a CPU Module and a carrier board (with optional screen).
The use of the Device Tree is reducing the amount of code needed for an AT91 based SoC: sam9x5 are the first AT91 SoC that only rely on DT for their hardware configuration.

This pull request goes on top of the at91-3.4-base branch.

The following changes since commit 9918ceafd4a9e013572e03983f528017c29bb1cb:

  ARM: at91: code removal of CAP9 SoC (2012-02-03 13:33:05 +0100)

are available in the git repository at:
  git://github.com/at91linux/linux-at91.git at91-3.4-base+9x5

Dan Liang (2):
      ARM: at91/at91sam9x5: overall definition
      ARM: at91/at91sam9x5: SoC basic support

Nicolas Ferre (4):
      ARM: at91/at91sam9x5: PMC header file
      ARM: at91/at91sam9x5: clock management for at91sam9x5 chip family
      ARM: at91/at91sam9x5: Configuration and Makefile
      ARM: at91/at91sam9x5: Device tree definition files

 arch/arm/boot/dts/at91sam9g25ek.dts                |   37 ++
 arch/arm/boot/dts/at91sam9x5.dtsi                  |  172 +++++++++
 arch/arm/boot/dts/at91sam9x5cm.dtsi                |   14 +
 arch/arm/mach-at91/Kconfig                         |    9 +
 arch/arm/mach-at91/Makefile                        |    1 +
 arch/arm/mach-at91/at91sam9x5.c                    |  373 ++++++++++++++++++++
 arch/arm/mach-at91/board-dt.c                      |    1 +
 arch/arm/mach-at91/clock.c                         |   83 ++++-
 arch/arm/mach-at91/include/mach/at91_pmc.h         |   60 +++-
 arch/arm/mach-at91/include/mach/at91sam9x5.h       |   80 +++++
 .../arm/mach-at91/include/mach/at91sam9x5_matrix.h |   53 +++
 arch/arm/mach-at91/include/mach/hardware.h         |    2 +
 12 files changed, 854 insertions(+), 31 deletions(-)
 create mode 100644 arch/arm/boot/dts/at91sam9g25ek.dts
 create mode 100644 arch/arm/boot/dts/at91sam9x5.dtsi
 create mode 100644 arch/arm/boot/dts/at91sam9x5cm.dtsi
 create mode 100644 arch/arm/mach-at91/at91sam9x5.c
 create mode 100644 arch/arm/mach-at91/include/mach/at91sam9x5.h
 create mode 100644 arch/arm/mach-at91/include/mach/at91sam9x5_matrix.h

Thanks, best regards,
-- 
Nicolas Ferre
