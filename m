Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754731Ab2KHIlW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Nov 2012 03:41:22 -0500
Received: from mail-ee0-f46.google.com ([74.125.83.46]:45119 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751979Ab2KHIlV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Nov 2012 03:41:21 -0500
MIME-Version: 1.0
Date: Thu, 8 Nov 2012 09:41:19 +0100
Message-ID: <CACRpkdYWOq32_fX7RsHfk6iivf9iJMAUPrYh1yBwwG1coKmwmg@mail.gmail.com>
Subject: [GIT PULL] pinctrl fixes for v3.7 rc:s
From: Linus Walleij <linus.walleij@linaro.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Viresh Kumar <viresh.kumar@linaro.org>,
        Shiraz HASHIM <shiraz.hashim@st.com>, Axel Lin <axel.lin@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

here is a set of pinctrl fixes for the current -rc series.
Details in the signed tag.

Please pull it in!

Yours,
Linus Walleij

The following changes since commit 8f0d8163b50e01f398b14bcd4dc039ac5ab18d64:

  Linux 3.7-rc3 (2012-10-28 12:24:48 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/linusw/linux-pinctrl.git
tags/pinctrl-for-v3.7-rc5

for you to fetch changes up to 924da31416f20a8ee7a9008dd4e6e6054bc36b1b:

  pinctrl: samsung and exynos need to depend on OF && GPIOLIB
(2012-11-06 10:02:14 +0100)

----------------------------------------------------------------
Some pinctrl fixes for the v3.7 series:
- A set of SPEAr pinctrl fixes that recently arrived
- A fixup for the Samsung/Exynos Kconfig deps

----------------------------------------------------------------
Axel Lin (1):
      pinctrl: samsung and exynos need to depend on OF && GPIOLIB

Deepak Sikri (2):
      pinctrl: SPEAr320: Correct pad mux entries for rmii/smii
      pinctrl: SPEAr1340: Make DDR reset & clock pads as gpio

Shiraz Hashim (3):
      pinctrl: SPEAr3xx: correct register space to configure pwm
      pinctrl: SPEAr1310: fix clcd high resolution pin group name
      pinctrl: SPEAr1310: add register entries for enabling pad direction

Vipul Kumar Samar (3):
      pinctrl: SPEAr1310: Fix value of PERIP_CFG reigster and MCIF_SEL_SHIFT
      pinctrl: SPEAr1310: Separate out pci pins from pcie_sata pin group
      pinctrl: SPEAr1340: Add clcd sleep mode pin configuration

Viresh Kumar (1):
      pinctrl: SPEAr: Don't update all non muxreg bits on pinctrl_disable

 drivers/pinctrl/Kconfig                   |   2 +
 drivers/pinctrl/spear/pinctrl-spear.c     |   2 +-
 drivers/pinctrl/spear/pinctrl-spear1310.c | 365 ++++++++++++++++++++++++++----
 drivers/pinctrl/spear/pinctrl-spear1340.c |  41 +++-
 drivers/pinctrl/spear/pinctrl-spear320.c  |   8 +-
 drivers/pinctrl/spear/pinctrl-spear3xx.h  |   1 +
 6 files changed, 369 insertions(+), 50 deletions(-)
