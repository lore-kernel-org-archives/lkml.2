Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755880Ab2HFKq4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Aug 2012 06:46:56 -0400
Received: from mail-wi0-f172.google.com ([209.85.212.172]:59033 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755840Ab2HFKqy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Aug 2012 06:46:54 -0400
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: STEricsson_nomadik_linux@list.st.com, linus.walleij@stericsson.com,
        arnd@arndb.de, dmitry.torokhov@gmail.com, sameo@linux.intel.com
Subject: [PATCH 0/6] Device Tree IRQ related enablement patches
Date: Mon,  6 Aug 2012 11:46:36 +0100
Message-Id: <1344250002-6011-1-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch-set pertains to the addition of a new IRQ domain for
the DB8500-PRCMU and providing it with Interrupt Controller status
in the eyes of Device Tree. We also ensure that the Power-On-Key
driver obtains the correct IRQ when being probed with Device Tree
and otherwise.

 arch/arm/boot/dts/dbx5x0.dtsi      |    5 +++-
 drivers/input/misc/ab8500-ponkey.c |    6 ++--
 drivers/mfd/db8500-prcmu.c         |   54 +++++++++++++++++++++++++++---------
 drivers/mfd/mfd-core.c             |   10 +++++--
 include/linux/mfd/db8500-prcmu.h   |    2 ++
 5 files changed, 59 insertions(+), 18 deletions(-)

