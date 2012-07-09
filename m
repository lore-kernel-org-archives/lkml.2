Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752010Ab2GIS5d (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jul 2012 14:57:33 -0400
Received: from eusmtp01.atmel.com ([212.144.249.242]:61822 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751538Ab2GIS5c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jul 2012 14:57:32 -0400
Message-ID: <4FFB299D.7030902@atmel.com>
Date: Mon, 9 Jul 2012 20:57:33 +0200
From: Nicolas Ferre <nicolas.ferre@atmel.com>
Organization: atmel
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120615 Thunderbird/13.0.1
MIME-Version: 1.0
To: linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        Arnd Bergmann <arnd@arndb.de>, Olof Johansson <olof@lixom.net>
CC: Linux Kernel list <linux-kernel@vger.kernel.org>,
        "Jean-Christophe PLAGNIOL-VILLARD" <plagnioj@jcrosoft.com>,
        Fabio Porcedda <fabio.porcedda@gmail.com>,
        =?UTF-8?B?UHJjaGFsIEppxZnDrQ==?= <jiri.prchal@aksignal.cz>
Subject: [GIT PULL] at91: a little dt pull request for 3.6
X-Enigmail-Version: 1.4.2
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.159.245.112]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Arnd, hi Olof,

The following changes since commit bd0a521e88aa7a06ae7aabaed7ae196ed4ad867a:

  Linux 3.5-rc6 (2012-07-07 17:23:56 -0700)

are available in the git repository at:

  git://github.com/at91linux/linux-at91.git tags/at91-for-next-dt

for you to fetch changes up to 3c68bb48214f87562b6956195178d991403d66d4:

  ARM: at91: Add support for board aks-cdu (2012-07-09 20:45:31 +0200)

----------------------------------------------------------------
Two new boards described with device tree

----------------------------------------------------------------
Fabio Porcedda (1):
      ARM: at91: add support for Telit EVK-PRO3 with Telit GE863-PRO3

Jiri Prchal (1):
      ARM: at91: Add support for board aks-cdu

 arch/arm/boot/dts/aks-cdu.dts     |  113 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 arch/arm/boot/dts/evk-pro3.dts    |   41 +++++++++++++++++++++++++++++++
 arch/arm/boot/dts/ge863-pro3.dtsi |   52 +++++++++++++++++++++++++++++++++++++++
 arch/arm/mach-at91/Makefile.boot  |    2 ++
 4 files changed, 208 insertions(+)
 create mode 100644 arch/arm/boot/dts/aks-cdu.dts
 create mode 100644 arch/arm/boot/dts/evk-pro3.dts
 create mode 100644 arch/arm/boot/dts/ge863-pro3.dtsi

Thanks, best regards,
-- 
Nicolas Ferre

