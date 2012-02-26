Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751795Ab2BZPaU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Feb 2012 10:30:20 -0500
Received: from mx1.redhat.com ([209.132.183.28]:6658 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751411Ab2BZP3o (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Feb 2012 10:29:44 -0500
Date: Sun, 26 Feb 2012 16:29:39 +0100
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Ian Kent <raven@themaw.net>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] autofs: MAINTAINERS: change mailing list
Message-ID: <20120226152938.GB14324@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From 716305073524cb03760d83374661d9d1f1a20c30 Mon Sep 17 00:00:00 2001
From: Stanislaw Gruszka <sgruszka@redhat.com>
Date: Sun, 26 Feb 2012 16:25:29 +0100
Subject: [PATCH] autofs: MAINTAINERS: change mailing list

autofs@linux.kernel.org does not work, replace it by linux-fsdevel

Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
---
 MAINTAINERS |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 75a9a5f..0d6159e 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -3780,7 +3780,7 @@ F:	Documentation/kdump/
 
 KERNEL AUTOMOUNTER v4 (AUTOFS4)
 M:	Ian Kent <raven@themaw.net>
-L:	autofs@linux.kernel.org
+L:	linux-fsdevel@vger.kernel.org
 S:	Maintained
 F:	fs/autofs4/
 
-- 
1.7.1

