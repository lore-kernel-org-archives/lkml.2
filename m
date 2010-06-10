Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753180Ab0FJFOS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jun 2010 01:14:18 -0400
Received: from mail.perches.com ([173.55.12.10]:2983 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751374Ab0FJFOR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jun 2010 01:14:17 -0400
From: Joe Perches <joe@perches.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, David Airlie <airlied@linux.ie>
Subject: [PATCH] MAINTAINERS: Update DRM DRIVERS patterns
Date: Wed,  9 Jun 2010 22:14:15 -0700
Message-Id: <911b694a380540144eef2350c5fda67f7ac624ad.1276146766.git.joe@perches.com>
X-Mailer: git-send-email 1.7.1.244.gbdc4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Joe Perches <joe@perches.com>
Cc: David Airlie <airlied@linux.ie>
---
 MAINTAINERS |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index d462530..55ad815 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -2002,6 +2002,7 @@ L:	dri-devel@lists.freedesktop.org
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/airlied/drm-2.6.git
 S:	Maintained
 F:	drivers/gpu/drm/
+F:	include/drm/
 
 DSCC4 DRIVER
 M:	Francois Romieu <romieu@fr.zoreil.com>
-- 
1.7.1.244.gbdc4

