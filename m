Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751883Ab2LTAuT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Dec 2012 19:50:19 -0500
Received: from mail-vc0-f172.google.com ([209.85.220.172]:39510 "EHLO
	mail-vc0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751271Ab2LTAuQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Dec 2012 19:50:16 -0500
MIME-Version: 1.0
From: Grant Likely <grant.likely@secretlab.ca>
Date: Thu, 20 Dec 2012 00:42:44 +0000
X-Google-Sender-Auth: uSVfEhbCeb9vX4QHdKP1QUlzFVw
Message-ID: <CACxGe6uDAoU8feztvLeU2JHgT5PXneM4oQfdDXdWqh1K6Vv5nw@mail.gmail.com>
Subject: [GIT PULL] GPIO bug fixes for v3.8 merge window
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Some more basic bug fixes. GPIO this time. Please pull

g.

The following changes since commit 752451f01c4567b506bf4343082682dbb8fb30dd:

  Merge branch 'i2c-embedded/for-next' of
git://git.pengutronix.de/git/wsa/linux (2012-12-18 16:51:10 -0800)

are available in the git repository at:


  git://git.secretlab.ca/git/linux-2.6 tags/gpio-for-linus

for you to fetch changes up to bc1008cf7d243cf6ad87b1e16d3dbbd8c8d6f35c:

  gpio/mvebu-gpio: Make mvebu-gpio depend on OF_CONFIG (2012-12-19
22:15:14 +0000)

----------------------------------------------------------------
GPIO device driver bug fixes:
- gpio/mvebu-gpio: Make mvebu-gpio depend on OF_CONFIG
- gpio/ich: Add missing spinlock init

----------------------------------------------------------------
Gregory CLEMENT (1):
      gpio/mvebu-gpio: Make mvebu-gpio depend on OF_CONFIG

Jean Delvare (1):
      gpio/ich: Add missing spinlock init

 drivers/gpio/Kconfig      |    1 +
 drivers/gpio/gpio-ich.c   |    1 +
 drivers/gpio/gpio-mvebu.c |   17 -----------------
 3 files changed, 2 insertions(+), 17 deletions(-)
