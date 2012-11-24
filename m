Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932908Ab2KXA2X (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Nov 2012 19:28:23 -0500
Received: from smtp-02.mandic.com.br ([200.225.81.133]:56676 "EHLO
	smtp-02.mandic.com.br" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932871Ab2KXA2I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Nov 2012 19:28:08 -0500
From: Cesar Eduardo Barros <cesarb@cesarb.net>
To: linux-kernel@vger.kernel.org
Cc: Cesar Eduardo Barros <cesarb@cesarb.net>,
        Pete Zaitcev <zaitcev@redhat.com>, linux-usb@vger.kernel.org
Subject: [PATCH 24/24] MAINTAINERS: remove drivers/block/ub.c
Date: Fri, 23 Nov 2012 22:26:48 -0200
Message-Id: <1353716808-16375-25-git-send-email-cesarb@cesarb.net>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1353716808-16375-1-git-send-email-cesarb@cesarb.net>
References: <1353716808-16375-1-git-send-email-cesarb@cesarb.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This driver was removed by commit 68a5059 (block: remove the deprecated
ub driver).

Cc: Pete Zaitcev <zaitcev@redhat.com>
Cc: linux-usb@vger.kernel.org
Signed-off-by: Cesar Eduardo Barros <cesarb@cesarb.net>
---
 MAINTAINERS | 6 ------
 1 file changed, 6 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index e8990d2..f4934bd 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -7624,12 +7624,6 @@ L:	linux-scsi@vger.kernel.org
 S:	Supported
 F:	drivers/usb/storage/uas.c
 
-USB BLOCK DRIVER (UB ub)
-M:	Pete Zaitcev <zaitcev@redhat.com>
-L:	linux-usb@vger.kernel.org
-S:	Supported
-F:	drivers/block/ub.c
-
 USB CDC ETHERNET DRIVER
 M:	Oliver Neukum <oliver@neukum.org>
 L:	linux-usb@vger.kernel.org
-- 
1.7.11.7

