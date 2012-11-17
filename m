Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752384Ab2KQW3I (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Nov 2012 17:29:08 -0500
Received: from mail-ee0-f46.google.com ([74.125.83.46]:41188 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752255Ab2KQW3H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Nov 2012 17:29:07 -0500
MIME-Version: 1.0
Date: Sat, 17 Nov 2012 23:29:04 +0100
Message-ID: <CACRpkdaUhS1PnkOfMr4SADYqTGdY9Av-=w4-WD+c6sDAo8vUWA@mail.gmail.com>
Subject: [GIT PULL] gpio fixes for v3.7
From: Linus Walleij <linus.walleij@linaro.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Grant Likely <grant.likely@secretlab.ca>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

hopefully these are the last few GPIO fixes for this merge window.
Info is in the tag as usual.

Please pull them in.

Yours,
Linus Walleij


The following changes since commit 77b67063bb6bce6d475e910d3b886a606d0d91f7:

  Linux 3.7-rc5 (2012-11-11 13:44:33 +0100)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/linusw/linux-gpio.git
tags/gpio-fixes-for-v3.7

for you to fetch changes up to cbf24fad8e6e97b7cd7dd1099f5b801689dc234a:

  gpio-mcp23s08: Build I2C support even when CONFIG_I2C=m (2012-11-17
22:22:24 +0100)

----------------------------------------------------------------
Last minute GPIO fixes for the v3.7 series:
- Disable blinking on the Orion GPIO driver
- Two Kconfig-style fixes to avoid broken builds

----------------------------------------------------------------
Daniel M. Weeks (1):
      gpio-mcp23s08: Build I2C support even when CONFIG_I2C=m

Jamie Lentin (1):
      mvebu-gpio: Disable blinking when enabling a GPIO for output

Thierry Reding (1):
      gpio: adnp: Depend on OF_GPIO instead of OF

 drivers/gpio/Kconfig         |  2 +-
 drivers/gpio/gpio-mcp23s08.c |  6 +++---
 drivers/gpio/gpio-mvebu.c    | 23 +++++++++++++++++++++++
 3 files changed, 27 insertions(+), 4 deletions(-)
