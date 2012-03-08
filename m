Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752599Ab2CHE7l (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2012 23:59:41 -0500
Received: from mail.free-electrons.com ([88.190.12.23]:49419 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750917Ab2CHE7h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2012 23:59:37 -0500
From: Michael Opdenacker <michael.opdenacker@free-electrons.com>
To: rdunlap@xenotime.net, trivial@kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: Michael Opdenacker <michael.opdenacker@free-electrons.com>
Subject: [PATCH RESEND] [trivial] Documentation: broken URL in filesystems
Date: Thu,  8 Mar 2012 05:59:24 +0100
Message-Id: <1331182764-32564-1-git-send-email-michael.opdenacker@free-electrons.com>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix broken link in Documentation/filesystem, replacing
ftp://ftp.uk.linux.org/pub/linux/sct/fs/jfs/journal-design.ps.gz
by a URL on http://kernel.org

Thanks to Randy Dunlap for his advise on the best replacement
URL to use.

Signed-off-by: Michael Opdenacker <michael.opdenacker@free-electrons.com>
---
 Documentation/DocBook/filesystems.tmpl |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/Documentation/DocBook/filesystems.tmpl b/Documentation/DocBook/filesystems.tmpl
index f51f285..3fca32c 100644
--- a/Documentation/DocBook/filesystems.tmpl
+++ b/Documentation/DocBook/filesystems.tmpl
@@ -387,7 +387,7 @@ an example.
      <title>See also</title>
 	<para>
 	  <citation>
-	   <ulink url="ftp://ftp.uk.linux.org/pub/linux/sct/fs/jfs/journal-design.ps.gz">
+	   <ulink url="http://kernel.org/pub/linux/kernel/people/sct/ext3/journal-design.ps.gz">
 	   	Journaling the Linux ext2fs Filesystem, LinuxExpo 98, Stephen Tweedie
 	   </ulink>
 	  </citation>
-- 
1.7.4.1

