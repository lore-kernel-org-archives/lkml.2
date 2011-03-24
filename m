Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933624Ab1CXSFr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Mar 2011 14:05:47 -0400
Received: from adelie.canonical.com ([91.189.90.139]:39822 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933572Ab1CXSFn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Mar 2011 14:05:43 -0400
From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
To: Jiri Kosina <jkosina@suse.cz>
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] HID: hid-ortek: update hid_info output
Date: Thu, 24 Mar 2011 15:05:37 -0300
Message-Id: <1300989937-4329-1-git-send-email-herton.krzesinski@canonical.com>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Minor cosmetic issue, after adding Ortek PKB-1700 support I forgot to
update the hid_info output string.

Signed-off-by: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
---
 drivers/hid/hid-ortek.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/drivers/hid/hid-ortek.c b/drivers/hid/hid-ortek.c
index f9b7dd4..6584c16 100644
--- a/drivers/hid/hid-ortek.c
+++ b/drivers/hid/hid-ortek.c
@@ -22,7 +22,8 @@ static __u8 *ortek_report_fixup(struct hid_device *hdev, __u8 *rdesc,
 		unsigned int *rsize)
 {
 	if (*rsize >= 56 && rdesc[54] == 0x25 && rdesc[55] == 0x01) {
-		hid_info(hdev, "Fixing up Ortek WKB-2000 report descriptor\n");
+		hid_info(hdev, "Fixing up Ortek PKB-1700/"
+			       "WKB-2000 report descriptor\n");
 		rdesc[55] = 0x92;
 	}
 	return rdesc;
-- 
1.7.1

