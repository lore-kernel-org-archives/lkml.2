Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754140Ab0LJKKY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Dec 2010 05:10:24 -0500
Received: from eu1sys200aog103.obsmtp.com ([207.126.144.115]:34671 "EHLO
	eu1sys200aog103.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752845Ab0LJKKW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Dec 2010 05:10:22 -0500
From: Bengt Jonsson <bengt.g.jonsson@stericsson.com>
To: Liam Girdwood <lrg@slimlogic.co.uk>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        Linus Walleij <linus.walleij@stericsson.com>,
        Bengt Jonsson <bengt.g.jonsson@stericsson.com>
Subject: [PATCH 0/9] regulators: Update ab8500 regulator driver
Date: Fri, 10 Dec 2010 11:08:39 +0100
Message-ID: <1291975728-12525-1-git-send-email-bengt.g.jonsson@stericsson.com>
X-Mailer: git-send-email 1.7.2.2
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patchset updates the ab8500 regulator driver:
* The first patch modifies the ab8500 platform configuration structure.
* Patches two through eight updates the ab8500 regulator driver.
* The ninth patch modifies the ab8500 regulator configuration.

The eighth patch is optional as discussed before.

Bengt Jonsson (9):
  regulators: Moved define for number of regulators in ab8500
  regulators: Fixed errors in ab8500 register mapping
  regulators: Clean out unused code in ab8500 regulators
  regulators: Added ab8500 v2 support
  regulators: Updated ab8500 variable names, macro names and comments
  regulators: Modified ab8500 error handling
  regulators: Added verbose debug messages to ab8500 regulators
  regulators: Removed macros for initialization of ab8500 regulators
  mach-ux500: Updated and connected ab8500 regulator board
    configuration

 arch/arm/mach-ux500/board-mop500-regulators.c |  153 ++++-----
 arch/arm/mach-ux500/board-mop500-regulators.h |   19 +
 arch/arm/mach-ux500/board-mop500.c            |    3 +
 drivers/regulator/ab8500.c                    |  448 +++++++++++++++++--------
 include/linux/mfd/ab8500.h                    |    5 +-
 include/linux/regulator/ab8500.h              |   24 +-
 6 files changed, 426 insertions(+), 226 deletions(-)
 create mode 100644 arch/arm/mach-ux500/board-mop500-regulators.h

-- 
1.7.2.2

