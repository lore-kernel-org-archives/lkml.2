Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753245Ab2DMSUV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Apr 2012 14:20:21 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:43791 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751581Ab2DMSUT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Apr 2012 14:20:19 -0400
MIME-Version: 1.0
From: Grant Likely <grant.likely@secretlab.ca>
Date: Fri, 13 Apr 2012 12:19:58 -0600
X-Google-Sender-Auth: mULHwz5lODJdsurlFNr3-ndIayg
Message-ID: <CACxGe6s+051iAVvbCoLHS8kCixqyRc1dnxNnEavH4MSke48dbg@mail.gmail.com>
Subject: [GIT PULL] gpio bug fixes on top of v3.4-rc2
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

GPIO bug fixes.  Please pull.

g.

The following changes since commit 0034102808e0dbbf3a2394b82b1bb40b5778de9e:

  Linux 3.4-rc2 (2012-04-07 18:30:41 -0700)

are available in the git repository at:

  git://git.secretlab.ca/git/linux-2.6 tags/gpio-for-linus

for you to fetch changes up to 9a5c7d6eb9b8cc9fa1c7169ecfd96c9e267c0452:

  gpio/exynos: Fix compiler warning in gpio-samsung.c file (2012-04-10
22:15:39 -0600)

----------------------------------------------------------------
GPIO bug fixes on top of v3.4-rc2

Miscellaneous bug fixes to GPIO drivers and for a corner case in the
gpio device tree parsing code.

----------------------------------------------------------------
Axel Lin (1):
      gpio: Fix uninitialized variable bit in adp5588_irq_handler

Grant Likely (1):
      gpio/sodaville: Convert sodaville driver to new irqdomain API

Roland Stigge (1):
      gpio: Fix range check in of_gpio_simple_xlate()

Sachin Kamat (1):
      gpio/exynos: Fix compiler warning in gpio-samsung.c file

 drivers/gpio/Kconfig          |    2 +-
 drivers/gpio/gpio-adp5588.c   |    2 +-
 drivers/gpio/gpio-samsung.c   |   16 ++++++++--------
 drivers/gpio/gpio-sodaville.c |   23 ++++++++++-------------
 drivers/of/gpio.c             |    2 +-
 5 files changed, 21 insertions(+), 24 deletions(-)


-- 
Grant Likely, B.Sc., P.Eng.
Secret Lab Technologies Ltd.
