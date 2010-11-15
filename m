Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932911Ab0KODF7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Nov 2010 22:05:59 -0500
Received: from mail.perches.com ([173.55.12.10]:1216 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932842Ab0KODFz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Nov 2010 22:05:55 -0500
From: Joe Perches <joe@perches.com>
To: Jiri Kosina <trivial@kernel.org>
Cc: David Brownell <dbrownell@users.sourceforge.net>,
        Greg Kroah-Hartman <gregkh@suse.de>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 30/44] drivers/usb/gadget: Remove unnecessary semicolons
Date: Sun, 14 Nov 2010 19:04:49 -0800
Message-Id: <cdc48b6ab9446585f304c801cca45a2a9d1e37ec.1289789605.git.joe@perches.com>
X-Mailer: git-send-email 1.7.3.1.g432b3.dirty
In-Reply-To: <cover.1289789604.git.joe@perches.com>
References: <cover.1289789604.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/usb/gadget/f_fs.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/usb/gadget/f_fs.c b/drivers/usb/gadget/f_fs.c
index 4a830df..38bb200 100644
--- a/drivers/usb/gadget/f_fs.c
+++ b/drivers/usb/gadget/f_fs.c
@@ -2096,7 +2096,7 @@ static int __ffs_func_bind_do_descs(enum ffs_entity_type type, u8 *valuep,
 		ep = usb_ep_autoconfig(func->gadget, ds);
 		if (unlikely(!ep))
 			return -ENOTSUPP;
-		ep->driver_data = func->eps + idx;;
+		ep->driver_data = func->eps + idx;
 
 		req = usb_ep_alloc_request(ep, GFP_KERNEL);
 		if (unlikely(!req))
-- 
1.7.3.1.g432b3.dirty

