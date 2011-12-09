Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754207Ab1LIEXW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Dec 2011 23:23:22 -0500
Received: from perches-mx.perches.com ([206.117.179.246]:39949 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753653Ab1LIEXU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Dec 2011 23:23:20 -0500
From: Joe Perches <joe@perches.com>
To: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Cc: Kristoffer Glembo <kristoffer@gaisler.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Subject: [PATCH v3.2 09/10] MAINTAINERS: Update greth F: patterns
Date: Thu,  8 Dec 2011 20:21:47 -0800
Message-Id: <281942c3723efe382f3879163f73758e0db96c35.1323401278.git.joe@perches.com>
X-Mailer: git-send-email 1.7.8.111.gad25c.dirty
In-Reply-To: <cover.1323401278.git.joe@perches.com>
References: <cover.1323401278.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

commit 1fe003fd424 ("greth: Move the Aeroflex Gaisler driver")
moved the files, update the patterns.

CC: Kristoffer Glembo <kristoffer@gaisler.com>
CC: Jeff Kirsher <jeffrey.t.kirsher@intel.com>

Signed-off-by: Joe Perches <joe@perches.com>
---
 MAINTAINERS |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 9926225..69c5720 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -2933,7 +2933,7 @@ GRETH 10/100/1G Ethernet MAC device driver
 M:	Kristoffer Glembo <kristoffer@gaisler.com>
 L:	netdev@vger.kernel.org
 S:	Maintained
-F:	drivers/net/greth*
+F:	drivers/net/ethernet/aeroflex/
 
 GSPCA FINEPIX SUBDRIVER
 M:	Frank Zago <frank@zago.net>
-- 
1.7.8.111.gad25c.dirty

