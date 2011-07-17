Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756204Ab1GQSnv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Jul 2011 14:43:51 -0400
Received: from mail.perches.com ([173.55.12.10]:4055 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754062Ab1GQSnu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Jul 2011 14:43:50 -0400
From: Joe Perches <joe@perches.com>
To: Kalle Valo <kvalo@qca.qualcomm.com>
Cc: devel@linuxdriverproject.org, gregkh@suse.de, error27@gmail.com,
        linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org
Subject: [PATCH 0/3] ath6kl: neatening
Date: Sun, 17 Jul 2011 11:43:41 -0700
Message-Id: <cover.1310927985.git.joe@perches.com>
X-Mailer: git-send-email 1.7.6.131.g99019
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Joe Perches (3):
  ath6kl: Add missing newlines and coalesce messages
  ath6kl: Remove __func__ uses from ath6kl_err
  ath6kl: cfg80211: Add and use ath6kl_cfg80211_ready helper

 drivers/net/wireless/ath/ath6kl/bmi.c      |    2 +-
 drivers/net/wireless/ath/ath6kl/cfg80211.c |  230 ++++++++-------------------
 drivers/net/wireless/ath/ath6kl/debug.c    |    2 +-
 drivers/net/wireless/ath/ath6kl/htc.c      |   15 +-
 drivers/net/wireless/ath/ath6kl/htc_hif.c  |    3 +-
 drivers/net/wireless/ath/ath6kl/init.c     |   79 ++++------
 drivers/net/wireless/ath/ath6kl/main.c     |   16 +-
 drivers/net/wireless/ath/ath6kl/txrx.c     |   53 +++----
 drivers/net/wireless/ath/ath6kl/wmi.c      |   29 ++--
 9 files changed, 155 insertions(+), 274 deletions(-)

-- 
1.7.6.131.g99019

