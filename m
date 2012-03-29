Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932551Ab2C2Jxg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Mar 2012 05:53:36 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:57143 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752734Ab2C2Jx2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Mar 2012 05:53:28 -0400
Date: Thu, 29 Mar 2012 12:53:22 +0300
From: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
To: joeyli <jlee@suse.com>
Cc: Joey Lee <jlee@novell.com>, Matthew Garrett <mjg@redhat.com>,
        platform-driver-x86@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] acer-wmi: add Aspire 5741G touchpad toggle key
Message-ID: <20120329095322.GA3576@swordfish.minsk.epam.com>
References: <20120306123355.GA3904@swordfish.minsk.epam.com>
 <1331266669.10557.107.camel@linux-s257.site>
 <20120312101956.GA8522@swordfish.minsk.epam.com>
 <1331607878.10557.145.camel@linux-s257.site>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1331607878.10557.145.camel@linux-s257.site>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

acer-wmi: add Aspire 5741G touchpad toggle key

add Aspire 5741G KEY_TOUCHPAD_TOGGLE to wmi keymap.

Signed-off-by: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>

---

 drivers/platform/x86/acer-wmi.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/platform/x86/acer-wmi.c b/drivers/platform/x86/acer-wmi.c
index c1a3fd8..94a6747 100644
--- a/drivers/platform/x86/acer-wmi.c
+++ b/drivers/platform/x86/acer-wmi.c
@@ -125,6 +125,7 @@ static const struct key_entry acer_wmi_keymap[] = {
 	{KE_KEY, 0x64, {KEY_SWITCHVIDEOMODE} },	/* Display Switch */
 	{KE_IGNORE, 0x81, {KEY_SLEEP} },
 	{KE_KEY, 0x82, {KEY_TOUCHPAD_TOGGLE} },	/* Touch Pad On/Off */
+	{KE_KEY, 0x85, {KEY_TOUCHPAD_TOGGLE} },
 	{KE_IGNORE, 0x83, {KEY_TOUCHPAD_TOGGLE} },
 	{KE_END, 0}
 };
