Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759007Ab2FAIOI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jun 2012 04:14:08 -0400
Received: from mx1.redhat.com ([209.132.183.28]:58371 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758929Ab2FAINs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jun 2012 04:13:48 -0400
From: Karel Zak <kzak@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, torvalds@linux-foundation.org,
        Karel Zak <kzak@redhat.com>
Subject: [PATCH] MAINTAINERS: update util-linux info
Date: Fri,  1 Jun 2012 10:13:09 +0200
Message-Id: <1338538389-6334-1-git-send-email-kzak@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Karel Zak <kzak@redhat.com>
---
 MAINTAINERS |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 55f0fda..1879fdb 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -7291,11 +7291,11 @@ F:	Documentation/DocBook/uio-howto.tmpl
 F:	drivers/uio/
 F:	include/linux/uio*.h
 
-UTIL-LINUX-NG PACKAGE
+UTIL-LINUX PACKAGE
 M:	Karel Zak <kzak@redhat.com>
-L:	util-linux-ng@vger.kernel.org
-W:	http://kernel.org/~kzak/util-linux-ng/
-T:	git git://git.kernel.org/pub/scm/utils/util-linux-ng/util-linux-ng.git
+L:	util-linux@vger.kernel.org
+W:	http://en.wikipedia.org/wiki/Util-linux
+T:	git git://git.kernel.org/pub/scm/utils/util-linux/util-linux.git
 S:	Maintained
 
 UVESAFB DRIVER
-- 
1.7.7.6

