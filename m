Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753905Ab2A3G0M (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jan 2012 01:26:12 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:37707 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752584Ab2A3G0K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jan 2012 01:26:10 -0500
From: Keng-Yu Lin <kengyu@canonical.com>
To: Jiri Kosina <jkosina@suse.cz>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: sylee@canonical.com, Keng-Yu Lin <kengyu@canonical.com>
Subject: [PATCH v2] HID: add more hotkeys in Asus AIO keyboards
Date: Mon, 30 Jan 2012 14:25:45 +0800
Message-Id: <1327904745-4592-1-git-send-email-kengyu@canonical.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1326957135-6958-1-git-send-email-kengyu@canonical.com>
References: <1326957135-6958-1-git-send-email-kengyu@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add support for the camera key. The hotkey for
Asus S.H.E(Super Hybrid Engine) mode is mapped to KEY_KEY_PROG1
just for notifying the userspace.

Signed-off-by: Keng-Yu Lin <kengyu@canonical.com>
---
 drivers/hid/hid-chicony.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

V2: fix typo KEY_KEY_PROG1

diff --git a/drivers/hid/hid-chicony.c b/drivers/hid/hid-chicony.c
index 4162505..b99af34 100644
--- a/drivers/hid/hid-chicony.c
+++ b/drivers/hid/hid-chicony.c
@@ -49,6 +49,8 @@ static int ch_input_mapping(struct hid_device *hdev, struct hid_input *hi,
 	case 0x00f2: ch_map_key_clear(KEY_BRIGHTNESSDOWN);	break;
 	case 0x00f3: ch_map_key_clear(KEY_BRIGHTNESSUP);	break;
 	case 0x00f4: ch_map_key_clear(KEY_DISPLAY_OFF);	break;
+	case 0x00f7: ch_map_key_clear(KEY_CAMERA);	break;
+	case 0x00f8: ch_map_key_clear(KEY_PROG1);	break;
 	default:
 		return 0;
 	}
-- 
1.7.5.4

