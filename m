Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422899Ab2JYJ73 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2012 05:59:29 -0400
Received: from mail-wi0-f170.google.com ([209.85.212.170]:46218 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964967Ab2JYJ5X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2012 05:57:23 -0400
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: arnd@arndb.de, linus.walleij@stericsson.com
Subject: [PATCH 1/8] Ux5x0 patches loosely surrounding u9540 enablement
Date: Thu, 25 Oct 2012 10:57:03 +0100
Message-Id: <1351159031-25391-1-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Kept together mostly for tracking convenience, this patch-set is
the result of platform tweaking during u9540 enablement.

 arch/arm/boot/dts/ccu9540.dts     |   72 +++++++++++++++++++++++++++++++++++++
 arch/arm/boot/dts/dbx5x0.dtsi     |   14 ++++++++
 arch/arm/boot/dts/hrefprev60.dts  |    2 +-
 arch/arm/boot/dts/hrefv60plus.dts |    2 +-
 arch/arm/boot/dts/snowball.dts    |    2 +-
 arch/arm/boot/dts/stuib.dtsi      |    2 +-
 arch/arm/boot/dts/u9540.dts       |   47 ------------------------
 arch/arm/configs/u8500_defconfig  |    1 +
 arch/arm/mach-ux500/cpu-db8500.c  |   27 +++++---------
 9 files changed, 100 insertions(+), 69 deletions(-)

