Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754316Ab0IOPNt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Sep 2010 11:13:49 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:48507 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753350Ab0IOPNs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Sep 2010 11:13:48 -0400
Subject: [GIT PULL] regulator fixes for 2.6.36-rc5
From: Liam Girdwood <lrg@slimlogic.co.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 15 Sep 2010 16:13:40 +0100
Message-ID: <1284563620.10618.246.camel@vega>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull the following regulator fixes for 2.6.36-rc5. Mostly trivial
logic and value checking fixes.

Thanks

Liam

---

The following changes since commit 2bfc96a127bc1cc94d26bfaa40159966064f9c8c:
  Linus Torvalds (1):
        Linux 2.6.36-rc3

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/lrg/voltage-2.6.git for-linus

Axel Lin (15):
      regulator: ab3100 - fix the logic to remove already registered regulators in error path
      regulator: ab8500 - fix the logic to remove already registered regulators in error path
      regulator: max1586 - improve the logic of choosing selector
      regulator: tps6507x - remove incorrect comments
      regulator: max8998 - fix memory allocation size for max8998->rdev
      regulator: max8998 - set max8998->num_regulators
      regulator: tps6586x-regulator - fix value range checking for val
      regulator: tps6586x-regulator - fix bit_mask parameter for tps6586x_set_bits()
      regulator: set max8998->dev to &pdev->dev.
      regulator: ad5398 - fix a memory leak
      regulator: isl6271a-regulator - fix regulator_desc parameter for regulator_register()
      regulator: 88pm8607 - fix value range checking for accessing info->vol_table
      regulator: ab8500 - fix off-by-one value range checking for selector
      regulator: wm831x-ldo - fix the logic to set REGULATOR_MODE_IDLE and REGULATOR_MODE_STANDBY modes
      regulator: wm8350-regulator - fix the logic of checking REGULATOR_MODE_STANDBY mode

Dan Carpenter (1):
      regulator/ab8500: move dereference below the check for NULL

Mark Brown (1):
      regulator: Update e-mail address for Liam Girdwood

 Documentation/power/regulator/overview.txt |    2 +-
 drivers/regulator/88pm8607.c               |    4 ++--
 drivers/regulator/ab3100.c                 |    5 +----
 drivers/regulator/ab8500.c                 |    9 ++++-----
 drivers/regulator/ad5398.c                 |   12 ++++++------
 drivers/regulator/isl6271a-regulator.c     |    2 +-
 drivers/regulator/max1586.c                |   12 ++++++------
 drivers/regulator/max8998.c                |    8 +++++---
 drivers/regulator/tps6507x-regulator.c     |    6 ------
 drivers/regulator/tps6586x-regulator.c     |    4 ++--
 drivers/regulator/wm831x-ldo.c             |    7 ++++---
 drivers/regulator/wm8350-regulator.c       |    2 +-
 12 files changed, 33 insertions(+), 40 deletions(-)


