Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756781Ab2DIIgo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Apr 2012 04:36:44 -0400
Received: from hqemgate03.nvidia.com ([216.228.121.140]:3476 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755304Ab2DIIgn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Apr 2012 04:36:43 -0400
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Mon, 09 Apr 2012 01:36:43 -0700
From: Laxman Dewangan <ldewangan@nvidia.com>
To: grant.likely@secretlab.ca, linus.walleij@stericsson.com,
        sameo@linux.intel.com, ldewangan@nvidia.com
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH V2 0/2] RC5T583: Add support for gpio
Date: Mon,  9 Apr 2012 13:55:53 +0530
Message-Id: <1333959955-968-1-git-send-email-ldewangan@nvidia.com>
X-Mailer: git-send-email 1.7.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

RICOH's PMIC support 8 gpios. Adding support of accessing
these pins through gpio library.
This patch series add the related support.

Changes from V1:
As per suggestion from Grant, the gpio driver should be register
as separate driver.
Making the related changes to have gpio driver as platform driver
which got register through mfd devices from mfd core.

Laxman Dewangan (2):
  gpio: Add gpio driver for RICOH PMIC RC5T583
  mfd: rc5t583: add rc5t583's gpio in mfd device list

 drivers/gpio/Kconfig        |    9 ++
 drivers/gpio/Makefile       |    1 +
 drivers/gpio/gpio-rc5t583.c |  195 +++++++++++++++++++++++++++++++++++++++++++
 drivers/mfd/rc5t583.c       |    1 +
 include/linux/mfd/rc5t583.h |    9 ++
 5 files changed, 215 insertions(+), 0 deletions(-)
 create mode 100644 drivers/gpio/gpio-rc5t583.c

