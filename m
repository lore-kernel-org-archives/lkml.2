Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754365Ab1BIKIM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Feb 2011 05:08:12 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:46679 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754280Ab1BIKIK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Feb 2011 05:08:10 -0500
From: =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: trivial@kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 04/10] trivial: fix typos concerning "controller"
Date: Wed,  9 Feb 2011 11:07:36 +0100
Message-Id: <1297246062-23777-4-git-send-email-u.kleine-koenig@pengutronix.de>
X-Mailer: git-send-email 1.7.2.3
In-Reply-To: <1297246062-23777-1-git-send-email-u.kleine-koenig@pengutronix.de>
References: <1297246062-23777-1-git-send-email-u.kleine-koenig@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
---
 drivers/usb/host/ehci-msm.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/usb/host/ehci-msm.c b/drivers/usb/host/ehci-msm.c
index 413f4de..7155a54 100644
--- a/drivers/usb/host/ehci-msm.c
+++ b/drivers/usb/host/ehci-msm.c
@@ -37,7 +37,7 @@ static struct otg_transceiver *otg;
 /*
  * ehci_run defined in drivers/usb/host/ehci-hcd.c reset the controller and
  * the configuration settings in ehci_msm_reset vanish after controller is
- * reset. Resetting the controler in ehci_run seems to be un-necessary
+ * reset. Resetting the controller in ehci_run seems to be un-necessary
  * provided HCD reset the controller before calling ehci_run. Most of the HCD
  * do but some are not. So this function is same as ehci_run but we don't
  * reset the controller here.
-- 
1.7.2.3

