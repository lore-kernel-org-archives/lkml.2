Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757171Ab0LMM3P (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Dec 2010 07:29:15 -0500
Received: from fw.wantstofly.org ([80.101.37.227]:36117 "EHLO
	mail.wantstofly.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752042Ab0LMM3O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Dec 2010 07:29:14 -0500
Date: Mon, 13 Dec 2010 13:29:13 +0100
From: Lennert Buytenhek <buytenh@wantstofly.org>
To: Samuel Ortiz <sameo@linux.intel.com>, linux-kernel@vger.kernel.org
Subject: [PATCH 00/20] mfd: irq_data conversion.
Message-ID: <20101213122913.GJ15575@mail.wantstofly.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch set converts drivers/mfd/ irq_chips and flow handlers over
to the new struct irq_data based irq_chip functions.


Lennert Buytenhek (20):
  mfd: 88pm860x-core: irq_data conversion.
  mfd: ab3550: irq_data conversion.
  mfd: ab8500: irq_data conversion.
  mfd: asic3: irq_data conversion.
  mfd: ezx-pcap: irq_data conversion.
  mfd: htc-egpio: irq_data conversion.
  mfd: htc-i2cpld: irq_data conversion.
  mfd: jz4740-adc: irq_data conversion.
  mfd: max8925: irq_data conversion.
  mfd: max8998: irq_data conversion.
  mfd: stmpe: irq_data conversion.
  mfd: t7l66xb: irq_data conversion.
  mfd: tc35892: irq_data conversion.
  mfd: tc6393xb: irq_data conversion.
  mfd: tps6586x: irq_data conversion.
  mfd: twl4030: irq_data conversion.
  mfd: twl6030: irq_data conversion.
  mfd: wm831x: irq_data conversion.
  mfd: wm8350: irq_data conversion.
  mfd: wm8994: irq_data conversion.

 drivers/mfd/88pm860x-core.c |   32 +++++++++++-----------
 drivers/mfd/ab3550-core.c   |   32 ++++++++++++----------
 drivers/mfd/ab8500-core.c   |   28 ++++++++++----------
 drivers/mfd/asic3.c         |   60 +++++++++++++++++++++---------------------
 drivers/mfd/ezx-pcap.c      |   20 +++++++-------
 drivers/mfd/htc-egpio.c     |   27 ++++++++++---------
 drivers/mfd/htc-i2cpld.c    |   31 +++++++++++----------
 drivers/mfd/jz4740-adc.c    |   25 +++++++++--------
 drivers/mfd/max8925-core.c  |   32 +++++++++++-----------
 drivers/mfd/max8998-irq.c   |   28 ++++++++++----------
 drivers/mfd/stmpe.c         |   28 ++++++++++----------
 drivers/mfd/t7l66xb.c       |   22 ++++++++--------
 drivers/mfd/tc35892.c       |    8 +++---
 drivers/mfd/tc6393xb.c      |   22 ++++++++--------
 drivers/mfd/tps6586x.c      |   28 ++++++++++----------
 drivers/mfd/twl4030-irq.c   |   28 ++++++++++----------
 drivers/mfd/twl6030-irq.c   |    2 +-
 drivers/mfd/wm831x-irq.c    |   37 +++++++++++++-------------
 drivers/mfd/wm8350-irq.c    |   28 ++++++++++----------
 drivers/mfd/wm8994-irq.c    |   28 ++++++++++----------
 20 files changed, 276 insertions(+), 270 deletions(-)
