Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933514Ab0GUE6t (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jul 2010 00:58:49 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:49232 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933467Ab0GUE50 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jul 2010 00:57:26 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=LxQMpUN6O29LTb2szfyCimuOyA5GnXcvoGC/r7NvmYy7ayvhcvrTtzcEoY+PxaAk0y
         Ck3FMOY+3yXdWHb7EqIrpBB+lsK622RF+kOdNOJk+KVlQA8OU5WslEqPj1ERObkQu+Rg
         edRD89F1qe9igtUTH+kj35aLnnvt8Xoj7f9RQ=
From: "Justin P. Mattock" <justinmattock@gmail.com>
To: trivial@kernel.org
Cc: linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Justin P. Mattock" <justinmattock@gmail.com>
Subject: [PATCH 105/105]Documentation/scsi/scsi-generic.txt update web address.
Date: Tue, 20 Jul 2010 21:56:55 -0700
Message-Id: <1279688215-29628-15-git-send-email-justinmattock@gmail.com>
X-Mailer: git-send-email 1.7.1.rc1.21.gf3bd6
In-Reply-To: <1279688215-29628-1-git-send-email-justinmattock@gmail.com>
References: <1279688215-29628-1-git-send-email-justinmattock@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The patch below updates web addresses that are broken.

Signed-off-by: Justin P. Mattock <justinmattock@gmail.com>

---
 Documentation/scsi/scsi-generic.txt |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/Documentation/scsi/scsi-generic.txt b/Documentation/scsi/scsi-generic.txt
index c38e2b3..b7acd41 100644
--- a/Documentation/scsi/scsi-generic.txt
+++ b/Documentation/scsi/scsi-generic.txt
@@ -34,11 +34,11 @@ http://www.tldp.org/HOWTO/SCSI-Generic-HOWTO
 This describes the sg version 3 driver found in the lk 2.4 series.
 The LDP renders documents in single and multiple page HTML, postscript
 and pdf. This document can also be found at:
-http://www.torque.net/sg/p/sg_v3_ho.html
+http://sg.danny.cz/sg/p/sg_v3_ho.html
 
 Documentation for the version 2 sg driver found in the lk 2.2 series can
-be found at http://www.torque.net/sg/p/scsi-generic.txt . A larger version
-is at:  http://www.torque.net/sg/p/scsi-generic_long.txt .
+be found at http://sg.danny.cz/sg/. A larger version
+is at: http://sg.danny.cz/sg/p/scsi-generic_long.txt.
 
 The original documentation for the sg driver (prior to lk 2.2.6) can be
 found at http://www.torque.net/sg/p/original/SCSI-Programming-HOWTO.txt
@@ -61,7 +61,7 @@ There are two packages of sg utilities:
   - sg_utils    for the sg version 2 (and original) driver found in lk 2.2
                 and earlier
 Both packages will work in the lk 2.4 series however sg3_utils offers more
-capabilities. They can be found at: http://www.torque.net/sg and 
+capabilities. They can be found at: http://sg.danny.cz/sg/sg3_utils.html and 
 freshmeat.net
 
 Another approach is to look at the applications that use the sg driver.
-- 
1.7.1.rc1.21.gf3bd6

