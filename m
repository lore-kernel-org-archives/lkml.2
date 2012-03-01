Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759208Ab2CAM6V (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Mar 2012 07:58:21 -0500
Received: from newsmtp5.atmel.com ([204.2.163.5]:55768 "EHLO
	sjogate2.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759113Ab2CAM6T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Mar 2012 07:58:19 -0500
Message-ID: <4F4F7254.9060306@atmel.com>
Date: Thu, 01 Mar 2012 13:57:56 +0100
From: Nicolas Ferre <nicolas.ferre@atmel.com>
Organization: atmel
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.2) Gecko/20120216 Thunderbird/10.0.2
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>, Olof Johansson <olof@lixom.net>
CC: linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        Ludovic Desroches <ludovic.desroches@atmel.com>,
        Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        Linux Kernel list <linux-kernel@vger.kernel.org>
Subject: [GIT PULL] at91: fixes for DMA registration (3.3-rc)
References: <4F4F49E1.4020902@atmel.com> <201203011149.42948.arnd@arndb.de>
In-Reply-To: <201203011149.42948.arnd@arndb.de>
X-Enigmail-Version: 1.3.5
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Arnd,

As discussed on the mailing-list, we experience an out-of-sync situation
between the DMA controller driver and the related code in AT91 devices files.

Those two patches already queued for 3.4 are correcting the problem that we found on
the current 3.3-rc kernels. I have tested that the DMA driver is registering well
with those fixes applied.

Can you please pull them in a "fixes" branch and send them to Linus before 3.3-final?

Thanks for your help.

The following changes since commit 6b21d18ed50c7d145220b0724ea7f2613abf0f95:

  Linux 3.3-rc5 (2012-02-25 12:18:16 -0800)

are available in the git repository at:

  git://github.com/at91linux/linux-at91.git at91-fixes

for you to fetch changes up to 851c52b23c5c27047f1438684750e28c44d73191:

  ARM: at91/dma: DMA controller registering with DT support (2012-02-29 18:20:39 +0100)

----------------------------------------------------------------
Nicolas Ferre (2):
      ARM: at91/dma: remove platform data from DMA controller
      ARM: at91/dma: DMA controller registering with DT support

 arch/arm/mach-at91/at91sam9g45_devices.c |   19 ++++++++++---------
 arch/arm/mach-at91/at91sam9rl_devices.c  |    8 +-------
 2 files changed, 11 insertions(+), 16 deletions(-)

Best regards,
-- 
Nicolas Ferre
