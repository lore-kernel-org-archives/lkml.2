Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755364Ab1AGSnd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Jan 2011 13:43:33 -0500
Received: from 89-230.252-81.static-ip.oleane.fr ([81.252.230.89]:54637 "EHLO
	smtp.lii-enac.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755289Ab1AGSl5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Jan 2011 13:41:57 -0500
From: Benjamin Tissoires <benjamin.tissoires@enac.fr>
To: Stephane Chatty <chatty@enac.fr>, Henrik Rydberg <rydberg@euromail.se>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Jiri Kosina <jkosina@suse.cz>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: Benjamin Tissoires <benjamin.tissoires@enac.fr>
Subject: [RFC v3 2/5] hid: set HID_MAX_FIELD at 128
Date: Fri,  7 Jan 2011 19:42:39 +0100
Message-Id: <1294425762-29730-3-git-send-email-benjamin.tissoires@enac.fr>
X-Mailer: git-send-email 1.7.3.4
In-Reply-To: <1294425762-29730-1-git-send-email-benjamin.tissoires@enac.fr>
References: <1294425762-29730-1-git-send-email-benjamin.tissoires@enac.fr>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stantums multitouch panels sends more than 64 reports and this results
in not being able to handle all the touches given by this device.

This patch is required to be able to include Stantum panels in the
unified hid-multitouch driver.

Signed-off-by: Benjamin Tissoires <benjamin.tissoires@enac.fr>
Acked-by: Henrik Rydberg <rydberg@euromail.se>
---
 include/linux/hid.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/include/linux/hid.h b/include/linux/hid.h
index 75303b0..b76af97 100644
--- a/include/linux/hid.h
+++ b/include/linux/hid.h
@@ -402,7 +402,7 @@ struct hid_field {
 	__u16 dpad;			/* dpad input code */
 };
 
-#define HID_MAX_FIELDS 64
+#define HID_MAX_FIELDS 128
 
 struct hid_report {
 	struct list_head list;
-- 
1.7.3.4

