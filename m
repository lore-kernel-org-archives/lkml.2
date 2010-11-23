Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756171Ab0KWS1Z (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Nov 2010 13:27:25 -0500
Received: from eu1sys200aog118.obsmtp.com ([207.126.144.145]:55528 "EHLO
	eu1sys200aog118.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756145Ab0KWS1Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Nov 2010 13:27:24 -0500
From: Bengt Jonsson <bengt.g.jonsson@stericsson.com>
To: Liam Girdwood <lrg@slimlogic.co.uk>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        Linus Walleij <linus.walleij@stericsson.com>
Subject: [PATCH 0/3] regulators: Update of ab8500 driver
Date: Tue, 23 Nov 2010 19:25:51 +0100
Message-ID: <1290536754-21775-1-git-send-email-bengt.g.jonsson@stericsson.com>
X-Mailer: git-send-email 1.7.2.2
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patchset updates the ab8500 regulator driver, changes how the regulator
board configuration is handled by the ab8500 mfd core and finally makes the 
the regulator board configuration available to the regulator driver.

Note that the second and third patches depend on the first patch.

 arch/arm/mach-ux500/board-mop500-regulators.c |  153 ++++-----
 arch/arm/mach-ux500/board-mop500-regulators.h |   18 +
 arch/arm/mach-ux500/board-mop500.c            |    4 +
 drivers/regulator/ab8500.c                    |  448 +++++++++++++++++--------
 include/linux/mfd/ab8500.h                    |    1 +
 include/linux/regulator/ab8500.h              |   27 +-
 6 files changed, 428 insertions(+), 223 deletions(-)


