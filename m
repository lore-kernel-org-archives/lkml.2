Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756699Ab2JEQNO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Oct 2012 12:13:14 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:42847 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755491Ab2JEQNI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Oct 2012 12:13:08 -0400
From: Sascha Hauer <s.hauer@pengutronix.de>
To: linux-serial@vger.kernel.org
Cc: Alan Cox <alan@linux.intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>, linux-kernel@vger.kernel.org,
        devicetree-discuss@lists.ozlabs.org,
        <linux-arm-kernel@lists.infradead.org>
Subject: [PATCH v2] Add of helper for linux,stdout-path
Date: Fri,  5 Oct 2012 18:12:58 +0200
Message-Id: <1349453581-1685-1-git-send-email-s.hauer@pengutronix.de>
X-Mailer: git-send-email 1.7.10.4
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:21e:67ff:fe11:9c5c
X-SA-Exim-Mail-From: sha@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This adds a helper function to match the linux,stdout-path property
against a struct device and adds support for this property to the i.MX
serial driver.

Sascha

----------------------------------------------------------------
Sascha Hauer (3):
      serial_core: Add helper for matching against linux,stdout-path
      serial: i.MX: Make console support non optional
      serial: i.MX: evaluate linux,stdout-path property

 drivers/tty/serial/Kconfig       |   16 +---------------
 drivers/tty/serial/imx.c         |   11 ++++-------
 drivers/tty/serial/serial_core.c |   30 ++++++++++++++++++++++++++++++
 include/linux/serial_core.h      |    3 +++
 4 files changed, 38 insertions(+), 22 deletions(-)
