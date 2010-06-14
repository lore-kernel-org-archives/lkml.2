Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756481Ab0FNRXJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jun 2010 13:23:09 -0400
Received: from mail.perches.com ([173.55.12.10]:1125 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751165Ab0FNRXH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jun 2010 13:23:07 -0400
Subject: [PATCH V2 7/7] MAINTAINERS: Add patterns to WIMAX STACK
From: Joe Perches <joe@perches.com>
To: Inaky Perez-Gonzalez <inaky.perez-gonzalez@intel.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
In-Reply-To: <1276534504.21431.47.camel@localhost.localdomain>
References: <cover.1276304638.git.joe@perches.com>
	 <557e2d3330369558badc163da6215008ffc50ab1.1276304638.git.joe@perches.com>
	 <1276534504.21431.47.camel@localhost.localdomain>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 14 Jun 2010 10:23:04 -0700
Message-ID: <1276536184.1449.129.camel@Joe-Laptop.home>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Joe Perches <joe@perches.com>
Cc: Inaky Perez-Gonzalez <inaky.perez-gonzalez@intel.com>
---
 MAINTAINERS |    5 +++++
 1 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 4cf783b..03cfc1c 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -6243,6 +6243,11 @@ M:        linux-wimax@intel.com
 L:	wimax@linuxwimax.org
 S:	Supported
 W:	http://linuxwimax.org
+F:	Documentation/wimax/README.wimax
+F:	include/linux/wimax.h
+F:	include/linux/wimax/debug.h
+F:	include/net/wimax.h
+F:	net/wimax/
 
 WIMEDIA LLC PROTOCOL (WLP) SUBSYSTEM
 M:	David Vrabel <david.vrabel@csr.com>
-- 
1.7.1.244.gbdc4


