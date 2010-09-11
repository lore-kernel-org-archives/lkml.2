Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755104Ab0IKE1s (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Sep 2010 00:27:48 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:55211 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754542Ab0IKE1q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Sep 2010 00:27:46 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=AoTfbOQjpgzHtzQlX//sSFmrsLDHG8xKskz+Gp/RMyArSVUTvSHH5T9NzpOwd8LbjV
         TTsxc93BDXbhAor+McI/QtCMa8/CI4yQ2ZoKj3lwWajvcgcWtvg8xrBHlKsBEWv5d60s
         xAFYr5EHDt4m9QnHMuAlW98xSxl/w5n+T1XKs=
From: "Justin P. Mattock" <justinmattock@gmail.com>
To: trivial@kernel.org
Cc: linux-kernel@vger.kernel.org,
        "Justin P. Mattock" <justinmattock@gmail.com>
Subject: [PATCH 09/10]include/scsi/sg.h Update broken web addresses.
Date: Fri, 10 Sep 2010 21:27:56 -0700
Message-Id: <1284179277-7788-9-git-send-email-justinmattock@gmail.com>
X-Mailer: git-send-email 1.7.2.1
In-Reply-To: <1284179277-7788-1-git-send-email-justinmattock@gmail.com>
References: <1284179277-7788-1-git-send-email-justinmattock@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Below you will find an Update to a broken web address.
Please let me know if this needs to be changed.

Signed-off-by: Justin P. Mattock <justinmattock@gmail.com>

---
 include/scsi/sg.h |   10 +++++-----
 1 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/include/scsi/sg.h b/include/scsi/sg.h
index a9f3c6f..19d4d85 100644
--- a/include/scsi/sg.h
+++ b/include/scsi/sg.h
@@ -16,7 +16,7 @@ Version 2 and 3 extensions to driver:
     Version: 3.5.34 (20060920)
     This version is for 2.6 series kernels.
 
-    For a full changelog see http://www.torque.net/sg
+    For a full changelog see http://web.archive.org/web/*/http://www.torque.net/sg 
 
 Map of SG verions to the Linux kernels in which they appear:
        ----------        ----------------------------------
@@ -52,17 +52,17 @@ Major new features in SG 3.x driver (cf SG 2.x drivers)
  Documentation
  =============
  A web site for the SG device driver can be found at:
-	http://www.torque.net/sg  [alternatively check the MAINTAINERS file]
+	http://web.archive.org/web/*/http://www.torque.net/sg	
  The documentation for the sg version 3 driver can be found at:
- 	http://www.torque.net/sg/p/sg_v3_ho.html
+ 	http://web.archive.org/web/*/http://www.torque.net/sg/p/sg_v3_ho.html
  This is a rendering from DocBook source [change the extension to "sgml"
  or "xml"]. There are renderings in "ps", "pdf", "rtf" and "txt" (soon).
  The SG_IO ioctl is now found in other parts kernel (e.g. the block layer).
  For more information see http://www.torque.net/sg/sg_io.html
 
  The older, version 2 documents discuss the original sg interface in detail:
-	http://www.torque.net/sg/p/scsi-generic.txt
-	http://www.torque.net/sg/p/scsi-generic_long.txt
+	http://web.archive.org/web/*/http://www.torque.net/sg/p/scsi-generic.txt
+	http://web.archive.org/web/*/http://www.torque.net/sg/p/scsi-generic_long.txt
  Also available: <kernel_source>/Documentation/scsi/scsi-generic.txt
 
  Utility and test programs are available at the sg web site. They are 
-- 
1.7.2.1

