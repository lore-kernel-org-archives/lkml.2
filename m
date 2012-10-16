Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755249Ab2JPRCs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Oct 2012 13:02:48 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:60616 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753912Ab2JPRCp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Oct 2012 13:02:45 -0400
MIME-Version: 1.0
Date: Tue, 16 Oct 2012 19:02:43 +0200
Message-ID: <CACRpkdb_=aUDx0TcV5OrEjS9OAtjLp2jo-9=QL7cTfo=gqSy0w@mail.gmail.com>
Subject: [GIT PULL] pinctrl fixes for v3.7
From: Linus Walleij <linus.walleij@linaro.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        Wei Yongjun <yongjun_wei@trendmicro.com.cn>,
        Tobias Klauser <tklauser@distanz.ch>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

here is a first round of post-mergewindow fixes for the pinctrl subsystem,
described in the tag.

Please pull them in!

Yours,
Linus Walleij

The following changes since commit ddffeb8c4d0331609ef2581d84de4d763607bd37:

  Linux 3.7-rc1 (2012-10-14 14:41:04 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/linusw/linux-pinctrl.git
tags/pinctrl-fixes-v3.7-rc2

for you to fetch changes up to 51f58c68a364363b29c07668c90af19c9b8a8c85:

  pinctrl/nomadik: always use the simple irqdomain (2012-10-15 09:09:27 +0200)

----------------------------------------------------------------
A number of pinctrl fixes for the v3.7 series:
- duplicate includes, section markup, code mishaps
- erroneous return value in errorpath on the bcm2835 driver
- remove an unused sirf function that was causing build errors
- multiple-platform compilation stubs and a missed code review
  comment fixup on the nomadik pin controller

----------------------------------------------------------------
Arnd Bergmann (2):
      pinctrl: samsung: use __devinit section for init code
      pinctrl: sirf: remove sirfsoc_gpio_set_pull function

Linus Walleij (2):
      pinctrl/nomadik: provide stubs for legacy Nomadik
      pinctrl/nomadik: always use the simple irqdomain

Tobias Klauser (1):
      pinctrl: bcm2835: Use existing pointer to struct device

Wei Yongjun (3):
      pinctrl: remove duplicated include from pinctrl-bcm2835.c
      pinctrl: fix return value in bcm2835_pinctrl_probe()
      pinctrl: remove duplicated include from pinctrl-xway.c

 arch/arm/mach-prima2/include/mach/gpio.h | 13 ------------
 drivers/pinctrl/pinctrl-bcm2835.c        |  5 ++---
 drivers/pinctrl/pinctrl-nomadik.c        | 26 +++++++++++++++---------
 drivers/pinctrl/pinctrl-samsung.c        | 10 ++++-----
 drivers/pinctrl/pinctrl-sirf.c           | 35 --------------------------------
 drivers/pinctrl/pinctrl-xway.c           |  2 --
 6 files changed, 23 insertions(+), 68 deletions(-)
 delete mode 100644 arch/arm/mach-prima2/include/mach/gpio.h
