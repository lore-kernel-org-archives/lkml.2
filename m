Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752566Ab1F3Vsl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jun 2011 17:48:41 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:50316 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751219Ab1F3Vsk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jun 2011 17:48:40 -0400
From: Bjarke Istrup Pedersen <gurligebis@gentoo.org>
To: linux-kernel@vger.kernel.org
Cc: Bjarke Istrup Pedersen <gurligebis@gentoo.org>
Subject: [PATCH 0/2] Depends-on-CONFIG_MFD_CS5535 patchset
Date: Thu, 30 Jun 2011 21:48:01 +0000
Message-Id: <1309470483-18546-1-git-send-email-gurligebis@gentoo.org>
X-Mailer: git-send-email 1.7.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bjarke Istrup Pedersen <gurligebis@gentoo.org>

Since 2.6.39 when CONFIG_MFD_CS5535, LEDS_NET5501 and GEODE_WDT stopped
working.

These two patches fixes this by forcing CONFIG_MFD_CS5535 to be enabled,
before they can be enabled.

Bjarke Istrup Pedersen (2):
  Making sure LEDS_NET5501 depends on CONFIG_MFD_CS5535
  Making sure GEODE_WDT depends on CONFIG_MFD_CS5535

 drivers/leds/Kconfig     |    2 +-
 drivers/watchdog/Kconfig |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

-- 
1.7.6

