Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753167Ab1CUKU4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Mar 2011 06:20:56 -0400
Received: from ist.d-labs.de ([213.239.218.44]:44316 "EHLO mx01.d-labs.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752929Ab1CUKTe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Mar 2011 06:19:34 -0400
From: Florian Mickler <florian@mickler.org>
To: mchehab@infradead.org
Cc: linux-kernel@vger.kernel.org, linux-media@vger.kernel.org, pb@linuxtv.org,
        Florian Mickler <florian@mickler.org>
Subject: [PATCH 4/9] [media] vp702x: remove unused variable
Date: Mon, 21 Mar 2011 11:19:09 +0100
Message-Id: <1300702754-16376-5-git-send-email-florian@mickler.org>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1300702754-16376-1-git-send-email-florian@mickler.org>
References: <1300702754-16376-1-git-send-email-florian@mickler.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

struct vp702x_device_state.power_state is nowhere referenced.

Signed-off-by: Florian Mickler <florian@mickler.org>
---
 drivers/media/dvb/dvb-usb/vp702x.h |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/drivers/media/dvb/dvb-usb/vp702x.h b/drivers/media/dvb/dvb-usb/vp702x.h
index 86960c6..20b9005 100644
--- a/drivers/media/dvb/dvb-usb/vp702x.h
+++ b/drivers/media/dvb/dvb-usb/vp702x.h
@@ -99,7 +99,6 @@ extern int dvb_usb_vp702x_debug;
 /* IN  i: 0, v: 0, no extra buffer */
 
 struct vp702x_device_state {
-	u8 power_state;
 	struct mutex buf_mutex;
 	int buf_len;
 	u8 *buf;
-- 
1.7.4.1

