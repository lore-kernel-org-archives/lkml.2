Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754860Ab2BVV0I (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Feb 2012 16:26:08 -0500
Received: from hqemgate03.nvidia.com ([216.228.121.140]:12908 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753270Ab2BVV0G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Feb 2012 16:26:06 -0500
X-PGP-Universal: processed;
	by hqnvupgp05.nvidia.com on Wed, 22 Feb 2012 13:26:06 -0800
From: Stephen Warren <swarren@nvidia.com>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: Linus Walleij <linus.walleij@stericsson.com>, B29396@freescale.com,
        s.hauer@pengutronix.de, dongas86@gmail.com, shawn.guo@linaro.org,
        thomas.abraham@linaro.org, tony@atomide.com,
        linux-kernel@vger.kernel.org, Stephen Warren <swarren@nvidia.com>
Subject: [PATCH V2 0/4] pinctrl: Rebased/extracted patches
Date: Wed, 22 Feb 2012 14:25:57 -0700
Message-Id: <1329945961-29547-1-git-send-email-swarren@nvidia.com>
X-Mailer: git-send-email 1.7.0.4
X-NVConfidentiality: public
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The first 3 patches were previously ack'd but weren't applied due to earlier
patches in the original series not having been applied. These rebased versions
can be applied directly on top of the pinctrl for-next branch.

The last patch is the conceptually ack'd portion of the larger locking rework
patch, extracted on its own for commit.

Stephen Warren (4):
  pinctrl: Disallow map table entries with NULL dev_name field
  pinctrl: Use dev_*() instead of pr_*(), add some msgs, minor cleanups
  pinctrl: Allocate sizeof(*p) instead of sizeof(struct foo)
  pinctrl: Remove pin and hogs locks from struct pinctrl_dev

 Documentation/pinctrl.txt       |   15 ++---
 drivers/pinctrl/core.c          |  131 +++++++++++++-------------------------
 drivers/pinctrl/core.h          |   11 ++--
 drivers/pinctrl/pinmux.c        |    2 +-
 include/linux/pinctrl/machine.h |    7 --
 5 files changed, 57 insertions(+), 109 deletions(-)

