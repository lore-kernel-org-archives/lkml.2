Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753658Ab1LTAnU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Dec 2011 19:43:20 -0500
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:36867 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752335Ab1LTAnT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Dec 2011 19:43:19 -0500
From: Felipe Contreras <felipe.contreras@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= 
	<u.kleine-koenig@pengutronix.de>,
        Felipe Balbi <balbi@ti.com>, Vladimir Zapolskiy <vz@mleia.com>,
        Felipe Contreras <felipe.contreras@gmail.com>
Subject: [PATCH 00/10] kconfigs cleanups and fixes
Date: Tue, 20 Dec 2011 02:42:17 +0200
Message-Id: <1324341747-5922-1-git-send-email-felipe.contreras@gmail.com>
X-Mailer: git-send-email 1.7.8.rc1.14.g248db
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Here are some cleanups for kconfigs, mostly in ARM and USB stuff.

Some of these have already been sent in the past, but never splitted nor
applied, now I'm doing that. Others are new issues, and some actual warnings
are fixed.

Cheers.

Felipe Contreras (10):
  arm: omap4: fix kconfig warning
  arm: vexpress: fix kconfig warning
  arm: omap2: fix omap3 touchbook kconfig warning
  arm: omap2: fix regulator warnings
  usb: musb: trivial Kconfig cleanups
  usb: core: trivial Kconfig cleanups
  usb: gadget: remove useless depends on Kconfig
  usb: gadget: remove useless dependency in config
  usb: otg: trivial cleanups
  musb: cleanup kconfig

 arch/arm/mach-omap2/Kconfig    |   13 ++++++-------
 arch/arm/mach-vexpress/Kconfig |    4 ++--
 drivers/usb/core/Kconfig       |    4 ----
 drivers/usb/gadget/Kconfig     |    5 -----
 drivers/usb/musb/Kconfig       |   15 ++++++++-------
 drivers/usb/otg/Kconfig        |   20 ++++++++++----------
 6 files changed, 26 insertions(+), 35 deletions(-)

-- 
1.7.8.rc1.14.g248db

