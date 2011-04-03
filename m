Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752912Ab1DCRYp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Apr 2011 13:24:45 -0400
Received: from ist.d-labs.de ([213.239.218.44]:54623 "EHLO mx01.d-labs.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752775Ab1DCRYm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Apr 2011 13:24:42 -0400
From: Florian Mickler <florian@mickler.org>
To: mchehab@infradead.org
Cc: oliver@neukum.org, linux-kernel@vger.kernel.org,
        linux-media@vger.kernel.org, patrick.boettcher@dibcom.fr,
        Florian Mickler <florian@mickler.org>
Subject: [PATCH 2/2] [media] dib0700: remove unused variable
Date: Sun,  3 Apr 2011 19:23:43 +0200
Message-Id: <1301851423-21969-3-git-send-email-florian@mickler.org>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1301851423-21969-1-git-send-email-florian@mickler.org>
References: <1301851423-21969-1-git-send-email-florian@mickler.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This variable is never used.

Signed-off-by: Florian Mickler <florian@mickler.org>

---
 drivers/media/dvb/dvb-usb/dib0700_core.c |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/drivers/media/dvb/dvb-usb/dib0700_core.c b/drivers/media/dvb/dvb-usb/dib0700_core.c
index ca80520..7f6f023 100644
--- a/drivers/media/dvb/dvb-usb/dib0700_core.c
+++ b/drivers/media/dvb/dvb-usb/dib0700_core.c
@@ -625,7 +625,6 @@ struct dib0700_rc_response {
 static void dib0700_rc_urb_completion(struct urb *purb)
 {
 	struct dvb_usb_device *d = purb->context;
-	struct dib0700_state *st;
 	struct dib0700_rc_response *poll_reply;
 	u32 uninitialized_var(keycode);
 	u8 toggle;
@@ -640,7 +639,6 @@ static void dib0700_rc_urb_completion(struct urb *purb)
 		return;
 	}
 
-	st = d->priv;
 	poll_reply = purb->transfer_buffer;
 
 	if (purb->status < 0) {
-- 
1.7.4.1

