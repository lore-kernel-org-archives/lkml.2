Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755492Ab1DKKOP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Apr 2011 06:14:15 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:50869 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755194Ab1DKKOO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Apr 2011 06:14:14 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:mime-version
         :content-type:content-transfer-encoding;
        b=gd2Jh7l9Xid7WAoUHmLAUi0HhohChVolAQFI95/JWFFlNA9QJK4Nd/yxfixRkOKyha
         HLm6Ik5H/WijPXQhArpp5wyk/h7MXaYl5wiTwBgLQSMyipcwbVlgZGDAA/HwiQcGTkI5
         x95yQvdhZjKoeooJGyZl+7mia/aZ3u5cmywRw=
From: =?UTF-8?q?Weiping=20Pan=28=E6=BD=98=E5=8D=AB=E5=B9=B3=29?= 
	<panweiping3@gmail.com>
Cc: =?UTF-8?q?Weiping=20Pan (=E6=BD=98=E5=8D=AB=E5=B9=B3) ?= 
	<panweiping3@gmail.com>,
        Greg Kroah-Hartman <gregkh@suse.de> (maintainer:STAGING SUBSYSTEM 
	,commit_signer:10/13=77%),
        Julia Lawall <julia@diku.dk> (commit_signer:2/13=15%),
        Nicolas Kaiser <nikai@nikai.net> (commit_signer:2/13=15%),
        =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= 
	<u.kleine-koenig@pengutronix.de> (commit_signer:2/13=15%),
        Ilia Mirkin <imirkin@alum.mit.edu> (commit_signer:1/13=8%),
        devel@driverdev.osuosl.org (open list:STAGING SUBSYSTEM),
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH 1/4] comedi: fix a typo
Date: Mon, 11 Apr 2011 18:15:31 +0800
Message-Id: <1302516932-9497-1-git-send-email-panweiping3@gmail.com>
X-Mailer: git-send-email 1.7.4
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

replace tranmitted with transmitted.

Signed-off-by: Weiping Pan(潘卫平) <panweiping3@gmail.com>
---
 drivers/staging/comedi/drivers/usbdux.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/staging/comedi/drivers/usbdux.c b/drivers/staging/comedi/drivers/usbdux.c
index e543e6c..1d09bfa 100644
--- a/drivers/staging/comedi/drivers/usbdux.c
+++ b/drivers/staging/comedi/drivers/usbdux.c
@@ -1530,7 +1530,7 @@ static int usbdux_ao_cmdtest(struct comedi_device *dev,
 	/* we always output at 1kHz just now all channels at once */
 	if (0) {		/* (this_usbduxsub->high_speed) */
 		/*
-		 * in usb-2.0 only one conversion it tranmitted but with 8kHz/n
+		 * in usb-2.0 only one conversion it transmitted but with 8kHz/n
 		 */
 		cmd->convert_src &= TRIG_TIMER;
 	} else {
-- 
1.7.4

