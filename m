Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754647Ab2BMJKs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Feb 2012 04:10:48 -0500
Received: from mail.free-electrons.com ([88.190.12.23]:35732 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754329Ab2BMJKq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Feb 2012 04:10:46 -0500
From: Michael Opdenacker <michael.opdenacker@free-electrons.com>
To: rdunlap@xenotime.net, trivial@kernel.org, lucas.demarchi@profusion.mobi,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Michael Opdenacker <michael.opdenacker@free-electrons.com>
Subject: [PATCH 1/2] [trivial] Documentation: broken URL in filesystems
Date: Mon, 13 Feb 2012 10:09:51 +0100
Message-Id: <1329124192-27461-2-git-send-email-michael.opdenacker@free-electrons.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1329124192-27461-1-git-send-email-michael.opdenacker@free-electrons.com>
References: <1329124192-27461-1-git-send-email-michael.opdenacker@free-electrons.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix broken link in Documentation/filesystem, replacing
ftp://ftp.uk.linux.org/pub/linux/sct/fs/jfs/journal-design.ps.gz
by a URL on http://boot.kernel.org

Signed-off-by: Michael Opdenacker <michael.opdenacker@free-electrons.com>
---
 Documentation/DocBook/filesystems.tmpl |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/Documentation/DocBook/filesystems.tmpl b/Documentation/DocBook/filesystems.tmpl
index f51f285..2b3de6d 100644
--- a/Documentation/DocBook/filesystems.tmpl
+++ b/Documentation/DocBook/filesystems.tmpl
@@ -387,7 +387,7 @@ an example.
      <title>See also</title>
 	<para>
 	  <citation>
-	   <ulink url="ftp://ftp.uk.linux.org/pub/linux/sct/fs/jfs/journal-design.ps.gz">
+	   <ulink url="http://boot.kernel.org/pub/linux/kernel/people/sct/ext3/journal-design.ps.gz">
 	   	Journaling the Linux ext2fs Filesystem, LinuxExpo 98, Stephen Tweedie
 	   </ulink>
 	  </citation>
-- 
1.7.4.1

