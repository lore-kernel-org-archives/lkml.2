Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754077Ab1CFOqd (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Mar 2011 09:46:33 -0500
Received: from ist.d-labs.de ([213.239.218.44]:45000 "EHLO mx01.d-labs.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753670Ab1CFOqS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Mar 2011 09:46:18 -0500
From: Florian Mickler <florian@mickler.org>
To: mchehab@infradead.org
Cc: Florian Mickler <florian@mickler.org>, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org, Greg Kroah-Hartman <greg@kroah.com>,
        "Rafael J. Wysocki" <rjw@sisk.pl>,
        Maciej Rutecki <maciej.rutecki@gmail.com>,
        Oliver Neukum <oliver@neukum.org>, Jack Stone <jwjstone@fastmail.fm>
Subject: [PATCH 2/3] [media] dib0700: remove unused variable
Date: Sun,  6 Mar 2011 15:45:15 +0100
Message-Id: <1299422716-29461-2-git-send-email-florian@mickler.org>
X-Mailer: git-send-email 1.7.4.rc3
In-Reply-To: <1299422716-29461-1-git-send-email-florian@mickler.org>
References: <20110306153805.001011a9@schatten.dmk.lab>
 <1299422716-29461-1-git-send-email-florian@mickler.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Florian Mickler <florian@mickler.org>
CC: Mauro Carvalho Chehab <mchehab@infradead.org>
CC: linux-media@vger.kernel.org
CC: linux-kernel@vger.kernel.org
CC: Greg Kroah-Hartman <greg@kroah.com>
CC: Rafael J. Wysocki <rjw@sisk.pl>
CC: Maciej Rutecki <maciej.rutecki@gmail.com>
CC: Oliver Neukum <oliver@neukum.org>
CC: Jack Stone <jwjstone@fastmail.fm>
---
 drivers/media/dvb/dvb-usb/dib0700_core.c |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/drivers/media/dvb/dvb-usb/dib0700_core.c b/drivers/media/dvb/dvb-usb/dib0700_core.c
index 028ed87..77a3060 100644
--- a/drivers/media/dvb/dvb-usb/dib0700_core.c
+++ b/drivers/media/dvb/dvb-usb/dib0700_core.c
@@ -576,7 +576,6 @@ struct dib0700_rc_response {
 static void dib0700_rc_urb_completion(struct urb *purb)
 {
 	struct dvb_usb_device *d = purb->context;
-	struct dib0700_state *st;
 	struct dib0700_rc_response *poll_reply;
 	u32 uninitialized_var(keycode);
 	u8 toggle;
@@ -591,7 +590,6 @@ static void dib0700_rc_urb_completion(struct urb *purb)
 		return;
 	}
 
-	st = d->priv;
 	poll_reply = purb->transfer_buffer;
 
 	if (purb->status < 0) {
-- 
1.7.4.rc3

