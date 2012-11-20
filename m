Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752894Ab2KTI7d (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2012 03:59:33 -0500
Received: from eusmtp01.atmel.com ([212.144.249.242]:17897 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752800Ab2KTI7a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2012 03:59:30 -0500
Message-ID: <50AB466F.5010500@atmel.com>
Date: Tue, 20 Nov 2012 09:59:27 +0100
From: Nicolas Ferre <nicolas.ferre@atmel.com>
Organization: atmel
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121028 Thunderbird/16.0.2
MIME-Version: 1.0
To: Olof Johansson <olof@lixom.net>, Arnd Bergmann <arnd@arndb.de>
CC: Nicolas Ferre <nicolas.ferre@atmel.com>, <linux-mmc@vger.kernel.org>,
        Linux Kernel list <linux-kernel@vger.kernel.org>,
        Ludovic Desroches <ludovic.desroches@atmel.com>,
        Chris Ball <cjb@laptop.org>,
        "Jean-Christophe PLAGNIOL-VILLARD" <plagnioj@jcrosoft.com>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>
Subject: [GIT PULL v2] at91: fixes for 3.7-rc7
References: <50AA5ED5.8090901@atmel.com> <CAOesGMjAYtEkmEYnzCQ4G821BWG9D6LHvgt5aOMJgus_hzFkRA@mail.gmail.com> <50AA6C76.3000606@atmel.com>
In-Reply-To: <50AA6C76.3000606@atmel.com>
X-Enigmail-Version: 1.4.5
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.161.30.18]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Arnd, Olof,

Just for the record, I do not want to put pressure at a such late time in
the 3.7-rc process. So, I just reworked that pull-request because the previous
one was wrong:
- wrong patch content (DT nodes with wrong size)
- not all tags in patches (Jean-Christophe and Arnd tags were missing...)

Just to start from a sane base if I have to rebase this work for 3.8, I let you know
that I have updated this tag...

The following changes since commit 641f3ce64b050961d454a0716bb6dbf528315aac:

  ARM: at91/usbh: fix overcurrent gpio setup (2012-11-16 10:46:29 +0100)

are available in the git repository at:

  git://github.com/at91linux/linux-at91.git tags/at91-fixes

for you to fetch changes up to 6a342d1ee6ff7d5b3e5a0665457f1772e7fe640a:

  ARM: at91/dts: add nodes for atmel hsmci controllers for atmel boards (2012-11-20 09:51:07 +0100)

----------------------------------------------------------------
Add entries for enabling the use of sd/mmc driver on AT91.
Those entries where missing for device tree use on these
platforms.

----------------------------------------------------------------
Ludovic Desroches (3):
      ARM: at91: add clocks for DT entries
      ARM: at91/dts: add nodes for atmel hsmci controllers for atmel SOCs
      ARM: at91/dts: add nodes for atmel hsmci controllers for atmel boards

 arch/arm/boot/dts/at91sam9260.dtsi          |  9 +++++++++
 arch/arm/boot/dts/at91sam9263.dtsi          | 18 ++++++++++++++++++
 arch/arm/boot/dts/at91sam9263ek.dts         | 10 ++++++++++
 arch/arm/boot/dts/at91sam9g20ek_2mmc.dts    | 12 ++++++++++++
 arch/arm/boot/dts/at91sam9g20ek_common.dtsi |  9 +++++++++
 arch/arm/boot/dts/at91sam9g25ek.dts         | 18 ++++++++++++++++++
 arch/arm/boot/dts/at91sam9g45.dtsi          | 18 ++++++++++++++++++
 arch/arm/boot/dts/at91sam9m10g45ek.dts      | 19 +++++++++++++++++++
 arch/arm/boot/dts/at91sam9n12.dtsi          |  9 +++++++++
 arch/arm/boot/dts/at91sam9n12ek.dts         |  9 +++++++++
 arch/arm/boot/dts/at91sam9x5.dtsi           | 18 ++++++++++++++++++
 arch/arm/mach-at91/at91sam9260.c            |  1 +
 arch/arm/mach-at91/at91sam9263.c            |  2 ++
 arch/arm/mach-at91/at91sam9g45.c            |  2 ++
 arch/arm/mach-at91/at91sam9n12.c            |  1 +
 arch/arm/mach-at91/at91sam9x5.c             |  2 ++
 16 files changed, 157 insertions(+)

Bye,
-- 
Nicolas Ferre
