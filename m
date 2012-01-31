Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754329Ab2AaAES (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jan 2012 19:04:18 -0500
Received: from mail.df.lth.se ([194.47.250.12]:53427 "EHLO mail.df.lth.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752832Ab2AaAER (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jan 2012 19:04:17 -0500
From: "Linus Walleij" <linus.walleij@linaro.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Linus Walleij <linus.walleij@linaro.org>
Subject: =?UTF-8?q?=5BGIT=20PULL=5D=20pinctrl=20fixes=20as=20of=203=2E3-rc1?=
Date: Tue, 31 Jan 2012 01:04:03 +0100
Message-Id: <1327968243-2128-1-git-send-email-linus.walleij@linaro.org>
X-Mailer: git-send-email 1.7.7.6
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

Hi Linus,

here are some fixes to the pin control system that has accumulated
since -rc1. Mainly Tony Lindgren fixed the module load/unload logic
and the rest are minor fixes and documentation.

Yours,
Linus Walleij

The following changes since commit dcd6c92267155e70a94b3927bce681ce74b80d1f:

  Linux 3.3-rc1 (2012-01-19 15:04:48 -0800)

are available in the git repository at:
  git://git.kernel.org/pub/scm/linux/kernel/git/linusw/linux-pinctrl.git for-torvalds

Stephen Warren (1):
      pinctrl: fix pinconf_pins_show iteration

Tony Lindgren (4):
      pinctrl: free debugfs entries when unloading a pinmux driver
      pinctrl: fix some pinmux typos
      pinctrl: fix pinmux_hog_maps when ctrl_dev_name is not set
      pinctrl: add checks for empty function names

Uwe Kleine-König (2):
      Documentation/pinctrl: fix a few syntax errors in code examples
      pinctrl: unbreak error messages

 Documentation/pinctrl.txt |   17 ++++-----
 drivers/pinctrl/core.c    |   50 +++++++++++++++++----------
 drivers/pinctrl/core.h    |    3 ++
 drivers/pinctrl/pinconf.c |    6 ++-
 drivers/pinctrl/pinconf.h |    4 +-
 drivers/pinctrl/pinmux.c  |   81 ++++++++++++++++++++++++---------------------
 drivers/pinctrl/pinmux.h  |    4 +-
 7 files changed, 93 insertions(+), 72 deletions(-)
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJPJy8GAAoJEEEQszewGV1zZyoP/3OwFtvP2BRJ2LsBNTzUYXec
z2hs8QP9i1XozkGoqP5jjkmEpflunU6JyzxmbtD9heT/Xz6PnXw2x/MhhTRQtgA5
fQd/V33ctL/Nqw9tqsWGFzwzDxA1wIz+MoBTVFfMhmF5rdumHdpE5VD7hi8/polG
epAJCIjEM/CqQu58PETcPNevwCR2ruWl/Jze35DJY5kfHg9ewHbvgROqjukKkoIj
1LdU847+0gCEEaOEiQk42IWZZg190yADTSwbepaVjx6JHfYlYZzbq5dE7Cp9BKjh
vU/LLRvOJqLY2YPHKfv2a3EwqZ9LEbvrRC0bH9CCcnK9mzObrUeFrPBE05OevXu3
Nu2oyWOUsmQhM/69EBkKc5odLkm84MvonCSix1+rQAvs21YfGZsBEom1+Q0Y+Q9x
uWZov/uLq0/EzGVwus6lEWSmvL35Q2Vy5hH2wpDb7pMGxICKCCCBpxq6cC7wXZXB
KlXSIojqTRx9Otq6wvu5T/Ud0OyNXcWgyM9NUJ9H7BwH1g0l/H9olOUo33DcUZ1I
QpFlNI1TA5yFCqTlj3almF//zUvBpMf/u4Szl53r3uq4phL4EeM93IaFFI2ZIH+o
hLlKz93XGtQV+knPKdIlq7Hh4nIETrWKRhKeA2UghRCFFIwe4q21zQb7qfDVr+ON
w2YCOJRnURuNY3dC/s2x
=8V1Y
-----END PGP SIGNATURE-----
