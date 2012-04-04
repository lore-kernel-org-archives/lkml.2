Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756475Ab2DDNON (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Apr 2012 09:14:13 -0400
Received: from hqemgate03.nvidia.com ([216.228.121.140]:19325 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756302Ab2DDNOM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Apr 2012 09:14:12 -0400
X-PGP-Universal: processed;
	by hqnvupgp05.nvidia.com on Wed, 04 Apr 2012 06:14:11 -0700
From: Laxman Dewangan <ldewangan@nvidia.com>
To: grant.likely@secretlab.ca, linus.walleij@stericsson.com,
        sameo@linux.intel.com, ldewangan@nvidia.com
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH V1 0/2] RC5T583: Add support for gpio
Date: Wed,  4 Apr 2012 18:34:29 +0530
Message-Id: <1333544671-24549-1-git-send-email-ldewangan@nvidia.com>
X-Mailer: git-send-email 1.7.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

RICOH's PMIC support 8 gpios. Adding support of accessing
these pins through gpio library.
This patch series add the related support.

Laxman Dewangan (2):
  gpio: Add gpio driver for RICOH PMIC RC5T583
	-  Adding the gpio driver for this device.
  mfd: rc5t583: Initialize gpio during initialization.
	-  Calling gpio initialization from probe of mfd core driver.

 drivers/gpio/Kconfig        |    9 +++
 drivers/gpio/Makefile       |    1 +
 drivers/gpio/gpio-rc5t583.c |  148 +++++++++++++++++++++++++++++++++++++++++++
 drivers/mfd/Kconfig         |    1 +
 drivers/mfd/rc5t583.c       |    1 +
 include/linux/mfd/rc5t583.h |   11 +++
 6 files changed, 171 insertions(+), 0 deletions(-)
 create mode 100644 drivers/gpio/gpio-rc5t583.c

