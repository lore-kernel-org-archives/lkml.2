Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752332Ab2GJCrZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jul 2012 22:47:25 -0400
Received: from mail-gh0-f174.google.com ([209.85.160.174]:37340 "EHLO
	mail-gh0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751042Ab2GJCrY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jul 2012 22:47:24 -0400
From: Marcos Paulo de Souza <marcos.souza.org@gmail.com>
To: gregkh@linuxfoundation.org
Cc: lauri.hintsala@bluegiga.com, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org,
        Marcos Paulo de Souza <marcos.souza.org@gmail.com>
Subject: [PATCH 0/5] staging: csr: Cleanup driver
Date: Mon,  9 Jul 2012 23:43:08 -0300
Message-Id: <1341888193-12182-1-git-send-email-marcos.souza.org@gmail.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi kernel guys!

This patchset aims to clean a little the csr driver by removing dead code and
unused/commented macros.

All the macros and dead code was reported by the forgotten-macros tool
(https://github.com/marcosps/forgotten_macros).

This patchset is against staging-next.

I hope you like it :)

Marcos Paulo de Souza (5):
  staging: csr: Remove dead code
  staging: csr: csr_util.h: Remove commented macros
  staging: csr: netdev.c: Remove unused macros
  staging: csr: unifi_sme.c: Remove unused macros
  staging: csr: Remove unused macros

 drivers/staging/csr/csr_util.h               |    7 ---
 drivers/staging/csr/csr_wifi_hip_card_sdio.c |    3 --
 drivers/staging/csr/drv.c                    |    1 -
 drivers/staging/csr/firmware.c               |    1 -
 drivers/staging/csr/mlme.c                   |    5 ---
 drivers/staging/csr/monitor.c                |   59 --------------------------
 drivers/staging/csr/netdev.c                 |    5 ---
 drivers/staging/csr/sme_sys.c                |    1 -
 drivers/staging/csr/unifi_native.h           |   19 ---------
 drivers/staging/csr/unifi_sme.c              |    6 ---
 10 files changed, 107 deletions(-)

-- 
1.7.10.4

