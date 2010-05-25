Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756624Ab0EYJm5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 May 2010 05:42:57 -0400
Received: from mail-ww0-f46.google.com ([74.125.82.46]:36820 "EHLO
	mail-ww0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756283Ab0EYJmz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 May 2010 05:42:55 -0400
Subject: [GIT PULL] Regulator updates for 2.6.35
From: Liam Girdwood <lrg@slimlogic.co.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
       linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 25 May 2010 10:42:51 +0100
Message-ID: <1274780571.3000.23.camel@odin>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull the following voltage regulator updates for 2.6.35. There
are no new PMIC drivers this time, it's mostly improvements to the core
and existing regulator drivers.

Thanks

Liam

---

The following changes since commit 7e125f7b9cbfce4101191b8076d606c517a73066:
  Linus Torvalds (1):
        Merge git://git.kernel.org/.../davem/ide-2.6

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/lrg/voltage-2.6.git for-linus

Axel Lin (2):
      mc13783-regulator: fix vaild voltage range checking for mc13783_fixed_regulator_set_voltage
      Regulators: ab3100/bq24022: add a missing .owner field in regulator_desc

Haojian Zhuang (2):
      regulator: make 88pm860x sharing one driver structure
      regulator: use voltage number array in 88pm860x

Jani Nikula (3):
      regulator: prevent registration of matching regulator consumer supplies
      regulator: fix unset_regulator_supplies() to remove all matches
      regulator: simplify regulator_register() error handling

Mark Brown (1):
      regulator: Allow regulator-regulator supplies to be specified by name

Rajendra Nayak (1):
      twl6030: regulator: Remove vsel tables and use formula for calculation

Sundar R Iyer (1):
      regulator: return set_mode is same mode is requested

 drivers/mfd/88pm860x-core.c           |   36 ++-
 drivers/regulator/88pm8607.c          |  533 ++++++++++++++-------------------
 drivers/regulator/ab3100.c            |   10 +
 drivers/regulator/bq24022.c           |    1 +
 drivers/regulator/core.c              |   83 ++++--
 drivers/regulator/mc13783-regulator.c |    6 +-
 drivers/regulator/twl-regulator.c     |  138 ++++++---
 include/linux/mfd/88pm860x.h          |    3 +-
 include/linux/regulator/machine.h     |    9 +-
 9 files changed, 414 insertions(+), 405 deletions(-)


