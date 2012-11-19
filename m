Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753966Ab2KSRrY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Nov 2012 12:47:24 -0500
Received: from eusmtp01.atmel.com ([212.144.249.243]:16125 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752811Ab2KSRrX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Nov 2012 12:47:23 -0500
Message-ID: <50AA70A8.7020204@atmel.com>
Date: Mon, 19 Nov 2012 18:47:20 +0100
From: Nicolas Ferre <nicolas.ferre@atmel.com>
Organization: atmel
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121028 Thunderbird/16.0.2
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>, Olof Johansson <olof@lixom.net>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        Linux Kernel list <linux-kernel@vger.kernel.org>
CC: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        "Ludovic Desroches" <ludovic.desroches@atmel.com>,
        Fabio Porcedda <fabio.porcedda@gmail.com>
Subject: [GIT PULL] at91: DT material for 3.8
X-Enigmail-Version: 1.4.5
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.161.30.18]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Arnd, Olof,

Here is a little update on the DT front for AT91. The biggest part
will come from the pinctrl which is located in Linus Walleij's git tree.

The following changes since commit 77b67063bb6bce6d475e910d3b886a606d0d91f7:

  Linux 3.7-rc5 (2012-11-11 13:44:33 +0100)

are available in the git repository at:

  git://github.com/at91linux/linux-at91.git tags/at91-for-next-dt

for you to fetch changes up to 824b43968fed4b5a200cfef06129c0470eef306a:

  ARM: at91/dts: evk-pro3: enable watchdog (2012-11-16 15:48:48 +0100)

----------------------------------------------------------------
More DT material for AT91:

- conversion of watchdog to DT
- usart definition for evk-pro3 board

----------------------------------------------------------------
Fabio Porcedda (4):
      ARM: at91: dt: evk-pro3: enable uart0 and uart2
      watchdog: at91sam9_wdt: add device tree support
      ARM: at91/dts: add at91sam9_wdt driver to at91sam926x, at91sam9g45
      ARM: at91/dts: evk-pro3: enable watchdog

 Documentation/devicetree/bindings/watchdog/atmel-wdt.txt | 15 +++++++++++++++
 arch/arm/boot/dts/at91sam9260.dtsi                       |  6 ++++++
 arch/arm/boot/dts/at91sam9263.dtsi                       |  6 ++++++
 arch/arm/boot/dts/at91sam9g45.dtsi                       |  6 ++++++
 arch/arm/boot/dts/evk-pro3.dts                           | 12 ++++++++++++
 drivers/watchdog/at91sam9_wdt.c                          | 11 +++++++++++
 6 files changed, 56 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/watchdog/atmel-wdt.txt

Thanks, bye,
-- 
Nicolas Ferre
