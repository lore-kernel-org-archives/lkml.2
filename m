Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752798Ab1BWFnA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Feb 2011 00:43:00 -0500
Received: from mail.perches.com ([173.55.12.10]:3855 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751157Ab1BWFmd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Feb 2011 00:42:33 -0500
From: Joe Perches <joe@perches.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org,
        Allan Stephens <allan.stephens@windriver.com>
Subject: [PATCH 16/18] MAINTAINERS: Update TIPC patterns
Date: Tue, 22 Feb 2011 21:42:09 -0800
Message-Id: <7ec32038c3806031b05bd4eb5ff603893c9b6aca.1298439175.git.joe@perches.com>
X-Mailer: git-send-email 1.7.4.rc3
In-Reply-To: <cover.1298439175.git.joe@perches.com>
References: <cover.1298439175.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

commit d265fef6ddf9042195aae551e1fde211c2a1588b
("tipc: Remove obsolete native API files and exports")
removed the files, remove the patterns.

cc: Allan Stephens <allan.stephens@windriver.com>

Signed-off-by: Joe Perches <joe@perches.com>
---
 MAINTAINERS |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 744fd30..cdab39b 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -6074,7 +6074,6 @@ W:	http://tipc.cslab.ericsson.net/
 T:	git git://tipc.cslab.ericsson.net/pub/git/tipc.git
 S:	Maintained
 F:	include/linux/tipc*.h
-F:	include/net/tipc/
 F:	net/tipc/
 
 TILE ARCHITECTURE
-- 
1.7.4.rc3

