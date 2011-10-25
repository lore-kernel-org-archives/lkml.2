Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755602Ab1JYLV5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Oct 2011 07:21:57 -0400
Received: from newsmtp5.atmel.com ([204.2.163.5]:32696 "EHLO
	sjogate2.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754493Ab1JYLV4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Oct 2011 07:21:56 -0400
Message-ID: <4EA69BC9.8040402@atmel.com>
Date: Tue, 25 Oct 2011 13:21:45 +0200
From: Nicolas Ferre <nicolas.ferre@atmel.com>
Organization: atmel
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:7.0.1) Gecko/20110929 Thunderbird/7.0.1
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>
CC: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        Linux Kernel list <linux-kernel@vger.kernel.org>,
        "'linux-arm-kernel@lists.infradead.org'" 
	<linux-arm-kernel@lists.infradead.org>,
        Rob Herring <robherring2@gmail.com>,
        Grant Likely <grant.likely@secretlab.ca>
Subject: [GIT PULL] at91 device tree basics
X-Enigmail-Version: 1.3.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Arnd,

The following changes since commit c3b92c8787367a8bb53d57d9789b558f1295cc96:

  Linux 3.1 (2011-10-24 09:10:05 +0200)

are available in the git repository at:
  git://github.com/at91linux/linux-at91.git for-arnd/at91-dt

They cover the basic device tree work done during the last moths around both 
at91sam9g45 and at91sam9g20 based board. They have been review by Grant and
Rob. More device tree related stuff is comming ;-)


Jean-Christophe PLAGNIOL-VILLARD (1):
      ARM: at91: add at91sam9g20 and Calao USB A9G20 DT support

Nicolas Ferre (1):
      ARM: at91: dt: at91sam9g45 family and board device tree files

 arch/arm/boot/dts/at91sam9g20.dtsi     |  119 ++++++++++++++++++++++++++++++
 arch/arm/boot/dts/at91sam9g45.dtsi     |  106 +++++++++++++++++++++++++++
 arch/arm/boot/dts/at91sam9m10g45ek.dts |   35 +++++++++
 arch/arm/boot/dts/usb_a9g20.dts        |   30 ++++++++
 arch/arm/mach-at91/Kconfig             |   11 +++
 arch/arm/mach-at91/Makefile            |    3 +
 arch/arm/mach-at91/Makefile.boot       |    2 +
 arch/arm/mach-at91/at91sam9260.c       |    8 ++
 arch/arm/mach-at91/at91sam9g45.c       |    6 ++
 arch/arm/mach-at91/board-dt.c          |  123 ++++++++++++++++++++++++++++++++
 10 files changed, 443 insertions(+), 0 deletions(-)
 create mode 100644 arch/arm/boot/dts/at91sam9g20.dtsi
 create mode 100644 arch/arm/boot/dts/at91sam9g45.dtsi
 create mode 100644 arch/arm/boot/dts/at91sam9m10g45ek.dts
 create mode 100644 arch/arm/boot/dts/usb_a9g20.dts
 create mode 100644 arch/arm/mach-at91/board-dt.c

Thanks, best regards,
-- 
Nicolas Ferre
