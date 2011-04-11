Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755666Ab1DKLV7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Apr 2011 07:21:59 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:41908 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755239Ab1DKLV6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Apr 2011 07:21:58 -0400
From: Jamie Iles <jamie@jamieiles.com>
To: linux-kernel@vger.kernel.org
Cc: linux@arm.linux.org.uk, tglx@linutronix.de, cbouatmailru@gmail.com,
        grant.likely@secretlab.ca, arnd@arndb.de, nico@fluxnic.net,
        Jamie Iles <jamie@jamieiles.com>
Subject: [PATCHv3 0/7] gpio: extend basic_mmio_gpio for different controllers
Date: Mon, 11 Apr 2011 12:21:47 +0100
Message-Id: <1302520914-22816-1-git-send-email-jamie@jamieiles.com>
X-Mailer: git-send-email 1.7.4.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Updated from v2 with change to use the set/dat registers for input/output
register pair devices and removed some rebasing breakage.

Jamie Iles (7):
  basic_mmio_gpio: remove runtime width/endianness evaluation
  basic_mmio_gpio: convert to platform_{get,set}_drvdata()
  basic_mmio_gpio: allow overriding number of gpio
  basic_mmio_gpio: request register regions
  basic_mmio_gpio: detect output method at probe time
  basic_mmio_gpio: support different input/output registers
  basic_mmio_gpio: support direction registers

 drivers/gpio/basic_mmio_gpio.c  |  390 +++++++++++++++++++++++++++++++--------
 include/linux/basic_mmio_gpio.h |    1 +
 2 files changed, 311 insertions(+), 80 deletions(-)

-- 
1.7.4.2

