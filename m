Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757558Ab0JZCod (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Oct 2010 22:44:33 -0400
Received: from mail.perches.com ([173.55.12.10]:3546 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756432Ab0JZCoc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Oct 2010 22:44:32 -0400
From: Joe Perches <joe@perches.com>
To: Jiri Kosina <trivial@kernel.org>
Cc: Jiri Kosina <jkosina@suse.cz>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 03/10] drivers/hid/hid-input.c: Remove KERN_DEBUG from dbg_hid use
Date: Mon, 25 Oct 2010 19:44:21 -0700
Message-Id: <b63d550b69fd940f0b03fd7dda8396acb2223801.1288059486.git.joe@perches.com>
X-Mailer: git-send-email 1.7.3.2.90.gd4c43
In-Reply-To: <cover.1288059486.git.joe@perches.com>
References: <cover.1288059486.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/hid/hid-input.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/hid/hid-input.c b/drivers/hid/hid-input.c
index bb0b365..3a1517a 100644
--- a/drivers/hid/hid-input.c
+++ b/drivers/hid/hid-input.c
@@ -174,7 +174,7 @@ static int hidinput_setkeycode(struct input_dev *dev,
 
 		clear_bit(*old_keycode, dev->keybit);
 		set_bit(usage->code, dev->keybit);
-		dbg_hid(KERN_DEBUG "Assigned keycode %d to HID usage code %x\n",
+		dbg_hid("Assigned keycode %d to HID usage code %x\n",
 			usage->code, usage->hid);
 
 		/*
-- 
1.7.3.dirty

