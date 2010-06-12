Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756429Ab0FLBHF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jun 2010 21:07:05 -0400
Received: from mail.perches.com ([173.55.12.10]:1085 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755677Ab0FLBHB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jun 2010 21:07:01 -0400
From: Joe Perches <joe@perches.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org,
       Inaky Perez-Gonzalez <inaky.perez-gonzalez@intel.com>
Subject: [PATCH 7/7] MAINTAINERS: Add patterns to WIMAX STACK
Date: Fri, 11 Jun 2010 18:06:56 -0700
Message-Id: <557e2d3330369558badc163da6215008ffc50ab1.1276304638.git.joe@perches.com>
X-Mailer: git-send-email 1.7.1.244.gbdc4
In-Reply-To: <cover.1276304638.git.joe@perches.com>
References: <cover.1276304638.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Joe Perches <joe@perches.com>
Cc: Inaky Perez-Gonzalez <inaky.perez-gonzalez@intel.com>
---
 MAINTAINERS |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 4cf783b..03cfc1c 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -6243,6 +6243,9 @@ M:	linux-wimax@intel.com
 L:	wimax@linuxwimax.org
 S:	Supported
 W:	http://linuxwimax.org
+F:	Documentation/wimax/README.wimax
+F:	include/net/wimax.h
+F:	net/wimax/
 
 WIMEDIA LLC PROTOCOL (WLP) SUBSYSTEM
 M:	David Vrabel <david.vrabel@csr.com>
-- 
1.7.1.244.gbdc4

