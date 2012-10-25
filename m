Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965408Ab2JYH6k (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2012 03:58:40 -0400
Received: from eusmtp01.atmel.com ([212.144.249.243]:53035 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934741Ab2JYH6i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2012 03:58:38 -0400
Message-ID: <5088F131.5040600@atmel.com>
Date: Thu, 25 Oct 2012 09:58:41 +0200
From: Nicolas Ferre <nicolas.ferre@atmel.com>
Organization: atmel
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121011 Thunderbird/16.0.1
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>, Olof Johansson <olof@lixom.net>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        Linux Kernel list <linux-kernel@vger.kernel.org>
CC: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        "Ludovic Desroches" <ludovic.desroches@atmel.com>,
        Nicolas FERRE <nicolas.ferre@atmel.com>, voice <voice.shen@atmel.com>,
        "Wu, Josh" <Josh.wu@atmel.com>, <marek.belisko@open-nandra.com>,
        <ivan.shugov@gmail.com>
Subject: [GIT PULL] at91: fixes for 3.7-rc3
X-Enigmail-Version: 1.4.5
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.161.30.18]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Arnd, Olof,

This is the first Atmel AT91 "fixes" update for the 3.7 kernel.

The following changes since commit 6f0c0580b70c89094b3422ba81118c7b959c7556:

  Linux 3.7-rc2 (2012-10-20 12:11:32 -0700) 

are available in the git repository at:

  git://github.com/at91linux/linux-at91.git tags/at91-fixes

for you to fetch changes up to 08d04a135a1c2e24c4d4bc7bbafee5e0e58f80c6:

  ARM: at91: drop duplicated config SOC_AT91SAM9 entry (2012-10-24 18:08:48 +0200)

----------------------------------------------------------------
A mix of typos and critical fixes.
The most important ones are a duplicated definition of a Kconfig
variable and the handling of external interrupts for non-DT case.
The new at91sam9g10 was suffering a recognition issue due to an ID
mis-interpreted: this was leading to a kernel panic.

----------------------------------------------------------------
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

Thanks, best regards,
-- 
Nicolas Ferre
