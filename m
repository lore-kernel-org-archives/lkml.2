Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757561Ab1K3KZj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Nov 2011 05:25:39 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:55556 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753660Ab1K3KZg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Nov 2011 05:25:36 -0500
Date: Wed, 30 Nov 2011 10:25:28 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Liam Girdwood <lrg@ti.com>
Subject: [GIT PULL] Regulator updates for 3.2-rc4
Message-ID: <20111130102527.GC2791@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Please pull the updates below with some bug fixes for the regulator API.
There's a couple of small, simple fixes for error handling paths plus a
larger update for the TWL PMICs which makes two of the regulators which
were previously not configured using the correct method work properly.

The following changes since commit caca6a03d365883564885f2c1da3e88dcf65d139:

  Linux 3.2-rc3 (2011-11-23 20:20:28 -0800)

are available in the git repository at:
  git://git.kernel.org/pub/scm/linux/kernel/git/broonie/regulator.git for-linus

Axel Lin (1):
      regulator: aat2870: Fix the logic of checking if no id is matched in aat2870_get_regulator

Lothar Waﬂmann (1):
      regulator: fix use after free bug

Tero Kristo (1):
      regulator: twl: fix twl4030 support for smps regulators

 drivers/regulator/aat2870-regulator.c |    2 +-
 drivers/regulator/core.c              |    2 +-
 drivers/regulator/twl-regulator.c     |   46 +++++++++++++++++++++++++++++++-
 3 files changed, 46 insertions(+), 4 deletions(-)
