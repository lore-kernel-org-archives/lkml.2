Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758055Ab1DKKOx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Apr 2011 06:14:53 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:44570 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755194Ab1DKKOw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Apr 2011 06:14:52 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:mime-version
         :content-type:content-transfer-encoding;
        b=r2uoft0g7mDNyXoWM6awqKkEB8A280M5jdjUICpDtf7tfG3pz3ZT4QFWT0wUeiA+W9
         TwFt3xraXg3GFKUWZWLcAC9GmQDeJrN8ke9zgiNbPsxYWkyF6+CODAUBsmcNU79o6rEy
         sA0syEDIoKpWcqxek7iejrleieJ6iOD30al7s=
From: =?UTF-8?q?Weiping=20Pan=28=E6=BD=98=E5=8D=AB=E5=B9=B3=29?= 
	<panweiping3@gmail.com>
Cc: =?UTF-8?q?Weiping=20Pan (=E6=BD=98=E5=8D=AB=E5=B9=B3) ?= 
	<panweiping3@gmail.com>,
        Li Yang <leoli@freescale.com> (maintainer:FREESCALE USB PER...),
        David Brownell <dbrownell@users.sourceforge.net> (maintainer:USB
	GADGET/PERIPH...),
        Greg Kroah-Hartman <gregkh@suse.de> (supporter:USB SUBSYSTEM),
        linux-usb@vger.kernel.org (open list:FREESCALE USB PER...),
        linuxppc-dev@lists.ozlabs.org (open list:FREESCALE USB PER...),
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH 3/4] usb:fix a typo
Date: Mon, 11 Apr 2011 18:16:15 +0800
Message-Id: <1302516975-9575-1-git-send-email-panweiping3@gmail.com>
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
 drivers/usb/gadget/fsl_qe_udc.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/usb/gadget/fsl_qe_udc.h b/drivers/usb/gadget/fsl_qe_udc.h
index e35e24f..1da5fb0 100644
--- a/drivers/usb/gadget/fsl_qe_udc.h
+++ b/drivers/usb/gadget/fsl_qe_udc.h
@@ -207,7 +207,7 @@ struct qe_frame{
 
 /* Frame status field */
 /* Receive side */
-#define FRAME_OK               0x00000000 /* Frame tranmitted or received OK */
+#define FRAME_OK               0x00000000 /* Frame transmitted or received OK */
 #define FRAME_ERROR            0x80000000 /* Error occurred on frame */
 #define START_FRAME_LOST       0x40000000 /* START_FRAME_LOST */
 #define END_FRAME_LOST         0x20000000 /* END_FRAME_LOST */
-- 
1.7.4

