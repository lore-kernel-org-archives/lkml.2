Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934675Ab2JXPeG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2012 11:34:06 -0400
Received: from eusmtp01.atmel.com ([212.144.249.242]:11020 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758303Ab2JXPeA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2012 11:34:00 -0400
From: Nicolas Ferre <nicolas.ferre@atmel.com>
To: <plagnioj@jcrosoft.com>, <ludovic.desroches@atmel.com>
CC: <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        <nicolas.ferre@atmel.com>, <voice.shen@atmel.com>,
        <marek.belisko@open-nandra.com>, <ivan.shugov@gmail.com>,
        <josh.wu@atmel.com>
Subject: [PATCH 0/8] at91: 3.7 fixes patch series
Date: Wed, 24 Oct 2012 17:33:49 +0200
Message-ID: <cover.1351092432.git.nicolas.ferre@atmel.com>
X-Mailer: git-send-email 1.7.11.3
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,
I am posting this patch series just before sending a pull-request to Arnd and
Olof.
There are 2 new patches that I have just cooked today about external IRQ
handling: please review.
I would like you to double check that I have not made any mistake while
collecting the other patches...

Thanks, best regards,


Bo Shen (2):
  ARM: at91/i2c: change id to let i2c-gpio work
  ARM: at91/i2c: change id to let i2c-at91 work

Ivan Shugov (1):
  ARM: at91: at91sam9g10: fix SOC type detection

Jean-Christophe PLAGNIOL-VILLARD (1):
  ARM: at91: drop duplicated config SOC_AT91SAM9 entry

Josh Wu (1):
  ARM: at91/tc: fix typo in the DT document

Marek Belisko (1):
  ARM: at91/dts: at91sam9g20ek_common: Fix typos in buttons labels.

Nicolas Ferre (2):
  ARM: at91: fix external interrupts in non-DT case
  ARM: at91: fix external interrupt specification in board code

 Documentation/devicetree/bindings/arm/atmel-at91.txt |  2 +-
 arch/arm/boot/dts/at91sam9g20ek_common.dtsi          |  4 ++--
 arch/arm/mach-at91/Kconfig                           | 10 ++--------
 arch/arm/mach-at91/at91rm9200.c                      |  2 +-
 arch/arm/mach-at91/at91rm9200_devices.c              |  4 ++--
 arch/arm/mach-at91/at91sam9260.c                     |  4 ++--
 arch/arm/mach-at91/at91sam9260_devices.c             |  4 ++--
 arch/arm/mach-at91/at91sam9261.c                     |  4 ++--
 arch/arm/mach-at91/at91sam9261_devices.c             |  4 ++--
 arch/arm/mach-at91/at91sam9263.c                     |  2 +-
 arch/arm/mach-at91/at91sam9263_devices.c             |  4 ++--
 arch/arm/mach-at91/at91sam9rl_devices.c              |  4 ++--
 arch/arm/mach-at91/board-neocore926.c                |  2 +-
 arch/arm/mach-at91/board-sam9261ek.c                 |  2 +-
 arch/arm/mach-at91/board-sam9263ek.c                 |  2 +-
 arch/arm/mach-at91/generic.h                         |  3 ++-
 arch/arm/mach-at91/irq.c                             |  9 +++++++--
 arch/arm/mach-at91/setup.c                           |  4 ++--
 18 files changed, 35 insertions(+), 35 deletions(-)

-- 
1.7.11.3

