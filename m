Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933899Ab1IIMnl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Sep 2011 08:43:41 -0400
Received: from newsmtp5.atmel.com ([204.2.163.5]:2757 "EHLO sjogate2.atmel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933296Ab1IIMnk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Sep 2011 08:43:40 -0400
Message-ID: <4E6A09D0.40800@atmel.com>
Date: Fri, 09 Sep 2011 14:42:56 +0200
From: Nicolas Ferre <nicolas.ferre@atmel.com>
Organization: atmel
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:6.0.2) Gecko/20110902 Thunderbird/6.0.2
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>
CC: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        "'linux-arm-kernel@lists.infradead.org'" 
	<linux-arm-kernel@lists.infradead.org>,
        Linux Kernel list <linux-kernel@vger.kernel.org>,
        Josef Holzmayr <holzmayr@rsi-elektrotechnik.de>,
        Nico Erfurth <ne@erfurth.eu>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Andrew Victor <linux@maxim.org.za>
Subject: [GIT PULL] at91: changes for next
X-Enigmail-Version: 1.3.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Arnd,

Can you please pull the following changes since commit ddf28352b80c86754a6424e3a61e8bdf9213b3c7:

  Linux 3.1-rc5 (2011-09-04 15:45:10 -0700)

They are available in the git repository at:
  git://github.com/at91linux/linux-at91.git  at91-next

They have been present on linux-arm-kernel for some time and where recently added in linux-next.
Stephen resolved some trivial conflicts relatives to the removal of a board file (Cf:
https://lkml.org/lkml/2011/9/9/96 ).

A series by Thomas is touching the USB subsystem: ohci-at91.c but as most of changes are in the at91 directory, it makes more sense to take them in arm-soc.


Jean-Christophe PLAGNIOL-VILLARD (2):
      at91: USB-A9G20 C01 & C11 board support
      at91: ohci-at91: always provide all the clocks

Josef Holzmayr (1):
      at91: add support for RSIs EWS board

Nico Erfurth (1):
      at91: merge board USB-A9260 and USB-A9263 together

Thomas Petazzoni (3):
      at91: ohci-at91: add vbus_pin_inverted platform attribute
      at91: at91-ohci: support overcurrent notification
      at91: at91-ohci: configure overcurrent pins as input GPIOs

 arch/arm/mach-at91/Kconfig               |   13 +
 arch/arm/mach-at91/Makefile              |    6 +-
 arch/arm/mach-at91/at91cap9.c            |    2 +
 arch/arm/mach-at91/at91cap9_devices.c    |    6 +
 arch/arm/mach-at91/at91rm9200.c          |    2 +
 arch/arm/mach-at91/at91rm9200_devices.c  |    8 +
 arch/arm/mach-at91/at91sam9260.c         |    2 +
 arch/arm/mach-at91/at91sam9260_devices.c |    8 +
 arch/arm/mach-at91/at91sam9261.c         |   29 ++-
 arch/arm/mach-at91/at91sam9261_devices.c |    8 +
 arch/arm/mach-at91/at91sam9263.c         |    2 +
 arch/arm/mach-at91/at91sam9263_devices.c |    6 +
 arch/arm/mach-at91/at91sam9g45.c         |    2 +
 arch/arm/mach-at91/at91sam9g45_devices.c |    6 +
 arch/arm/mach-at91/board-rsi-ews.c       |  233 ++++++++++++++++++
 arch/arm/mach-at91/board-usb-a9260.c     |  230 ------------------
 arch/arm/mach-at91/board-usb-a9263.c     |  246 -------------------
 arch/arm/mach-at91/board-usb-a926x.c     |  383 ++++++++++++++++++++++++++++++
 arch/arm/mach-at91/include/mach/board.h  |    5 +
 arch/arm/mach-at91/include/mach/timex.h  |    5 +
 drivers/usb/host/ohci-at91.c             |  239 +++++++++++++++++--
 21 files changed, 930 insertions(+), 511 deletions(-)
 create mode 100644 arch/arm/mach-at91/board-rsi-ews.c
 delete mode 100644 arch/arm/mach-at91/board-usb-a9260.c
 delete mode 100644 arch/arm/mach-at91/board-usb-a9263.c
 create mode 100644 arch/arm/mach-at91/board-usb-a926x.c

Thanks, bye,
-- 
Nicolas Ferre

