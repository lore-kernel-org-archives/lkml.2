Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759611Ab2DJW3i (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Apr 2012 18:29:38 -0400
Received: from mail-pz0-f52.google.com ([209.85.210.52]:45831 "EHLO
	mail-pz0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759595Ab2DJW3f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Apr 2012 18:29:35 -0400
From: Josenivaldo Benito Junior <jrbenito@benito.qsl.br>
To: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jiri Kosina <jkosina@suse.cz>
Cc: Franco Catrin <fcatrin@gmail.com>,
        Josenivaldo Benito Junior <jrbenito@benito.qsl.br>
Subject: [PATCH 3/3] HID: hid-aureal: Removing excessive dmesg information
Date: Tue, 10 Apr 2012 19:29:06 -0300
Message-Id: <1334096946-18788-4-git-send-email-jrbenito@benito.qsl.br>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1334096946-18788-1-git-send-email-jrbenito@benito.qsl.br>
References: <1334096946-18788-1-git-send-email-jrbenito@benito.qsl.br>
In-Reply-To: <alpine.LNX.2.00.1204090207090.24006@pobox.suse.cz>
References: <alpine.LNX.2.00.1204090207090.24006@pobox.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Avoid excessive dmesg verbosity as per Jiri´s suggestion.

Signed-off-by: Josenivaldo Benito Junior <jrbenito@benito.qsl.br>
---
 drivers/hid/hid-aureal.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/hid/hid-aureal.c b/drivers/hid/hid-aureal.c
index 9fb676b..ba64b04 100644
--- a/drivers/hid/hid-aureal.c
+++ b/drivers/hid/hid-aureal.c
@@ -22,7 +22,7 @@ static __u8 *aureal_report_fixup(struct hid_device *hdev, __u8 *rdesc,
 		unsigned int *rsize)
 {
 	if (*rsize >= 54 && rdesc[52] == 0x25 && rdesc[53] == 0x01) {
-		dev_info(&hdev->dev, "fixing Aureal Cy se W-01RN USB_V3.1 report descriptor. Keyboard Logical Maximum = 101\n");
+		dev_info(&hdev->dev, "fixing Aureal Cy se W-01RN USB_V3.1 report descriptor.\n");
 		rdesc[53] = 0x65;
 	} return rdesc;
 }
-- 
1.7.5.4

