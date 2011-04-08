Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757107Ab1DHORC (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Apr 2011 10:17:02 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:40223 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753031Ab1DHORA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Apr 2011 10:17:00 -0400
From: Jamie Iles <jamie@jamieiles.com>
To: linux-kernel@vger.kernel.org
Cc: linux@arm.linux.org.uk, tglx@linutronix.de, cbouatmailru@gmail.com,
        grant.likely@secretlab.ca, arnd@arndb.de, nico@fluxnic.net,
        Jamie Iles <jamie@jamieiles.com>
Subject: [PATCHv2 0/7] gpio: extend basic_mmio_gpio for different controllers
Date: Fri,  8 Apr 2011 15:16:44 +0100
Message-Id: <1302272211-30242-1-git-send-email-jamie@jamieiles.com>
X-Mailer: git-send-email 1.7.4.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I've updated the series with all of Anton's comments (thanks Anton) and
retested on the Synopsys controller with multiple banks.

Thanks,

Jamie Iles (7):
  basic_mmio_gpio: remove runtime width/endianness evaluation
  basic_mmio_gpio: convert to platform_{get,set}_drvdata()
  basic_mmio_gpio: allow overriding number of gpio
  basic_mmio_gpio: request register regions
  basic_mmio_gpio: detect output method at probe time
  basic_mmio_gpio: support different input/output registers
  basic_mmio_gpio: support direction registers

 drivers/gpio/basic_mmio_gpio.c  |  383 ++++++++++++++++++++++++++++++---------
 include/linux/basic_mmio_gpio.h |    1 +
 2 files changed, 302 insertions(+), 82 deletions(-)

-- 
1.7.4.2

