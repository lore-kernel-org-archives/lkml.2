Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752507Ab1CJNnj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Mar 2011 08:43:39 -0500
Received: from eu1sys200aog120.obsmtp.com ([207.126.144.149]:58715 "EHLO
	eu1sys200aog120.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751934Ab1CJNni (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Mar 2011 08:43:38 -0500
From: Linus Walleij <linus.walleij@stericsson.com>
To: Liam Girdwood <lrg@slimlogic.co.uk>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        <linux-kernel@vger.kernel.org>
Cc: Lee Jones <lee.jones@linaro.org>, Linus Walleij <linus.walleij@linaro.org>,
        Bengt Jonsson <bengt.g.jonsson@stericsson.com>
Subject: [PATCH 0/4] regulator: various update to AB8500
Date: Thu, 10 Mar 2011 14:43:18 +0100
Message-ID: <1299764598-2466-1-git-send-email-linus.walleij@stericsson.com>
X-Mailer: git-send-email 1.7.3.2
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Linus Walleij <linus.walleij@linaro.org>

Incremental updates from internal kernel development for
AB8500 regulators.

Since patch [4/4] is dependent on other platform data I'd
prefer to gather Acked-by:s and merge the whole shebang
through the ux500-core tree if possible.

Bengt Jonsson (4):
  regulator: add support for USB voltage regulator
  regulator: add ab8500 per-regulator startup delay
  regulator: added register initialization for ab8500 regulators
  mach-ux500: provide ab8500 init vector

 arch/arm/mach-ux500/board-mop500-regulators.c |  178 ++++++++++++++++++
 arch/arm/mach-ux500/board-mop500-regulators.h |    2 +
 arch/arm/mach-ux500/board-mop500.c            |    3 +
 drivers/regulator/ab8500.c                    |  250 ++++++++++++++++++++++++-
 include/linux/mfd/ab8500.h                    |    6 +
 include/linux/regulator/ab8500.h              |   51 +++++-
 6 files changed, 486 insertions(+), 4 deletions(-)

-- 
1.7.3.2

