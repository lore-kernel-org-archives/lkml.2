Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759900Ab2JLQiO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Oct 2012 12:38:14 -0400
Received: from mail-da0-f46.google.com ([209.85.210.46]:53171 "EHLO
	mail-da0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754969Ab2JLQiL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Oct 2012 12:38:11 -0400
From: Adil Mujeeb <mujeeb.adil@gmail.com>
To: pavel@ucw.cz
Cc: gregkh@linuxfoundation.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, Adil Mujeeb <mujeeb.adil@gmail.com>
Subject: [PATCH 4/9] Staging: winbond: sem_api: Fixed coding style issue
Date: Fri, 12 Oct 2012 22:07:10 +0530
Message-Id: <1350059835-5408-5-git-send-email-mujeeb.adil@gmail.com>
X-Mailer: git-send-email 1.7.6.msysgit.0
In-Reply-To: <1350059835-5408-1-git-send-email-mujeeb.adil@gmail.com>
References: <1350059835-5408-1-git-send-email-mujeeb.adil@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fixed checkpatch.pl reported ERROR

Signed-off-by: Adil Mujeeb <mujeeb.adil@gmail.com>
---
 linux-3.6-rc7/drivers/staging/winbond/sme_api.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/linux-3.6-rc7/drivers/staging/winbond/sme_api.h b/linux-3.6-rc7/drivers/staging/winbond/sme_api.h
index 8f4596c..47b7238 100644
--- a/linux-3.6-rc7/drivers/staging/winbond/sme_api.h
+++ b/linux-3.6-rc7/drivers/staging/winbond/sme_api.h
@@ -138,7 +138,7 @@ s8 sme_set_txrate_policy(void *pcore_data, u8 policy);
 s8 sme_get_txrate_policy(void *pcore_data, u8 *policy);
 s8 sme_get_cwmin_value(void *pcore_data, u8 *cwmin);
 s8 sme_get_cwmax_value(void *pcore_data, u16 *cwmax);
-s8 sme_get_ms_radio_mode(void *pcore_data, u8 * pMsRadioOff);
+s8 sme_get_ms_radio_mode(void *pcore_data, u8 *pMsRadioOff);
 s8 sme_set_ms_radio_mode(void *pcore_data, u8 boMsRadioOff);
 
 void sme_get_tx_power_level(void *pcore_data, u32 *TxPower);
-- 
1.7.7.3

