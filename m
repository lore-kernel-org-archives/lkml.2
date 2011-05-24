Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757552Ab1EXVGz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 May 2011 17:06:55 -0400
Received: from eu1sys200aog106.obsmtp.com ([207.126.144.121]:49608 "EHLO
	eu1sys200aog106.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753112Ab1EXVGy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 May 2011 17:06:54 -0400
From: Linus Walleij <linus.walleij@stericsson.com>
To: Grant Likely <grant.likely@secretlab.ca>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>
Cc: Lee Jones <lee.jones@linaro.org>, Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH 0/4] Move U300 and Nomadik GPIO drivers v2
Date: Tue, 24 May 2011 23:06:32 +0200
Message-ID: <1306271192-28911-1-git-send-email-linus.walleij@stericsson.com>
X-Mailer: git-send-email 1.7.3.2
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Linus Walleij <linus.walleij@linaro.org>

This is a rebase of the earlier patch set, due to updates
pulled in to Torvalds tree conflicting with earlier movement
patches.

I also used -M so we can see what is happening, yay!

Linus Walleij (2):
  gpio: move U300 GPIO driver to drivers/gpio
  gpio: move Nomadik GPIO driver to drivers/gpio

Rabin Vincent (1):
  gpio/nomadik: show all pins in debug

Rickard Andersson (1):
  gpio/nomadik: add function to read GPIO pull down status

 arch/arm/mach-u300/Makefile                        |    2 +-
 arch/arm/plat-nomadik/Kconfig                      |    5 --
 arch/arm/plat-nomadik/Makefile                     |    1 -
 arch/arm/plat-nomadik/include/plat/gpio.h          |    2 +
 drivers/gpio/Makefile                              |    2 +
 .../gpio.c => drivers/gpio/gpio-nomadik.c          |   65 +++++++++++++++++---
 .../mach-u300/gpio.c => drivers/gpio/gpio-u300.c   |    0
 7 files changed, 62 insertions(+), 15 deletions(-)
 rename arch/arm/plat-nomadik/gpio.c => drivers/gpio/gpio-nomadik.c (95%)
 rename arch/arm/mach-u300/gpio.c => drivers/gpio/gpio-u300.c (100%)

-- 
1.7.3.2

