Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753397Ab2HUGaS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Aug 2012 02:30:18 -0400
Received: from mail-vc0-f174.google.com ([209.85.220.174]:64769 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752765Ab2HUGaQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Aug 2012 02:30:16 -0400
MIME-Version: 1.0
Date: Tue, 21 Aug 2012 08:30:15 +0200
Message-ID: <CACRpkdYfH+qG+OjV99DGqSNkLTqSKG+0Vn03seNHey0bU63fhA@mail.gmail.com>
Subject: [GIT PULL] pinctrl fixes for v3.6-rc series
From: Linus Walleij <linus.walleij@linaro.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Richard Genoud <richard.genoud@gmail.com>,
        Shawn Guo <shawn.guo@linaro.org>,
        Patrice CHOTARD <patrice.chotard@stericsson.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

here are some accumulated pinctrl fixes for the v3.6 series.
Details are in the tag, and all have boiled in -next for testing some
days.

Please pull them in!

The following changes since commit d9875690d9b89a866022ff49e3fcea892345ad92:

  Linux 3.6-rc2 (2012-08-16 14:51:24 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/linusw/linux-pinctrl.git
tags/pinctrl-fixes-v3.6-rc3

for you to fetch changes up to 4c39104da846379151b9c37cffaf8b00a5580229:

  pinctrl/nomadik: add kp_b_2 keyboard function group list (2012-08-17
11:09:58 +0200)

----------------------------------------------------------------
Pin control fixes for v3.6:
- Fixed Nomadik errorpath
- Fixed documentation spelling errors
- Forward-declare struct device in a header file
- Remove some extraneous code lines when getting pinctrl states
- Correct the i.MX51 configure register number
- Fix the Nomadik keypad function group list

----------------------------------------------------------------
Daniel Mack (1):
      Documentation/pinctrl.txt: Fix some misspelled macros

Linus Walleij (1):
      pinctrl/nomadik: fix null in irqdomain errorpath

Patrice Chotard (1):
      pinctrl/nomadik: add kp_b_2 keyboard function group list

Richard Genoud (2):
      pinctrl: header: trivial: declare struct device
      trivial: pinctrl core: remove extraneous code lines

Shawn Guo (1):
      pinctrl: imx51: fix .conf_reg of MX51_PAD_SD2_CMD__CSPI_MOSI

 Documentation/pinctrl.txt                |  6 +++---
 drivers/pinctrl/core.c                   | 13 +++----------
 drivers/pinctrl/pinctrl-imx51.c          |  2 +-
 drivers/pinctrl/pinctrl-nomadik-db8500.c |  5 ++++-
 drivers/pinctrl/pinctrl-nomadik.c        |  2 +-
 include/linux/pinctrl/consumer.h         |  1 +
 6 files changed, 13 insertions(+), 16 deletions(-)

Yours,
Linus Walleij
