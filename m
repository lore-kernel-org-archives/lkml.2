Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760118Ab0FKKNt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jun 2010 06:13:49 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:45062 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758542Ab0FKKNq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jun 2010 06:13:46 -0400
From: Luotao Fu <l.fu@pengutronix.de>
To: Samuel Ortiz <sameo@linux.intel.com>,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
       l.fu@pengutronix.de
Subject: Patch serie for STMPE811
Date: Fri, 11 Jun 2010 12:13:12 +0200
Message-Id: <1276251195-22981-1-git-send-email-l.fu@pengutronix.de>
X-Mailer: git-send-email 1.7.1
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: l.fu@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,
the following patch serie adds support to the STMPE811 device by ST Micro.
STMPE811 is a multifunction device, which contains a GPIO controller,
a Touchscreen controller, an ADC and a temperature sensor. The following
patch serie provides a core driver, a driver for the GPIO controller and a
driver for the touch screen controller.

The documentation for the chip is, well, let's say not quite accurate.
Especially the touch screen controller crashes under conditions, which are not
documented any where. (did not manage to find any erratum also) The reference
code by st is crappy and also leads to crashes. I made some workarounds for
these troubles and documented them in the comments in the driver. So pls check
the comment if you spot any strange stuff.

Tested on a board with a i.MX27 SOC.

cheers
Luotao Fu

