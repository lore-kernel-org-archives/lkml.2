Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754900Ab0LDJR0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Dec 2010 04:17:26 -0500
Received: from filtteri5.pp.htv.fi ([213.243.153.188]:53155 "EHLO
	filtteri5.pp.htv.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754644Ab0LDJQV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Dec 2010 04:16:21 -0500
From: Pekka Enberg <penberg@kernel.org>
To: gregkh@suse.de
Cc: linux-kernel@vger.kernel.org, Pekka Enberg <penberg@kernel.org>,
        Pavel Machek <pavel@ucw.cz>
Subject: [PATCH 6/6] w35und: Kill struct hwdata ->SurpriseRemoveCount
Date: Sat,  4 Dec 2010 11:16:17 +0200
Message-Id: <1291454177-5102-6-git-send-email-penberg@kernel.org>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1291454177-5102-1-git-send-email-penberg@kernel.org>
References: <1291454177-5102-1-git-send-email-penberg@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch kills the ->SurpriseRemoveCount member of struct hwdata. It's not
used at all so it's safe to remove it.

Cc: Pavel Machek <pavel@ucw.cz>
Signed-off-by: Pekka Enberg <penberg@kernel.org>
---
 drivers/staging/winbond/wbhal.h |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/winbond/wbhal.h b/drivers/staging/winbond/wbhal.h
index 1c91588..dcf3b21 100644
--- a/drivers/staging/winbond/wbhal.h
+++ b/drivers/staging/winbond/wbhal.h
@@ -507,8 +507,6 @@ struct hw_data {
 	u32		RxByteCountLast;
 	u32		TxByteCountLast;
 
-	atomic_t	SurpriseRemoveCount;
-
 	/* For global timer */
 	u32		time_count;	/* TICK_TIME_100ms 1 = 100ms */
 };
-- 
1.7.0.4

