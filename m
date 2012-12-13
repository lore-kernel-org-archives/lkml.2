Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754152Ab2LMPV5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2012 10:21:57 -0500
Received: from mail-wi0-f174.google.com ([209.85.212.174]:35552 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752802Ab2LMPVz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2012 10:21:55 -0500
From: Lee Jones <lee.jones@linaro.org>
To: linux-kernel@vger.kernel.org
Cc: cbou@mail.ru
Subject: [PATCH 00/18] AB8500 battery management series upgrade 
Date: Thu, 13 Dec 2012 15:21:23 +0000
Message-Id: <1355412102-14265-1-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Anton,

Please find the next instalment of the AB8500 Power drivers upgrade.
A lot of work has taken place on the internal development track, but
little effort has gone into mainlining it. At last count there were
around 70+ patches which are in need of forward-porting, then
upstreaming. This patch-set aims to make a good start. :)

 drivers/power/Kconfig                |   15 +
 drivers/power/Makefile               |    1 +
 drivers/power/ab8500_bmdata.c        |   18 +-
 drivers/power/ab8500_btemp.c         |   27 +-
 drivers/power/ab8500_charger.c       |  348 ++++++--
 drivers/power/ab8500_fg.c            |  336 +++++--
 drivers/power/abx500_chargalg.c      |   30 +-
 drivers/power/pm2301_charger.c       | 1599 ++++++++++++++++++++++++++++++++++
 include/linux/mfd/abx500.h           |    6 +-
 include/linux/mfd/abx500/ab8500-bm.h |   10 +
 include/linux/mfd/abx500/ab8500.h    |    5 +
 include/linux/pm2301_charger.h       |   60 ++
 12 files changed, 2312 insertions(+), 143 deletions(-)

