Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932656Ab1LERYP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Dec 2011 12:24:15 -0500
Received: from smtp.nokia.com ([147.243.128.24]:23581 "EHLO mgw-da01.nokia.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932599Ab1LERYM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Dec 2011 12:24:12 -0500
From: Felipe Contreras <felipe.contreras@nokia.com>
To: linux-main <linux-kernel@vger.kernel.org>
Cc: Kalle Jokiniemi <kalle.jokiniemi@nokia.com>,
        Heikki Krogerus <heikki.krogerus@nokia.com>,
        Anton Vorontsov <cbouatmailru@gmail.com>,
        Tony Lindgren <tony@atomide.com>,
        Felipe Contreras <felipe.contreras@nokia.com>
Subject: [PATCH 0/2] omap: rx51: fix USB networking
Date: Mon,  5 Dec 2011 19:23:38 +0200
Message-Id: <1323105820-25946-1-git-send-email-felipe.contreras@nokia.com>
X-Mailer: git-send-email 1.7.8.rc3.17.gf56ef1
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Here are a couple of fixes in order to get USB networking on the Nokia N900.
Looks like requesting the reset GPIO breakes the usb0 link presence detection.

Felipe Contreras (2):
  isp1704_charger: fix missing check
  Revert "ARM: RX-51: Enable isp1704 power on/off"

 arch/arm/mach-omap2/board-rx51-peripherals.c |   27 +------------------------
 drivers/power/isp1704_charger.c              |    2 +-
 2 files changed, 3 insertions(+), 26 deletions(-)

-- 
1.7.8.rc3.17.gf56ef1

