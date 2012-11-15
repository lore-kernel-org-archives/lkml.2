Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2993160Ab2KOJbm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Nov 2012 04:31:42 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:52397 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S2993129Ab2KOJbj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Nov 2012 04:31:39 -0500
From: Sascha Hauer <s.hauer@pengutronix.de>
To: linux-serial@vger.kernel.org
Cc: Alan Cox <alan@linux.intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Grant Likely <grant.likely@secretlab.ca>, linux-kernel@vger.kernel.org,
        devicetree-discuss@lists.ozlabs.org,
        linux-arm-kernel@lists.infradead.org, kernel@pengutronix.de
Subject: [PATCH v4] linux,stdout-path helper
Date: Thu, 15 Nov 2012 10:31:03 +0100
Message-Id: <1352971866-540-1-git-send-email-s.hauer@pengutronix.de>
X-Mailer: git-send-email 1.7.10.4
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:21e:67ff:fe11:9c5c
X-SA-Exim-Mail-From: sha@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following adds a helper for matching the linux,stdout-path property
in the chosen node and makes use of it in the i.MX serial driver.

changes since v3:

- move code from separate files to drivers/of/base.c and include/linux/of.h

changes since v2:

- move helper to OF core and make it independent of serial devices

changes since v1:

- move it out of the i.MX serial driver and make it generic for serial
  devices.

