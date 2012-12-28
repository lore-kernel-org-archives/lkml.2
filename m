Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754916Ab2L1Tyi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Dec 2012 14:54:38 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:55000 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754326Ab2L1TRN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Dec 2012 14:17:13 -0500
Message-Id: <20121228190400.710267219@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Fri, 28 Dec 2012 20:06:06 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Alexander Shiyan <shc_work@mail.ru>,
        "David S. Miller" <davem@davemloft.net>
Subject: [ 156/173] irda: sir_dev: Fix copy/paste typo
In-Reply-To: <20121228190330.025298996@decadent.org.uk>
X-SA-Exim-Connect-IP: 151.217.219.220
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alexander Shiyan <shc_work@mail.ru>

[ Upstream commit 2355a62bcbdcc4b567425bab036bfab6ade87eed ]

Signed-off-by: Alexander Shiyan <shc_work@mail.ru>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/net/irda/sir_dev.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/irda/sir_dev.c b/drivers/net/irda/sir_dev.c
index 5039f08..43e9ab4 100644
--- a/drivers/net/irda/sir_dev.c
+++ b/drivers/net/irda/sir_dev.c
@@ -222,7 +222,7 @@ static void sirdev_config_fsm(struct work_struct *work)
 			break;
 
 		case SIRDEV_STATE_DONGLE_SPEED:
-			if (dev->dongle_drv->reset) {
+			if (dev->dongle_drv->set_speed) {
 				ret = dev->dongle_drv->set_speed(dev, fsm->param);
 				if (ret < 0) {
 					fsm->result = ret;


