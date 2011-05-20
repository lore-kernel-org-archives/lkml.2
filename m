Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935531Ab1ETJoU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 May 2011 05:44:20 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:46929 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935502Ab1ETJoT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 May 2011 05:44:19 -0400
From: Shawn Guo <shawn.guo@linaro.org>
To: linux-kernel@vger.kernel.org
Cc: grant.likely@secretlab.ca, linus.walleij@linaro.org, kernel@pengutronix.de,
        linux-arm-kernel@lists.infradead.org, patches@linaro.org
Subject: [PATCH 0/4] add gpio driver gpio-mxs
Date: Fri, 20 May 2011 17:51:25 +0800
Message-Id: <1305885089-27343-1-git-send-email-shawn.guo@linaro.org>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The patch set is to move Freescale MXS gpio driver from mach-mxs
into drivers/gpio.  Different from u300 gpio driver that all gpio
ports are registered as one device, gpio-mxs expects every single
port is a gpio device.

The first 3 patches are just to ease review and can be squashed into
the last one.

Shawn Guo (4):
      gpio: gpio-mxs: add file gpio-mxs.c
      gpio: gpio-mxs: drop mach-specific accessors
      gpio: gpio-mxs: remove gpio port definition and registration
      gpio: gpio-mxs: add gpio driver for Freescale MXS architecture

 drivers/gpio/Kconfig    |    3 +
 drivers/gpio/Makefile   |    1 +
 drivers/gpio/gpio-mxs.c |  371 +++++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 375 insertions(+), 0 deletions(-)

Regards,
Shawn
