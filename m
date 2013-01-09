Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932729Ab3AIUgf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jan 2013 15:36:35 -0500
Received: from mail.kernel.org ([198.145.19.201]:40910 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932595Ab3AIUg2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jan 2013 15:36:28 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Alexander Shiyan <shc_work@mail.ru>,
        "David S. Miller" <davem@davemloft.net>
Subject: [ 06/47] irda: sir_dev: Fix copy/paste typo
Date: Wed,  9 Jan 2013 12:35:01 -0800
Message-Id: <20130109201730.214810996@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.rc1.5.g7e0651a
In-Reply-To: <20130109201729.435233560@linuxfoundation.org>
References: <20130109201729.435233560@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------


From: Alexander Shiyan <shc_work@mail.ru>

[ Upstream commit 2355a62bcbdcc4b567425bab036bfab6ade87eed ]

Signed-off-by: Alexander Shiyan <shc_work@mail.ru>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/irda/sir_dev.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/net/irda/sir_dev.c
+++ b/drivers/net/irda/sir_dev.c
@@ -221,7 +221,7 @@ static void sirdev_config_fsm(struct wor
 			break;
 
 		case SIRDEV_STATE_DONGLE_SPEED:
-			if (dev->dongle_drv->reset) {
+			if (dev->dongle_drv->set_speed) {
 				ret = dev->dongle_drv->set_speed(dev, fsm->param);
 				if (ret < 0) {
 					fsm->result = ret;


