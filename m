Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932554Ab1DYUbR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Apr 2011 16:31:17 -0400
Received: from 1wt.eu ([62.212.114.60]:34601 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932458Ab1DYUZ1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Apr 2011 16:25:27 -0400
Message-Id: <20110425200240.208374056@pcw.home.local>
User-Agent: quilt/0.48-1
Date: Mon, 25 Apr 2011 22:05:18 +0200
From: Willy Tarreau <w@1wt.eu>
To: linux-kernel@vger.kernel.org, stable@kernel.org, stable-review@kernel.org
Cc: Randy Dunlap <randy.dunlap@oracle.com>, Chris Wright <chrisw@sous-sol.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 166/173] MAINTAINERS: update STABLE BRANCH info
In-Reply-To: <46075c3a3ef08be6d70339617d6afc98@local>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27.59-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Randy Dunlap <randy.dunlap@oracle.com>

commit d00ebeac5f24f290636f7a895dafc124b2930a08 upstream.

Drop Chris Wright from STABLE maintainers.  He hasn't done STABLE release
work for quite some time.

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Acked-by: Chris Wright <chrisw@sous-sol.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 MAINTAINERS |    1 -
 1 file changed, 1 deletion(-)

Index: longterm-2.6.27/MAINTAINERS
===================================================================
--- longterm-2.6.27.orig/MAINTAINERS	2011-01-23 10:51:58.000000000 +0100
+++ longterm-2.6.27/MAINTAINERS	2011-04-25 17:29:31.216280205 +0200
@@ -3857,8 +3857,6 @@
 STABLE BRANCH:
 P:	Greg Kroah-Hartman
 M:	greg@kroah.com
-P:	Chris Wright
-M:	chrisw@sous-sol.org
 L:	stable@kernel.org
 S:	Maintained
 


