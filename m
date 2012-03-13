Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758681Ab2CMBAq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2012 21:00:46 -0400
Received: from mail.windriver.com ([147.11.1.11]:47665 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758434Ab2CMAWY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2012 20:22:24 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: stable@kernel.org, linux-kernel@vger.kernel.org
Cc: stable-review@kernel.org, Randy Dunlap <randy.dunlap@oracle.com>,
        Greg KH <gregkh@suse.de>, Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [34-longterm 063/196] MAINTAINERS: update STABLE BRANCH info
Date: Mon, 12 Mar 2012 20:19:36 -0400
Message-Id: <1331598109-31424-18-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.9.3
In-Reply-To: <1331598109-31424-1-git-send-email-paul.gortmaker@windriver.com>
References: <1331597724-31358-1-git-send-email-paul.gortmaker@windriver.com>
 <1331598109-31424-1-git-send-email-paul.gortmaker@windriver.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>

                   -------------------
    This is a commit scheduled for the next v2.6.34 longterm release.
    If you see a problem with using this for longterm, please comment.
                   -------------------

commit d00ebeac5f24f290636f7a895dafc124b2930a08 upstream.

Drop Chris Wright from STABLE maintainers.  He hasn't done STABLE release
work for quite some time.

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Acked-by: Chris Wright <chrisw@sous-sol.org>
Cc: Greg KH <gregkh@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 MAINTAINERS |    1 -
 1 file changed, 1 deletion(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 502b380..52bec00 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -5306,7 +5306,6 @@ F:	arch/alpha/kernel/srm_env.c
 
 STABLE BRANCH
 M:	Greg Kroah-Hartman <greg@kroah.com>
-M:	Chris Wright <chrisw@sous-sol.org>
 L:	stable@kernel.org
 S:	Maintained
 
-- 
1.7.9.3

