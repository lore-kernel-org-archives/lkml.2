Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753174Ab1GaKkq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 31 Jul 2011 06:40:46 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:55460 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751829Ab1GaKkk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 31 Jul 2011 06:40:40 -0400
Date: Sun, 31 Jul 2011 14:40:23 +0400
From: Anton Vorontsov <cbouatmailru@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        David Woodhouse <dwmw2@infradead.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>, linux-kernel@vger.kernel.org
Subject: [GIT PULL] battery-2.6.git
Message-ID: <20110731104023.GA1691@oksana.dev.rtsoft.ru>
Reply-To: cbouatmailru@gmail.com
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Linus,

Please pull battery-2.6.git tree to receive changes prepared for
v3.1.

These are the patches that were sitting for a long time in my tree.
I have another bunch of fresh commits, but I don't want to pollute
this pull request with them. So I might do another small pull request
just after you merge this tree.

Thanks!


The following changes since commit 906649de0eacde7a643b5a0750de6207441ad54f:

  PXA: Use dev_pm_ops in z2_battery (2011-05-20 19:25:11 +0400)

are available in the git repository at:
  git://git.infradead.org/battery-2.6.git master

Axel Lin (1):
      gpio-charger: Fix checking return value of request_any_context_irq

Donggeun Kim (3):
      power_supply: Add charger driver for MAX8997/8966
      power_supply: Add charger driver for MAX8998/LP3974
      power_supply: MAX17042: Support additional properties

Grazvydas Ignotas (1):
      twl4030_charger: Fix warnings

Ken O'Brien (1):
      apm_power: Fix style error in macros

Mark Brown (3):
      s3c_adc_battery: Fix annotation for s3c_adc_battery_probe()
      wm831x_backup: Support multiple instances
      wm831x_power: Support multiple instances

MyungJoo Ham (1):
      max8903_charger: Allow platform data to be __initdata

Rhyland Klein (2):
      bq20z75: Add support for external notification
      bq20z75: Enable detection after registering

Wolfram Sang (1):
      max17042_battery: Remove obsolete cleanup for clientdata

 drivers/mfd/max8998.c                  |    2 +
 drivers/power/Kconfig                  |   14 ++
 drivers/power/Makefile                 |    2 +
 drivers/power/apm_power.c              |    8 +-
 drivers/power/bq20z75.c                |  103 ++++++++++++++--
 drivers/power/gpio-charger.c           |    2 +-
 drivers/power/max17042_battery.c       |  175 +++++++++++++++----------
 drivers/power/max8903_charger.c        |   16 ++--
 drivers/power/max8997_charger.c        |  206 ++++++++++++++++++++++++++++++
 drivers/power/max8998_charger.c        |  218 ++++++++++++++++++++++++++++++++
 drivers/power/s3c_adc_battery.c        |    2 +-
 drivers/power/twl4030_charger.c        |   10 +-
 drivers/power/wm831x_backup.c          |   12 ++-
 drivers/power/wm831x_power.c           |   26 ++++-
 include/linux/mfd/max8997.h            |    7 +-
 include/linux/mfd/max8998.h            |   12 ++
 include/linux/power/bq20z75.h          |    3 +
 include/linux/power/max17042_battery.h |   91 +++++++++++++
 18 files changed, 806 insertions(+), 103 deletions(-)
 create mode 100644 drivers/power/max8997_charger.c
 create mode 100644 drivers/power/max8998_charger.c
