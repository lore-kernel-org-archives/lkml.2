Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754049Ab0JGR4S (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Oct 2010 13:56:18 -0400
Received: from newsmtp5.atmel.com ([204.2.163.5]:36400 "EHLO
	sjogate2.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753551Ab0JGR4P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Oct 2010 13:56:15 -0400
Message-ID: <4CAE099A.6080807@atmel.com>
Date: Thu, 07 Oct 2010 19:55:38 +0200
From: Nicolas Ferre <nicolas.ferre@atmel.com>
Organization: atmel
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; fr; rv:1.9.2.9) Gecko/20100915 Lightning/1.0b2 Thunderbird/3.1.4
MIME-Version: 1.0
To: Russell King - ARM Linux <linux@arm.linux.org.uk>, davem@davemloft.net
CC: Andrew Victor <linux@maxim.org.za>,
        Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        "'linux-arm-kernel@lists.infradead.org'" 
	<linux-arm-kernel@lists.infradead.org>,
        Linux Kernel list <linux-kernel@vger.kernel.org>, gerg@snapgear.com,
        Hans-Christian Egtvedt <hcegtvedt@atmel.com>
Subject: [GITT PULL] AT91 for 2.6.37 merge window
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Russell,

Could you please pull the following:

  git://github.com/at91linux/linux-2.6-at91.git for_rmk

This contains AT91 update for 2.6.37 merge window. All has been discussed on
the list. 

It if based on linus' tree 2.6.36-rc7 commit cb655d0f3d57c23db51b981648e452988c0223f9


David,

The tiny patch that affects "drivers/net/Kconfig" is pending since beginning of August, I propose to include it through ARM tree as it should not create any merging issue.


Greg Ungerer (1):
      AT91: fix use of clock disable on idle for AT91x40 devices

Jean-Christophe PLAGNIOL-VILLARD (3):
      AT91: at91sam9m10g45ek: use the right machine id
      AT91: at91sam9g20ek: merge 2mmc version in one board
      net: atmel_macb Kconfig: remove long dependency line

Nicolas Ferre (1):
      AT91: Correct configuration define value

 arch/arm/configs/at91sam9g20ek_defconfig       |    1 +
 arch/arm/mach-at91/Kconfig                     |    9 +-
 arch/arm/mach-at91/Makefile                    |    3 +-
 arch/arm/mach-at91/board-at572d940hf_ek.c      |    2 +-
 arch/arm/mach-at91/board-sam9g20ek-2slot-mmc.c |  329 ------------------------
 arch/arm/mach-at91/board-sam9g20ek.c           |   74 +++++-
 arch/arm/mach-at91/board-sam9m10g45ek.c        |    4 +-
 arch/arm/mach-at91/include/mach/at91x40.h      |    6 +
 arch/arm/mach-at91/include/mach/system.h       |    4 +
 arch/avr32/Kconfig                             |    1 +
 drivers/net/Kconfig                            |    5 +-
 11 files changed, 95 insertions(+), 343 deletions(-)
 delete mode 100644 arch/arm/mach-at91/board-sam9g20ek-2slot-mmc.c

Thanks a lot, best regards,
-- 
Nicolas Ferre

