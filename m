Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752831Ab1BWFoR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Feb 2011 00:44:17 -0500
Received: from mail.perches.com ([173.55.12.10]:3856 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752088Ab1BWFmc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Feb 2011 00:42:32 -0500
From: Joe Perches <joe@perches.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: [PATCH 11/18] MAINTAINERS: Remove IEEE1394 entry
Date: Tue, 22 Feb 2011 21:42:04 -0800
Message-Id: <521a178e6e611d444adf2b49c20ee5ba67e7c6b7.1298439175.git.joe@perches.com>
X-Mailer: git-send-email 1.7.4.rc3
In-Reply-To: <cover.1298439175.git.joe@perches.com>
References: <cover.1298439175.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

commit 66fa12c571d35e3cd62574c65f1785a460105397
("ieee1394: remove the old IEEE 1394 driver stack")

removed the code, remove the MAINTAINERS entry.

cc: Stefan Richter <stefanr@s5r6.in-berlin.de>

Signed-off-by: Joe Perches <joe@perches.com>
---
 MAINTAINERS |    9 ---------
 1 files changed, 0 insertions(+), 9 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 5e90ba7..bf8431a 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -3142,15 +3142,6 @@ L:	linux-pm@lists.linux-foundation.org
 S:	Supported
 F:	drivers/idle/i7300_idle.c
 
-IEEE 1394 SUBSYSTEM
-M:	Stefan Richter <stefanr@s5r6.in-berlin.de>
-L:	linux1394-devel@lists.sourceforge.net
-W:	http://ieee1394.wiki.kernel.org/
-T:	git git://git.kernel.org/pub/scm/linux/kernel/git/ieee1394/linux1394-2.6.git
-S:	Obsolete
-F:	Documentation/debugging-via-ohci1394.txt
-F:	drivers/ieee1394/
-
 IEEE 802.15.4 SUBSYSTEM
 M:	Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>
 M:	Sergey Lapin <slapin@ossfans.org>
-- 
1.7.4.rc3

