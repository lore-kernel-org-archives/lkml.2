Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754913Ab1DSUmt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Apr 2011 16:42:49 -0400
Received: from kroah.org ([198.145.64.141]:58936 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754297Ab1DSUmh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Apr 2011 16:42:37 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Tue Apr 19 13:41:17 2011
Message-Id: <20110419204117.667552213@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Tue, 19 Apr 2011 13:30:47 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Randy Dunlap <randy.dunlap@oracle.com>,
        Chris Wright <chrisw@sous-sol.org>
Subject: [09/28] MAINTAINERS: update STABLE BRANCH info
In-Reply-To: <20110419204122.GA13268@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let us know.

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
@@ -5010,7 +5010,6 @@ F:	arch/alpha/kernel/srm_env.c
 
 STABLE BRANCH
 M:	Greg Kroah-Hartman <greg@kroah.com>
-M:	Chris Wright <chrisw@sous-sol.org>
 L:	stable@kernel.org
 S:	Maintained
 


