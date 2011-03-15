Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756419Ab1COIx5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Mar 2011 04:53:57 -0400
Received: from ist.d-labs.de ([213.239.218.44]:47670 "EHLO mx01.d-labs.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755825Ab1COIx2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Mar 2011 04:53:28 -0400
From: Florian Mickler <florian@mickler.org>
To: mchehab@infradead.org
Cc: oliver@neukum.org, jwjstone@fastmail.fm,
        Florian Mickler <florian@mickler.org>, linux-kernel@vger.kernel.org,
        Mauro Carvalho Chehab <mchehab@redhat.com>,
        linux-media@vger.kernel.org
Subject: [PATCH 02/16] [media] dib0700: remove unused variable
Date: Tue, 15 Mar 2011 09:43:34 +0100
Message-Id: <1300178655-24832-2-git-send-email-florian@mickler.org>
X-Mailer: git-send-email 1.7.4.rc3
In-Reply-To: <1300178655-24832-1-git-send-email-florian@mickler.org>
References: <20110315093632.5fc9fb77@schatten.dmk.lab>
 <1300178655-24832-1-git-send-email-florian@mickler.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This variable is never used.

Signed-off-by: Florian Mickler <florian@mickler.org>
--
 drivers/media/dvb/dvb-usb/dib0700_core.c |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)
---
 drivers/media/dvb/dvb-usb/dib0700_core.c |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/drivers/media/dvb/dvb-usb/dib0700_core.c b/drivers/media/dvb/dvb-usb/dib0700_core.c
index 1c19b73..c705ea4 100644
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

