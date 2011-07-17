Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753065Ab1GQVjF (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Jul 2011 17:39:05 -0400
Received: from mail.perches.com ([173.55.12.10]:4089 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751835Ab1GQVjE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Jul 2011 17:39:04 -0400
From: Joe Perches <joe@perches.com>
To: Kalle Valo <kvalo@qca.qualcomm.com>
Cc: devel@linuxdriverproject.org, gregkh@suse.de, error27@gmail.com,
        linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org
Subject: [PATCH 0/2] ath6kl: more neatening
Date: Sun, 17 Jul 2011 14:38:55 -0700
Message-Id: <cover.1310938421.git.joe@perches.com>
X-Mailer: git-send-email 1.7.6.131.g99019
In-Reply-To: <4E2349D4.4000204@qca.qualcomm.com>
References: <4E2349D4.4000204@qca.qualcomm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Great, thanks. I have now applied your patches to ath6kl-cleanup tree
> and they will be included in patchset v3.

Here's a couple of more.

Joe Perches (2):
  ath6kl: Remove __func__ uses from ath6kl_dbg
  ath6kl: Remove trailing unpaired close paren from ath6kl_err uses

 drivers/net/wireless/ath/ath6kl/bmi.c      |    4 +-
 drivers/net/wireless/ath/ath6kl/cfg80211.c |  101 ++++++++++++---------------
 drivers/net/wireless/ath/ath6kl/debug.c    |   20 +++---
 drivers/net/wireless/ath/ath6kl/debug.h    |   27 ++++----
 drivers/net/wireless/ath/ath6kl/htc.c      |   11 ++--
 drivers/net/wireless/ath/ath6kl/init.c     |    8 +-
 drivers/net/wireless/ath/ath6kl/main.c     |   13 ++--
 drivers/net/wireless/ath/ath6kl/sdio.c     |   12 ++--
 drivers/net/wireless/ath/ath6kl/txrx.c     |   30 ++++-----
 drivers/net/wireless/ath/ath6kl/wmi.c      |    8 +--
 10 files changed, 107 insertions(+), 127 deletions(-)

-- 
1.7.6.131.g99019

