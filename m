Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756196Ab1GEQme (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jul 2011 12:42:34 -0400
Received: from mail.perches.com ([173.55.12.10]:3568 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755988Ab1GEQmc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jul 2011 12:42:32 -0400
From: Joe Perches <joe@perches.com>
To: Greg KH <gregkh@suse.de>, linux-kernel@vger.kernel.org
Cc: devel@driverdev.osuosl.org, Hans Verkuil <hverkuil@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: [PATCH 14/14] MAINTAINERS: Remove se401 entry
Date: Tue,  5 Jul 2011 09:42:14 -0700
Message-Id: <a593a52a85222ab16c3e04b78241096bbfd85b09.1309883752.git.joe@perches.com>
X-Mailer: git-send-email 1.7.6.131.g99019
In-Reply-To: <cover.1309883752.git.joe@perches.com>
References: <20110704153435.GA17475@suse.de> <cover.1309883752.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit b287db119edb ("se401: remove last V4L1 driver")
removed the files, remove the entry.

cc: Hans Verkuil <hverkuil@xs4all.nl>
cc: Mauro Carvalho Chehab <mchehab@redhat.com>
Signed-off-by: Joe Perches <joe@perches.com>
---
 MAINTAINERS |    7 -------
 1 files changed, 0 insertions(+), 7 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index bd46c4f..7c11854 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -6638,13 +6638,6 @@ W:	http://pegasus2.sourceforge.net/
 S:	Maintained
 F:	drivers/net/usb/rtl8150.c
 
-USB SE401 DRIVER
-L:	linux-usb@vger.kernel.org
-W:	http://www.chello.nl/~j.vreeken/se401/
-S:	Orphan
-F:	Documentation/video4linux/se401.txt
-F:	drivers/staging/se401/
-
 USB SERIAL BELKIN F5U103 DRIVER
 M:	William Greathouse <wgreathouse@smva.com>
 L:	linux-usb@vger.kernel.org
-- 
1.7.6.131.g99019

