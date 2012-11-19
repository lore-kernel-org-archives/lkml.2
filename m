Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753873Ab2KSQ7J (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Nov 2012 11:59:09 -0500
Received: from eusmtp01.atmel.com ([212.144.249.242]:45357 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753136Ab2KSQ7H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Nov 2012 11:59:07 -0500
Message-ID: <50AA6558.1060302@atmel.com>
Date: Mon, 19 Nov 2012 17:59:04 +0100
From: Nicolas Ferre <nicolas.ferre@atmel.com>
Organization: atmel
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121028 Thunderbird/16.0.2
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>, Olof Johansson <olof@lixom.net>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        Linux Kernel list <linux-kernel@vger.kernel.org>
CC: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        "Ludovic Desroches" <ludovic.desroches@atmel.com>,
        Joachim Eastwood <manabian@gmail.com>
Subject: [GIT PULL] at91: header fix for 3.8
X-Enigmail-Version: 1.4.5
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.161.30.18]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Arnd, Olof,

A little fix that goes on top of the modification of headers made
by Jean-Christophe. Obviously, I have placed this one on top of your current
at91/header branch.

The following changes since commit 75984df05d86956541795f01e62d7dc67bc522fd:

  arm: at91: move at91rm9200 rtc header in drivers/rtc (2012-11-06 20:30:52 +0800)

are available in the git repository at:

  git://github.com/at91linux/linux-at91.git tags/at91-header

for you to fetch changes up to 2abb74eaf6e73cb42e87bdc9e9c2535ce485e614:

  atmel: move ATMEL_MAX_UART to platform_data/atmel.h (2012-11-19 17:44:54 +0100)

----------------------------------------------------------------
One fix related to UART for the "headers move" branch

----------------------------------------------------------------
Jean-Christophe PLAGNIOL-VILLARD (1):
      atmel: move ATMEL_MAX_UART to platform_data/atmel.h

 arch/arm/mach-at91/include/mach/hardware.h  | 3 ---
 arch/avr32/mach-at32ap/include/mach/board.h | 1 -
 include/linux/platform_data/atmel.h         | 6 ++++++
 3 files changed, 6 insertions(+), 4 deletions(-)

Thanks, best regards,
-- 
Nicolas Ferre
