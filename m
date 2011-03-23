Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932184Ab1CWRtQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Mar 2011 13:49:16 -0400
Received: from mail.perches.com ([173.55.12.10]:4239 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754400Ab1CWRtO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Mar 2011 13:49:14 -0400
Subject: [PATCH] MAINTAINERS: Add "K:" pattern for TRIVIAL PATCHES
From: Joe Perches <joe@perches.com>
To: Jiri Kosina <trivial@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        "L. Alberto" =?ISO-8859-1?Q?Gim=E9nez?= <agimenez@sysvalve.es>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 23 Mar 2011 10:49:13 -0700
Message-ID: <1300902553.24885.110.camel@Joe-Laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since scripts/get_maintainer.pl was updated to search
content before the patch by commit 7764dcb
("get_maintainer.pl: allow "K:" pattern tests to match non-patch text")
perhaps this might direct a few more patches the right place.

Original-patch-by: L. Alberto Giménez <agimenez@sysvalve.es>
Signed-off-by: Joe Perches <joe@perches.com>

---

 MAINTAINERS |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index e11953d..c0c4d23 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -6209,6 +6209,7 @@ TRIVIAL PATCHES
 M:	Jiri Kosina <trivial@kernel.org>
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/jikos/trivial.git
 S:	Maintained
+K:	^Subject:.*(?i)trivial
 
 TTY LAYER
 M:	Greg Kroah-Hartman <gregkh@suse.de>


