Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932082Ab2HVIp7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2012 04:45:59 -0400
Received: from eu1sys200aog110.obsmtp.com ([207.126.144.129]:46680 "EHLO
	eu1sys200aog110.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754877Ab2HVIoY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2012 04:44:24 -0400
From: Linus Walleij <linus.walleij@stericsson.com>
To: <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        Samuel Ortiz <sameo@linux.intel.com>
Cc: Etienne Carriere <etienne.carriere@stericsson.com>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH 0/7] Ux500 and MASK_ON_SUSPEND
Date: Wed, 22 Aug 2012 10:43:06 +0200
Message-ID: <1345624986-5557-1-git-send-email-linus.walleij@stericsson.com>
X-Mailer: git-send-email 1.7.11.3
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Linus Walleij <linus.walleij@linaro.org>

We have discovered transient IRQs when going to suspend on the
Ux500 platform. This patch series hits all sources by marking
the applicable IRQchips with MASK_ON_SUSPEND.

I don't know if this is a common problem or seen in other
platforms so comments are welcome.

Else I request that the patches be merged into respective
subtree, I will take care of the ux500, gpio and pinctrl
patches myself, while Sam gets to merge all the MFD stuff.

Etienne Carriere (7):
  ux500: GIC: MASK_ON_SUSPEND
  mfd/ab8500: MASK_ON_SUSPEND
  gpio/ab8500: MASK_ON_SUSPEND
  mfd/db8500-prcmu: MASK_ON_SUSPEND
  pinctrl/nomdik: MASK_ON_SUSPEND
  mfd/stmpe: MASK_ON_SUSPEND
  mfd/tc3589x: MASK_ON_SUSPEND

 arch/arm/mach-ux500/cpu.c         | 2 ++
 drivers/gpio/gpio-ab8500.c        | 1 +
 drivers/gpio/gpio-stmpe.c         | 1 +
 drivers/gpio/gpio-tc3589x.c       | 1 +
 drivers/mfd/ab8500-core.c         | 1 +
 drivers/mfd/db8500-prcmu.c        | 1 +
 drivers/mfd/stmpe.c               | 1 +
 drivers/pinctrl/pinctrl-nomadik.c | 1 +
 8 files changed, 9 insertions(+)

-- 
1.7.11.3

