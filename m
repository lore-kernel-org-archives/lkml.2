Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755548Ab1DSVEZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Apr 2011 17:04:25 -0400
Received: from kroah.org ([198.145.64.141]:39362 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755501Ab1DSVEV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Apr 2011 17:04:21 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Tue Apr 19 14:03:23 2011
Message-Id: <20110419210323.233263955@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Tue, 19 Apr 2011 14:02:25 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Randy Dunlap <randy.dunlap@oracle.com>,
        Chris Wright <chrisw@sous-sol.org>
Subject: [09/26] MAINTAINERS: update STABLE BRANCH info
In-Reply-To: <20110419210333.GA17417@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.33-longterm review patch.  If anyone has any objections, please let us know.

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

--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -5131,7 +5131,6 @@ F:	arch/alpha/kernel/srm_env.c
 
 STABLE BRANCH
 M:	Greg Kroah-Hartman <greg@kroah.com>
-M:	Chris Wright <chrisw@sous-sol.org>
 L:	stable@kernel.org
 S:	Maintained
 


