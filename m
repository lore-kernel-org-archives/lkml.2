Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758105Ab2K3MCz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Nov 2012 07:02:55 -0500
Received: from mail-wg0-f42.google.com ([74.125.82.42]:48570 "EHLO
	mail-wg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755013Ab2K3MCy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Nov 2012 07:02:54 -0500
From: Lee Jones <lee.jones@linaro.org>
To: linux-kernel@vger.kernel.org
Cc: linus.walleij@stericsson.com, arnd@arndb.de, cbou@mail.ru,
        dwmw2@infradead.org, rajanikanth.hv@linaro.org
Subject: [PATCH 00/12] Refactoring the ab8500 battery management drivers 
Date: Fri, 30 Nov 2012 11:57:22 +0000
Message-Id: <1354276654-590-1-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The aim of this and subsequent patch-sets is to refactor battery
management services provided by the ab8500 MFD. This first patch-set
brings a few modifications to the collection which happened on the
internal kernel, but were never Mainlined. There are lots more of
these to come. We also tidy-up some of the Device Tree related patches
which are currently pending in -next.

 drivers/mfd/ab8500-core.c       |    8 -
 drivers/power/ab8500_bmdata.c   |  517 +++++++++++++++++++--------------------
 drivers/power/ab8500_btemp.c    |   96 ++++----
 drivers/power/ab8500_charger.c  |  222 ++++++++++++-----
 drivers/power/ab8500_fg.c       |  123 +++++-----
 drivers/power/abx500_chargalg.c |  133 +++++-----
 include/linux/mfd/abx500.h      |    6 +-
 7 files changed, 592 insertions(+), 513 deletions(-)

