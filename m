Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760262Ab0J1WBB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Oct 2010 18:01:01 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:56629 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759029Ab0J1WA5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Oct 2010 18:00:57 -0400
Subject: [GIT PULL] regulator updates for 2.6.37
From: Liam Girdwood <lrg@slimlogic.co.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 28 Oct 2010 23:00:52 +0100
Message-ID: <1288303252.18037.767.camel@vega>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull the following regulator updates for 2.6.37. Notable updates
for 2.6.37 include new drivers for the LP3972 and MAX8592 PMICs. Other
changes are mainly cleanups and fixes.

Thanks

Liam

---

The following changes since commit 2d3b07c07b39c4b7d9b6641052a02d996cd5d87c:

  Merge branch 'x86-platform-for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip (2010-10-28 12:25:42 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/lrg/voltage-2.6.git for-linus

Anand Gadiyar (1):
      regulator: fix build when CONFIG_REGULATOR_DUMMY=n

Axel Lin (4):
      Regulator: LP3972 PMIC regulator driver
      Regulator: lp3972 cleanup
      regulator: max8952 - fix max8952_pmic_probe error path
      regulator: max8952 - fix max8952_set_voltage

Jeffrey Carlyle (1):
      regulator: avoid deadlock when disabling regulator with supply

Mark Brown (1):
      regulator: Add option for machine drivers to enable the dummy regulator

MyungJoo Ham (1):
      MAX8952 PMIC Driver Initial Release

 drivers/regulator/Kconfig         |   15 +
 drivers/regulator/Makefile        |    5 +-
 drivers/regulator/core.c          |   57 +++-
 drivers/regulator/dummy.h         |    4 -
 drivers/regulator/lp3972.c        |  660 +++++++++++++++++++++++++++++++++++++
 drivers/regulator/max8952.c       |  366 ++++++++++++++++++++
 include/linux/regulator/lp3972.h  |   48 +++
 include/linux/regulator/machine.h |    5 +
 include/linux/regulator/max8952.h |  135 ++++++++
 9 files changed, 1280 insertions(+), 15 deletions(-)
 create mode 100644 drivers/regulator/lp3972.c
 create mode 100644 drivers/regulator/max8952.c
 create mode 100644 include/linux/regulator/lp3972.h
 create mode 100644 include/linux/regulator/max8952.h


