Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752942Ab2KZShv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2012 13:37:51 -0500
Received: from mail-ee0-f46.google.com ([74.125.83.46]:43378 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751177Ab2KZShu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2012 13:37:50 -0500
Date: Mon, 26 Nov 2012 21:35:02 +0300
From: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
To: Joey Lee <jlee@novell.com>
Cc: Matthew Garrett <mjg@redhat.com>, platform-driver-x86@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] acer-wmi: add Aspire 5741G touchpad toggle key
Message-ID: <20121126183502.GA2749@swordfish>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add Aspire 5741G KEY_TOUCHPAD_TOGGLE to wmi keymap, preventing
"acer_wmi: Unknown key number - 0x85" error.


Signed-off-by: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>

---

 drivers/platform/x86/acer-wmi.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/platform/x86/acer-wmi.c b/drivers/platform/x86/acer-wmi.c
index 934d861..9a6ee9a 100644
--- a/drivers/platform/x86/acer-wmi.c
+++ b/drivers/platform/x86/acer-wmi.c
@@ -127,6 +127,7 @@ static const struct key_entry acer_wmi_keymap[] = {
 	{KE_IGNORE, 0x81, {KEY_SLEEP} },
 	{KE_KEY, 0x82, {KEY_TOUCHPAD_TOGGLE} },	/* Touch Pad On/Off */
 	{KE_IGNORE, 0x83, {KEY_TOUCHPAD_TOGGLE} },
+	{KE_KEY, 0x85, {KEY_TOUCHPAD_TOGGLE} },
 	{KE_END, 0}
 };

