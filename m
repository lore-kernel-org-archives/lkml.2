Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932329Ab1FQPD5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Jun 2011 11:03:57 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:39315 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932202Ab1FQPDx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Jun 2011 11:03:53 -0400
MIME-Version: 1.0
From: Grant Likely <grant.likely@secretlab.ca>
Date: Fri, 17 Jun 2011 09:03:33 -0600
X-Google-Sender-Auth: B3NqjOhQRaxw8dJMSxtnmBCLe0Q
Message-ID: <BANLkTim87mTQKxkPOpHcowcAR4PSxyEKqw@mail.gmail.com>
Subject: [GIT PULL] gpio fixes
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit 2c53b436a30867eb6b47dd7bab23ba638d1fb0d2:

  Linux 3.0-rc3 (2011-06-13 15:29:59 -0700)

are available in the git repository at:
  git://git.secretlab.ca/git/linux-2.6 gpio/merge

Ambresh K (1):
      gpio/omap4: Fix missing interrupts during device wakeup due to IOPAD.

Randy Dunlap (2):
      gpio: include linux/gpio.h where needed
      gpio: add GPIOF_ values regardless on kconfig settings

 arch/arm/mach-pxa/spitz_pm.c    |    1 +
 drivers/gpio/gpio-omap.c        |    5 +++--
 drivers/pcmcia/pxa2xx_vpac270.c |    1 +
 include/asm-generic/gpio.h      |   10 ----------
 include/linux/gpio.h            |   11 +++++++++++
 5 files changed, 16 insertions(+), 12 deletions(-)


-- 
Grant Likely, B.Sc., P.Eng.
Secret Lab Technologies Ltd.
