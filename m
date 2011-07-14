Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753611Ab1GNT7j (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jul 2011 15:59:39 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:58819 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752737Ab1GNT7i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jul 2011 15:59:38 -0400
From: Peter Korsgaard <jacmet@sunsite.dk>
To: grant.likely@secretlab.ca, linux-kernel@vger.kernel.org
Subject: [PATCH 0/3] gpio/mcp23s08: add support for i2c variants
Date: Thu, 14 Jul 2011 21:59:25 +0200
Message-Id: <1310673568-30577-1-git-send-email-jacmet@sunsite.dk>
X-Mailer: git-send-email 1.7.5.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The Microchip mcp23xxx I/O expanders exists both in variants with SPI
(23S) and I2C (230) interfaces, with either 8 or 16 I/O pins.

Until now the mcp23s08 driver only worked with the SPI variant. Adjust
the driver to work with the I2C ones as well.

 drivers/gpio/Kconfig         |    7 +-
 drivers/gpio/mcp23s08.c      |  260 +++++++++++++++++++++++++++++++++++++-----
 include/linux/spi/mcp23s08.h |    4 +-
 3 files changed, 237 insertions(+), 34 deletions(-)

--
Bye, Peter Korsgaard
