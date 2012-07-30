Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755007Ab2G3Tkn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jul 2012 15:40:43 -0400
Received: from smtprelay.restena.lu ([158.64.1.62]:53160 "EHLO
	smtprelay.restena.lu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754438Ab2G3Tkk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jul 2012 15:40:40 -0400
Date: Mon, 30 Jul 2012 21:39:03 +0200
From: Bruno =?UTF-8?B?UHLDqW1vbnQ=?= <bonbons@linux-vserver.org>
To: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jiri Kosina <jkosina@suse.cz>
Cc: Jaya Kumar <jayalk@intworks.biz>, linux-fbdev@vger.kernel.org
Subject: [PATCH 7/7] HID: picoLCD: add myself to MAINTAINERS
Message-ID: <20120730213903.30c6ba0b@neptune.home>
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.10; i686-pc-linux-gnu)
References: <20120730213656.0a9f6d30@neptune.home>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Bruno Prémont <bonbons@linux-vserver.org>
---
 MAINTAINERS |    6 ++++++
 1 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index fe643e7..0042553 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -5283,6 +5283,12 @@ L:	linux-mtd@lists.infradead.org
 S:	Maintained
 F:	drivers/mtd/devices/phram.c
 
+PICOLCD HID DRIVER
+M:	Bruno Prémont <bonbons@linux-vserver.org>
+L:	linux-input@vger.kernel.org
+S:	Maintained
+F:	drivers/hid/hid-picolcd*
+
 PICOXCELL SUPPORT
 M:	Jamie Iles <jamie@jamieiles.com>
 L:	linux-arm-kernel@lists.infradead.org (moderated for non-subscribers)
-- 
1.7.8.6

