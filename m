Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933698Ab0GUFDj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jul 2010 01:03:39 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:39306 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933523Ab0GUE6y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jul 2010 00:58:54 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=GJn+4h/UpglSkfC/NWrqav+aF94vY9IHlzhkXoqdpFdZVO3y97vpw8kMMjt9pttd1d
         1wZptaMC/he19DZjRR+bwgpdYChAmJ1nrWIgDmaraq4+Q/ReLrZ7V3oCMj3NyzeSC4H/
         HkJjZoOV6vB1u4R/SD3bJOefzfWWM18/mM+nM=
From: "Justin P. Mattock" <justinmattock@gmail.com>
To: trivial@kernel.org
Cc: linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Justin P. Mattock" <justinmattock@gmail.com>
Subject: [PATCH 107/107]Documentation/scsi/ibmmca.txt update web address.
Date: Tue, 20 Jul 2010 21:57:46 -0700
Message-Id: <1279688279-29683-2-git-send-email-justinmattock@gmail.com>
X-Mailer: git-send-email 1.7.1.rc1.21.gf3bd6
In-Reply-To: <1279688279-29683-1-git-send-email-justinmattock@gmail.com>
References: <1279688279-29683-1-git-send-email-justinmattock@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The patch below updates a broken web address.

Signed-off-by: Justin P. Mattock <justinmattock@gmail.com>

---
 Documentation/scsi/ibmmca.txt |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/Documentation/scsi/ibmmca.txt b/Documentation/scsi/ibmmca.txt
index 3920f28..45d61ad 100644
--- a/Documentation/scsi/ibmmca.txt
+++ b/Documentation/scsi/ibmmca.txt
@@ -1109,7 +1109,7 @@
      Q: Where can I find the latest info about this driver?
      A: See the file MAINTAINERS for the current WWW-address, which offers
         updates, info and Q/A lists. At this file's origin, the webaddress
-	was: http://www.uni-mainz.de/~langm000/linux.html
+	was: http://www.staff.uni-mainz.de/mlang/linux.html
      Q: My SCSI-adapter is not recognized by the driver, what can I do?
      A: Just force it to be recognized by kernel parameters. See section 5.1.
         If this really happens, do also send e-mail to the maintainer, as
-- 
1.7.1.rc1.21.gf3bd6

