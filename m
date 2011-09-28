Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755214Ab1I1VUI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Sep 2011 17:20:08 -0400
Received: from newsmtp5.atmel.com ([204.2.163.5]:10052 "EHLO
	sjogate2.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755130Ab1I1VUH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Sep 2011 17:20:07 -0400
Message-ID: <4E838F77.2040705@atmel.com>
Date: Wed, 28 Sep 2011 23:19:51 +0200
From: Nicolas FERRE <nicolas.ferre@atmel.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 6.1; fr; rv:1.9.2.13) Gecko/20101207 Thunderbird/3.1.7
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>,
        "'linux-arm-kernel@lists.infradead.org'" 
	<linux-arm-kernel@lists.infradead.org>
CC: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        Linux Kernel list <linux-kernel@vger.kernel.org>
Subject: [GIT PULL] at91 fixes for 3.1
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Antivirus: avast! (VPS 110928-1, 28/09/2011), Outbound message
X-Antivirus-Status: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Arnd,

Here is a couple of fixes that may be included in 3.1-final.
The Kconfig modification will allow to select the PWM driver for SAM9G45 
SoC. This will also benefit to stable kernels.
The new defconfig for SAM9G45 family will allow us to better monitor the 
health of this port through automatic compilation mechanism. I find it 
interesting to have it included the sooner.

The pull is based on the following changes since commit 
a102a9ece5489e1718cd7543aa079082450ac3a2:

   Linux 3.1-rc8 (2011-09-27 15:48:34 -0700)

are available in the git repository at:
   git://github.com/at91linux/linux-at91.git at91-fixes

Nicolas Ferre (2):
   ARM: at91: remove dependency for Atmel PWM driver selector in Kconfig
   ARM: at91: add defconfig for at91sam9g45 family

  arch/arm/configs/at91sam9g45_defconfig |  214 ++++++++++++++++++++++
  drivers/misc/Kconfig                   |    1 -
  2 files changed, 214 insertions(+), 1 deletions(-)
  create mode 100644 arch/arm/configs/at91sam9g45_defconfig

-- 
Nicolas Ferre
