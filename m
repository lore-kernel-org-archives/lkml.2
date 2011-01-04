Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752087Ab1ADQv0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jan 2011 11:51:26 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:54437 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751683Ab1ADQvZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jan 2011 11:51:25 -0500
From: Wolfram Sang <w.sang@pengutronix.de>
To: linux-kernel@vger.kernel.org
Cc: Wolfram Sang <w.sang@pengutronix.de>,
        David Brownell <dbrownell@users.sourceforge.net>,
        Greg KH <gregkh@suse.de>
Subject: [PATCH 0/2] Annotate gpio-configuration with __must_check
Date: Tue,  4 Jan 2011 17:51:06 +0100
Message-Id: <1294159868-4989-1-git-send-email-w.sang@pengutronix.de>
X-Mailer: git-send-email 1.7.2.3
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:221:70ff:fe71:1890
X-SA-Exim-Mail-From: w.sang@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Here is a small series generating a lot of warnings, especially in board
bringup-files. Still, I think it is worthwhile to be strict about checking
return values of gpio-configuration-functions. My suggestion to keep the noise
a bit lower is to put it into linux-next for one cycle and then merge it for
2.6.39? That should give people some time to fix the issues in time. Looking
forward to comments.

Wolfram Sang (2):
  gpiolib: annotate gpio-intialization with __must_check
  gpiolib: add missing functions to generic fallback

 Documentation/gpio.txt     |    2 +-
 include/asm-generic/gpio.h |   10 +++++-----
 include/linux/gpio.h       |   26 +++++++++++++++++++++++---
 3 files changed, 29 insertions(+), 9 deletions(-)

-- 
1.7.2.3

