Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754805Ab0JHACH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Oct 2010 20:02:07 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:55788 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751680Ab0JHACG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Oct 2010 20:02:06 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=q2IwVSrZUxyJPPTuGeOFf0rCzRq641Lma84KaEwBV8yFAUPOmXrXginBYLBHdQJW9i
         W+WFavc+qyJH9aIwWZORYamv9SB7pZ5Dcwbiq2kT37oTM6EDQkGN2XhKpg54mBENRgP4
         9himL/gbsR/I+QjC9z5nuoeIHH82L+Gy33ERU=
From: Tracey Dent <tdent48227@gmail.com>
To: greg@kroah.com
Cc: linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org,
        sam@ravnborg.org, linux-kbuild@vger.kernel.org,
        Tracey Dent <tdent48227@gmail.com>
Subject: [PATCH 04/33] Staging: comedi: Makefile: replace the use of <module>-objs with <module>-y
Date: Thu,  7 Oct 2010 20:01:24 -0400
Message-Id: <1286496113-11897-4-git-send-email-tdent48227@gmail.com>
X-Mailer: git-send-email 1.7.3.1.50.g1e633
In-Reply-To: <1286496113-11897-1-git-send-email-tdent48227@gmail.com>
References: <1286496113-11897-1-git-send-email-tdent48227@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Changed <module>-objs to <module>-y in Makefile.

Signed-off-by: Tracey Dent <tdent48227@gmail.com>
---
 drivers/staging/comedi/Makefile |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/staging/comedi/Makefile b/drivers/staging/comedi/Makefile
index 20afea3..8dbd306 100644
--- a/drivers/staging/comedi/Makefile
+++ b/drivers/staging/comedi/Makefile
@@ -3,7 +3,7 @@ obj-$(CONFIG_COMEDI) += comedi.o
 obj-$(CONFIG_COMEDI)	+= kcomedilib/
 obj-$(CONFIG_COMEDI)	+= drivers/
 
-comedi-objs :=		\
+comedi-y :=		\
 	comedi_fops.o	\
 	proc.o		\
 	range.o		\
-- 
1.7.3.1.50.g1e633

