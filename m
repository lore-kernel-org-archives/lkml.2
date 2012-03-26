Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932840Ab2CZPnx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Mar 2012 11:43:53 -0400
Received: from g6t0185.atlanta.hp.com ([15.193.32.62]:31288 "EHLO
	g6t0185.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932509Ab2CZPnw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Mar 2012 11:43:52 -0400
Date: Mon, 26 Mar 2012 09:43:47 -0600
From: Khalid Aziz <khalid@hp.com>
To: linux-kernel@vger.kernel.org
Cc: joe@perches.com, torvalds@linux-foundation.org
Subject: [PATCH V2] MAINTAINERS: Adding PCDP console maintainer information
Message-ID: <20120326154347.GA28113@hp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks, Joe.

Updated patch to add missing maintainer info for PCDP console code.

Signed-off-by: Khalid Aziz <khalid.aziz@hp.com>
---
 MAINTAINERS |    5 +++++
 1 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index f47091a..6bae6da 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -5116,6 +5116,11 @@ F:	drivers/i2c/busses/i2c-pca-*
 F:	include/linux/i2c-algo-pca.h
 F:	include/linux/i2c-pca-platform.h
 
+PCDP - PRIMARY CONSOLE AND DEBUG PORT
+M:	Khalid Aziz <khalid.aziz@hp.com>
+S:	Maintained
+F:	drivers/firmware/pcdp.*
+
 PCI ERROR RECOVERY
 M:     Linas Vepstas <linasvepstas@gmail.com>
 L:	linux-pci@vger.kernel.org
-- 
1.7.8.3

