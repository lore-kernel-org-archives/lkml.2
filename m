Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932709Ab2KXA1g (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Nov 2012 19:27:36 -0500
Received: from smtp-02.mandic.com.br ([200.225.81.133]:43086 "EHLO
	smtp-02.mandic.com.br" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932669Ab2KXA1a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Nov 2012 19:27:30 -0500
From: Cesar Eduardo Barros <cesarb@cesarb.net>
To: linux-kernel@vger.kernel.org
Cc: Cesar Eduardo Barros <cesarb@cesarb.net>,
        Al Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.cz>,
        Andrew Morton <akpm@linux-foundation.org>,
        Andreas Dilger <adilger.kernel@dilger.ca>, linux-ext4@vger.kernel.or
Subject: [PATCH 10/24] MAINTAINERS: remove include/linux/ext3*
Date: Fri, 23 Nov 2012 22:26:34 -0200
Message-Id: <1353716808-16375-11-git-send-email-cesarb@cesarb.net>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1353716808-16375-1-git-send-email-cesarb@cesarb.net>
References: <1353716808-16375-1-git-send-email-cesarb@cesarb.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Moved to fs/ext3/ext3.h by commit 4613ad1 (ext3: move headers to
fs/ext3/).

Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Jan Kara <jack@suse.cz>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Andreas Dilger <adilger.kernel@dilger.ca>
Cc: linux-ext4@vger.kernel.or
Signed-off-by: Cesar Eduardo Barros <cesarb@cesarb.net>
---
 MAINTAINERS | 2 --
 1 file changed, 2 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 7f80f95..a67a67a 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -2932,7 +2932,6 @@ L:	linux-ext4@vger.kernel.org
 S:	Maintained
 F:	Documentation/filesystems/ext3.txt
 F:	fs/ext3/
-F:	include/linux/ext3*
 
 EXT4 FILE SYSTEM
 M:	"Theodore Ts'o" <tytso@mit.edu>
@@ -4228,7 +4227,6 @@ M:	Jan Kara <jack@suse.cz>
 L:	linux-ext4@vger.kernel.org
 S:	Maintained
 F:	fs/jbd/
-F:	include/linux/ext3_jbd.h
 F:	include/linux/jbd.h
 
 JOURNALLING LAYER FOR BLOCK DEVICES (JBD2)
-- 
1.7.11.7

