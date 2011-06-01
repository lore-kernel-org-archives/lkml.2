Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754677Ab1FAR70 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jun 2011 13:59:26 -0400
Received: from mail.perches.com ([173.55.12.10]:2384 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753993Ab1FAR7V (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jun 2011 13:59:21 -0400
From: Joe Perches <joe@perches.com>
To: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Cc: Jiri Kosina <jkosina@suse.cz>, Alan Ott <alan@signal11.us>
Subject: [PATCH 5/6] MAINTAINERS: Update USB HID/HIDBP DRIVERS pattern
Date: Wed,  1 Jun 2011 10:59:13 -0700
Message-Id: <7cf9cc531e6f1cfa04f9c0676ed4202b3ee7cb6d.1306950701.git.joe@perches.com>
X-Mailer: git-send-email 1.7.5.rc3.dirty
In-Reply-To: <cover.1306950701.git.joe@perches.com>
References: <cover.1306950701.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It was moved by commit 1a978c50c6cf
("HID: Move hiddev.txt to the new Documentation/hid directory")
so update the MAINTAINERS pattern too.

cc: Jiri Kosina <jkosina@suse.cz>
cc: Alan Ott <alan@signal11.us>
Signed-off-by: Joe Perches <joe@perches.com>
---
 MAINTAINERS |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 6f6a8ef..49d9fb1 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -6458,7 +6458,7 @@ M:	Jiri Kosina <jkosina@suse.cz>
 L:	linux-usb@vger.kernel.org
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/jikos/hid.git
 S:	Maintained
-F:	Documentation/usb/hiddev.txt
+F:	Documentation/hid/hiddev.txt
 F:	drivers/hid/usbhid/
 
 USB ISP116X DRIVER
-- 
1.7.5.rc3.dirty

