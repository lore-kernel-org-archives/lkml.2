Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751611Ab2LTToM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Dec 2012 14:44:12 -0500
Received: from g1t0026.austin.hp.com ([15.216.28.33]:36021 "EHLO
	g1t0026.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750875Ab2LTToB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Dec 2012 14:44:01 -0500
Message-ID: <1356032637.24462.4.camel@buesod1.americas.hpqcorp.net>
Subject: [PATCH] Documentation: ABI: remove testing/sysfs-devices-node
From: Davidlohr Bueso <davidlohr.bueso@hp.com>
To: Andrew Morton <akpm@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Mel Gorman <mel@csn.ul.ie>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org
Date: Thu, 20 Dec 2012 11:43:57 -0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4 (3.4.4-2.fc17) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This file is already documented in the stable ABI (commit 5bbe1ec1).

Signed-off-by: Davidlohr Bueso <davidlohr.bueso@hp.com>
---
 Documentation/ABI/testing/sysfs-devices-node | 7 -------
 1 file changed, 7 deletions(-)
 delete mode 100644 Documentation/ABI/testing/sysfs-devices-node

diff --git a/Documentation/ABI/testing/sysfs-devices-node b/Documentation/ABI/testing/sysfs-devices-node
deleted file mode 100644
index 453a210..0000000
--- a/Documentation/ABI/testing/sysfs-devices-node
+++ /dev/null
@@ -1,7 +0,0 @@
-What:		/sys/devices/system/node/nodeX/compact
-Date:		February 2010
-Contact:	Mel Gorman <mel@csn.ul.ie>
-Description:
-		When this file is written to, all memory within that node
-		will be compacted. When it completes, memory will be freed
-		into blocks which have as many contiguous pages as possible
-- 
1.7.11.7



