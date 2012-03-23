Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757593Ab2CWRpA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Mar 2012 13:45:00 -0400
Received: from g1t0026.austin.hp.com ([15.216.28.33]:12962 "EHLO
	g1t0026.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756919Ab2CWRo7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Mar 2012 13:44:59 -0400
Date: Fri, 23 Mar 2012 11:44:57 -0600
From: Khalid Aziz <khalid@hp.com>
To: linux-kernel@vger.kernel.org
Cc: torvalds@linux-foundation.org
Subject: [PATCH] MAINTAINERS: Adding PCDP console maintainer information
Message-ID: <20120323174457.GA12579@hp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds missing maintainer info for PCDP console code.

Signed-off-by: Khalid Aziz <khalid.aziz@hp.com>
---
 MAINTAINERS |    5 +++++
 1 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 95eba31..3fc5aaa 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -5112,6 +5112,11 @@ F:	drivers/i2c/busses/i2c-pca-*
 F:	include/linux/i2c-algo-pca.h
 F:	include/linux/i2c-pca-platform.h
 
+PCDP CONSOLE
+M:	Khalid Aziz <khalid.aziz@hp.com>
+S:	Maintained
+F:	drivers/firmware/pcdp.*
+
 PCI ERROR RECOVERY
 M:     Linas Vepstas <linasvepstas@gmail.com>
 L:	linux-pci@vger.kernel.org
-- 
1.7.8.3

