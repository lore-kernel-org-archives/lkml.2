Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752457Ab2KPPfb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Nov 2012 10:35:31 -0500
Received: from eusmtp01.atmel.com ([212.144.249.242]:53059 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751768Ab2KPPfa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Nov 2012 10:35:30 -0500
Message-ID: <50A65D35.7090307@atmel.com>
Date: Fri, 16 Nov 2012 16:35:17 +0100
From: Nicolas Ferre <nicolas.ferre@atmel.com>
Organization: atmel
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121028 Thunderbird/16.0.2
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>, Olof Johansson <olof@lixom.net>,
        Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
CC: <jhovold@gmail.com>, Nicolas Royer <nicolas@eukrea.com>,
        =?ISO-8859-1?Q?Eric_B=E9nard?= <eric@eukrea.com>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        Linux Kernel list <linux-kernel@vger.kernel.org>
Subject: [GIT PULL] at91: fixes for 3.7-rc6
X-Enigmail-Version: 1.4.5
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.161.30.18]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(Resent with mailing-lists)

Arnd, Olof,

Here is the second at91-fixes pull request for 3.7. I have built it on
top of my previous fixes pull request for this kernel revision.

The following changes since commit 08d04a135a1c2e24c4d4bc7bbafee5e0e58f80c6:

  ARM: at91: drop duplicated config SOC_AT91SAM9 entry (2012-10-24
18:08:48 +0200)

are available in the git repository at:

  git://github.com/at91linux/linux-at91.git tags/at91-fixes

for you to fetch changes up to 641f3ce64b050961d454a0716bb6dbf528315aac:

  ARM: at91/usbh: fix overcurrent gpio setup (2012-11-16 10:46:29 +0100)

----------------------------------------------------------------
Two little fixes, one related to the move to sparse irq and
another one fixing the check of a GPIO for USB host overcurrent.

----------------------------------------------------------------
Johan Hovold (1):
      ARM: at91/usbh: fix overcurrent gpio setup

Nicolas Royer (1):
      ARM: at91/AT91SAM9G45: fix crypto peripherals irq issue due to
sparse irq support

 arch/arm/mach-at91/at91rm9200_devices.c  |  2 +-
 arch/arm/mach-at91/at91sam9260_devices.c |  2 +-
 arch/arm/mach-at91/at91sam9261_devices.c |  2 +-
 arch/arm/mach-at91/at91sam9263_devices.c |  2 +-
 arch/arm/mach-at91/at91sam9g45_devices.c | 12 ++++++------
 5 files changed, 10 insertions(+), 10 deletions(-)

Thanks, best regards,
-- 
Nicolas Ferre
