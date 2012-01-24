Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756294Ab2AXCnV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jan 2012 21:43:21 -0500
Received: from cantor2.suse.de ([195.135.220.15]:50030 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756115Ab2AXCnP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jan 2012 21:43:15 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Mon Jan 23 18:39:26 2012
Message-Id: <20120124023926.313777126@clark.kroah.org>
User-Agent: quilt/0.50-11.1
Date: Mon, 23 Jan 2012 18:34:07 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Chase Douglas <chase.douglas@canonical.com>,
        Jiri Kosina <jkosina@suse.cz>
Subject: [027/129] HID: bump maximum global item tag report size to 96 bytes
In-Reply-To: <20120124024041.GA18422@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------
Content-Length: 848
Lines: 28

From: Chase Douglas <chase.douglas@canonical.com>

commit e46e927b9b7e8d95526e69322855243882b7e1a3 upstream.

This allows the latest N-Trig devices to function properly.

BugLink: https://bugs.launchpad.net/bugs/724831

Signed-off-by: Chase Douglas <chase.douglas@canonical.com>
Signed-off-by: Jiri Kosina <jkosina@suse.cz>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/hid/hid-core.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/hid/hid-core.c
+++ b/drivers/hid/hid-core.c
@@ -362,7 +362,7 @@ static int hid_parser_global(struct hid_
 
 	case HID_GLOBAL_ITEM_TAG_REPORT_SIZE:
 		parser->global.report_size = item_udata(item);
-		if (parser->global.report_size > 32) {
+		if (parser->global.report_size > 96) {
 			dbg_hid("invalid report_size %d\n",
 					parser->global.report_size);
 			return -1;


