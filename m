Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752051Ab2JBL6Y (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Oct 2012 07:58:24 -0400
Received: from mail-wi0-f172.google.com ([209.85.212.172]:65370 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750910Ab2JBL6W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Oct 2012 07:58:22 -0400
From: Peter Senna Tschudin <peter.senna@gmail.com>
To: joe@perches.com
Cc: gregkh@linuxfoundation.org, davem@davemloft.net, arnd@arndb.de,
        elezegarcia@gmail.com, dan.carpenter@oracle.com, Julia.Lawall@lip6.fr,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org,
        Peter Senna Tschudin <peter.senna@gmail.com>
Subject: [PATCH RFC] MAINTAINERS: Add section for subsystem shortname
Date: Tue,  2 Oct 2012 13:57:04 +0200
Message-Id: <1349179024-5319-1-git-send-email-peter.senna@gmail.com>
X-Mailer: git-send-email 1.7.11.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The shortname for a subsystem, that is primarly used when sending patches over E-mail, is not stored anywhere in the source code. Actually one need to dig git log or mailing list archives. There is no standard, and the Maintainer choose how to short name his/her subsystem. MAINTAINERS file is the right place for storing this information.

U is the second letter of Subsystem.

This will also enable automatic tools like scripts/get_maintainer.pl to provide the correct short name for each filename in the Kernel source tree.

Signed-off-by: Peter Senna Tschudin <peter.senna@gmail.com>
---
 MAINTAINERS | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index 3386238..a1be2a1 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -104,6 +104,11 @@ Descriptions of section entries:
 	      matches patches or files that contain one or more of the words
 	      printk, pr_info or pr_err
 	   One regex pattern per line.  Multiple K: lines acceptable.
+	U: Subsystem short name. Used in the subject of patch sent by email to
+	   identify that subsystem. Short means up to 20 chars. Examples:
+	   U:	media
+	   U:	media/em28xx
+	   U:	SCSI
 
 Note: For the hard of thinking, this list is meant to remain in alphabetical
 order. If you could add yourselves to it in alphabetical order that would be
-- 
1.7.11.4

