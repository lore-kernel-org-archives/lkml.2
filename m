Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754952Ab2GWUdY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jul 2012 16:33:24 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:55593 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754924Ab2GWUdW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jul 2012 16:33:22 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        arm@kernel.org
Subject: [GIT PULL 13/15] arm-soc: pincontrol drivers
Date: Mon, 23 Jul 2012 22:32:39 +0200
Message-Id: <1343075561-17446-14-git-send-email-arnd@arndb.de>
X-Mailer: git-send-email 1.7.10
In-Reply-To: <1343075561-17446-1-git-send-email-arnd@arndb.de>
References: <1343075561-17446-1-git-send-email-arnd@arndb.de>
X-Provags-ID: V02:K0:dDaDHMAOotZwTvpfqexe1k4w3Z5LJTeGt9RYBBfX7DT
 sLpUc0z5DJI7Uw7h0pZjJeKGpEj6kECBcr/OoQOrR4b6TQ0mfS
 XVBJ3uxWU+PYj54BzXS8/cXuCXLpHYNNT7O9uZ9PypfgLgde6D
 pxijilOVKLH7IYcMaihuw+bfNn4A9aGkGmsK0nJiTCB/bI9LLK
 qeAWBOX5b+cjcff8sv9kHPhxfPnUpKt8EPRJK66fzFuzcwCYXE
 +5NT7sV+99eMdCE/P5nAyK//nCpDz6wYJRfwjcIl8BzGpU+PoR
 0OIWj4GazXXyVGsQC2oG76xPhBleRPWSuiQt2fH4QVofd1moAu
 Ef3hmR0neyOJdEFYm2cUUeNwXj/gauTngbqXHe3a+
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit ca24a145573124732152daff105ba68cc9a2b545:

  Merge branch 'fixes' of git://git.linaro.org/people/rmk/linux-arm (2012-07-01 11:02:25 -0700)

are available in the git repository at:


  git://git.kernel.org/pub/scm/linux/kernel/git/arm/arm-soc.git next/pinctrl

for you to fetch changes up to 8ee41a62a3800b8450985d2970fd985421ad7043:

  Merge branch 'prima2/pinctrl' into next/pinctrl (2012-07-04 16:54:54 +0200)

----------------------------------------------------------------

arm-soc: pincontrol drivers

We are converting platforms to use the pinctrl framework over time,
rather than using platform specific code for the same effect. This
adds the respective driver for the prima2 platform.

----------------------------------------------------------------

Arnd Bergmann (4):
      Merge branch 'prima2/drivers' of git://gitorious.org/sirfprima2-kernel/sirfprima2-kernel into next/pinctrl
      ARM: prima2: enable gpiolib unconditionally
      Merge branch 'prima2/pinctrl' into next/pinctrl
      Merge branch 'next/pinctrl' into for-next

Barry Song (1):
      PINCTRL: SiRF: add GPIO and GPIO irq support in CSR SiRFprimaII

 arch/arm/Kconfig                         |    1 +
 arch/arm/mach-prima2/include/mach/gpio.h |   13 +
 arch/arm/mach-prima2/include/mach/irqs.h |    2 +-
 drivers/pinctrl/pinctrl-sirf.c           |  489 +++++++++++++++++++++++++++++-
 4 files changed, 503 insertions(+), 2 deletions(-)
