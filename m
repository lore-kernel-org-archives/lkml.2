Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758076Ab2IECTu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Sep 2012 22:19:50 -0400
Received: from mail-ie0-f174.google.com ([209.85.223.174]:44703 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753038Ab2IECTt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Sep 2012 22:19:49 -0400
Message-ID: <1346811570.3994.0.camel@phoenix>
Subject: [PATCH] HID: hid-lcpower: Use HID_UP_LOGIVENDOR instead of hard
 coded 0x0ffbc0000
From: Axel Lin <axel.lin@gmail.com>
To: Jiri Kosina <jkosina@suse.cz>
Cc: Chris Schlund <chrisschlund@gmx.de>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date: Wed, 05 Sep 2012 10:19:30 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/hid/hid-lcpower.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/hid/hid-lcpower.c b/drivers/hid/hid-lcpower.c
index c4fe9bd0..22bc14a 100644
--- a/drivers/hid/hid-lcpower.c
+++ b/drivers/hid/hid-lcpower.c
@@ -24,7 +24,7 @@ static int ts_input_mapping(struct hid_device *hdev, struct hid_input *hi,
 		struct hid_field *field, struct hid_usage *usage,
 		unsigned long **bit, int *max)
 {
-	if ((usage->hid & HID_USAGE_PAGE) != 0x0ffbc0000)
+	if ((usage->hid & HID_USAGE_PAGE) != HID_UP_LOGIVENDOR)
 		return 0;
 
 	switch (usage->hid & HID_USAGE) {
-- 
1.7.9.5



