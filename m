Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752505Ab1LIIOK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Dec 2011 03:14:10 -0500
Received: from perches-mx.perches.com ([206.117.179.246]:33305 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752087Ab1LIIOG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Dec 2011 03:14:06 -0500
From: Joe Perches <joe@perches.com>
To: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 7/8] MAINTAINERS: Delete generic_serial section
Date: Fri,  9 Dec 2011 00:12:53 -0800
Message-Id: <a5e5dbfee6f7f5b767900bfb45c857c3e18aa37a.1323418149.git.joe@perches.com>
X-Mailer: git-send-email 1.7.8.111.gad25c.dirty
In-Reply-To: <cover.1323418149.git.joe@perches.com>
References: <cover.1323418149.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

commit bb2a97e9ccd ("Staging: delete generic_serial drivers")
removed the files, delete the section.

CC: Greg Kroah-Hartman <gregkh@suse.de>

Signed-off-by: Joe Perches <joe@perches.com>
---
 MAINTAINERS |    5 -----
 1 files changed, 0 insertions(+), 5 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index dd083d2..410f190 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -184,11 +184,6 @@ S:	Maintained
 F:	Documentation/filesystems/9p.txt
 F:	fs/9p/
 
-A2232 SERIAL BOARD DRIVER
-L:	linux-m68k@lists.linux-m68k.org
-S:	Orphan
-F:	drivers/staging/generic_serial/ser_a2232*
-
 AACRAID SCSI RAID DRIVER
 M:	Adaptec OEM Raid Solutions <aacraid@adaptec.com>
 L:	linux-scsi@vger.kernel.org
-- 
1.7.8.111.gad25c.dirty

