Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935077Ab2JXOpy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2012 10:45:54 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:43179 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935058Ab2JXOpu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2012 10:45:50 -0400
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: arnd@arndb.de, linus.walleij@stericsson.com
Subject: [PATCH 0/6] ux500 fixes bound for the -rcs
Date: Wed, 24 Oct 2012 15:45:20 +0100
Message-Id: <1351089926-32161-1-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch-set contains a bunch of fixes which are bound for the
v3.6 Release Candidates. Each of them provides a fix for something
which went wrong during the merge window. Without them we either
can't build the kernel, have no GPIOs, only have one running CPU
core, see unnecessary WARN()s, or individual devices fail at to be
functional.

 arch/arm/boot/dts/dbx5x0.dtsi     |   17 ++++++-
 arch/arm/mach-ux500/cpu-db8500.c  |    1 +
 arch/arm/mach-ux500/cpu.c         |    1 +
 drivers/mfd/ab8500-core.c         |   36 --------------
 drivers/pinctrl/pinctrl-nomadik.c |   96 ++++++++++++++++++-------------------
 5 files changed, 66 insertions(+), 85 deletions(-)

