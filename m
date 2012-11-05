Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932669Ab2KEPKv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Nov 2012 10:10:51 -0500
Received: from mail-wg0-f44.google.com ([74.125.82.44]:47971 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932439Ab2KEPKt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Nov 2012 10:10:49 -0500
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        sameo@linux.intel.com
Cc: arnd@arndb.de, linus.walleij@stericsson.com
Subject: [PATCH 0/8] mfd: Batch together MFD related patches
Date: Mon,  5 Nov 2012 16:10:28 +0100
Message-Id: <1352128236-11554-1-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Sam,

I know you've been busy giving NFC presentations at ELC, but ... :)

All these patches have been on the list in various other patch-sets
for some time and have been reviewed by some key people already. All
other patches from the patch-sets have been taken, so I thought I'd
batch these up for easy review/acceptance.

 Documentation/devicetree/bindings/mfd/stmpe.txt |   25 ++++
 drivers/mfd/ab8500-core.c                       |   98 ++++-----------
 drivers/mfd/db8500-prcmu.c                      |    8 +-
 drivers/mfd/stmpe.c                             |  151 ++++++++++++++++-------
 include/linux/mfd/stmpe.h                       |    2 +
 5 files changed, 160 insertions(+), 124 deletions(-)

