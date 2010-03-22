Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755443Ab0CVUKU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Mar 2010 16:10:20 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:33251 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754826Ab0CVUKS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Mar 2010 16:10:18 -0400
Subject: [GIT PULL] regulator fixes for 2.6.34-rc3
From: Liam Girdwood <lrg@slimlogic.co.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Mark Brown <broonie@opensource.wolfsonmicro.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 22 Mar 2010 20:10:16 +0000
Message-ID: <1269288616.3754.26.camel@odin>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull the following voltage regulator fixes for 2.6.34-rc3.

Thanks

Liam

---

The following changes since commit 220bf991b0366cc50a94feede3d7341fa5710ee4:
  Linus Torvalds (1):
        Linux 2.6.34-rc2

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/lrg/voltage-2.6.git for-linus

Ameya Palande (1):
      regulator: Get rid of lockdep warning

Axel Lin (2):
      lp3971: Fix setting val for LDO2 and LDO4
      lp3971: Fix BUCK_VOL_CHANGE_SHIFT logic

Dan Carpenter (1):
      regulator: handle kcalloc() failure

Dmitry Torokhov (1):
      Regulators: max8925-regulator - clean up driver data after removal

Wolfram Sang (1):
      regulator: fix dangling pointers

 drivers/regulator/core.c              |    1 +
 drivers/regulator/lp3971.c            |   10 ++++++++--
 drivers/regulator/max1586.c           |    2 +-
 drivers/regulator/max8649.c           |    3 ++-
 drivers/regulator/max8660.c           |    2 +-
 drivers/regulator/max8925-regulator.c |    6 ++++--
 6 files changed, 17 insertions(+), 7 deletions(-)


