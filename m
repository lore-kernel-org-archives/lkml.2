Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756349Ab2FNQ0k (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jun 2012 12:26:40 -0400
Received: from na3sys009aog108.obsmtp.com ([74.125.149.199]:49572 "EHLO
	na3sys009aog108.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754452Ab2FNQ0h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jun 2012 12:26:37 -0400
From: Felipe Balbi <balbi@ti.com>
To: ben-linux@fluff.org
Cc: Tony Lindgren <tony@atomide.com>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Russell King <linux@arm.linux.org.uk>,
        Linux OMAP Mailing List <linux-omap@vger.kernel.org>,
        Linux ARM Kernel Mailing List 
	<linux-arm-kernel@lists.infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        w.sang@pengutronix.de, Shubhrajyoti Datta <shubhrajyoti@ti.com>,
        Felipe Balbi <balbi@ti.com>
Subject: [PATCH v2 00/17] Big OMAP I2C Cleanup
Date: Thu, 14 Jun 2012 19:24:10 +0300
Message-Id: <1339691067-919-1-git-send-email-balbi@ti.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi guys,

I have dropped a few patches from the series and also
tested every single patch on my pandaboard. I2C messages
are still working fine with panda after each patch.

There's still lots of work to be done on the i2c-omap.c
driver but it's now easier to read, IMO.

Changes since v1:
	- removed tabification on patch 6/17
	- removed dev_err() which was introduced on patch 09/17

Felipe Balbi (17):
  i2c: omap: simplify num_bytes handling
  i2c: omap: decrease indentation level on data handling
  i2c: omap: add blank lines
  i2c: omap: simplify omap_i2c_ack_stat()
  i2c: omap: split out [XR]DR and [XR]RDY
  i2c: omap: improve 1p153 errata handling
  i2c: omap: re-factor receive/transmit data loop
  i2c: omap: switch over to do {} while loop
  i2c: omap: ack IRQ in parts
  i2c: omap: get rid of the "complete" label
  i2c: omap: switch to devm_* API
  i2c: omap: switch to platform_get_irq()
  i2c: omap: bus: add a receiver flag
  i2c: omap: simplify errata check
  i2c: omap: always return IRQ_HANDLED
  i2c: omap: simplify IRQ exit path
  i2c: omap: resize fifos before each message

 drivers/i2c/busses/i2c-omap.c |  385 +++++++++++++++++++++++------------------
 1 file changed, 220 insertions(+), 165 deletions(-)

-- 
1.7.10.4

