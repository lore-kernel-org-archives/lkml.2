Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758957Ab1KWKBb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Nov 2011 05:01:31 -0500
Received: from 88-230.252-81.static-ip.oleane.fr ([81.252.230.88]:41675 "EHLO
	smtp.lii-enac.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756930Ab1KWKB0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Nov 2011 05:01:26 -0500
From: Benjamin Tissoires <benjamin.tissoires@enac.fr>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Henrik Rydberg <rydberg@euromail.se>,
        Benjamin Tissoires <benjamin.tissoires@enac.fr>,
        Jiri Kosina <jkosina@suse.cz>, Stephane Chatty <chatty@lii-enac.fr>,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 4/8] hid-multitouch: remove .maxcontacts field for eGalax
Date: Wed, 23 Nov 2011 10:54:30 +0100
Message-Id: <1322042074-3759-5-git-send-email-benjamin.tissoires@enac.fr>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1322042074-3759-1-git-send-email-benjamin.tissoires@enac.fr>
References: <1322042074-3759-1-git-send-email-benjamin.tissoires@enac.fr>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some eGalax devices are 4 or 5 fingers touches, wereas others are 2.
This patch removes the limit in which all eGalax presents 2 touches.

Signed-off-by: Benjamin Tissoires <benjamin.tissoires@enac.fr>
---
 drivers/hid/hid-multitouch.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/drivers/hid/hid-multitouch.c b/drivers/hid/hid-multitouch.c
index 8250f3c..354a5cd 100644
--- a/drivers/hid/hid-multitouch.c
+++ b/drivers/hid/hid-multitouch.c
@@ -171,7 +171,6 @@ static struct mt_class mt_classes[] = {
 	{ .name = MT_CLS_EGALAX,
 		.quirks =  MT_QUIRK_SLOT_IS_CONTACTID |
 			MT_QUIRK_VALID_IS_INRANGE,
-		.maxcontacts = 2,
 		.sn_move = 4096,
 		.sn_pressure = 32,
 	},
-- 
1.7.4.4

