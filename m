Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753948Ab1LIEWf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Dec 2011 23:22:35 -0500
Received: from perches-mx.perches.com ([206.117.179.246]:60247 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753768Ab1LIEWb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Dec 2011 23:22:31 -0500
From: Joe Perches <joe@perches.com>
To: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Cc: Grant Likely <grant.likely@secretlab.ca>, Michael Buesch <m@bues.ch>
Subject: [PATCH v3.2 04/10] MAINTAINERS: Update bt8xx gpio F: patterns
Date: Thu,  8 Dec 2011 20:21:42 -0800
Message-Id: <6d2d80f2b9c4bebdf9fb34137b2cd60b9f06fa15.1323401278.git.joe@perches.com>
X-Mailer: git-send-email 1.7.8.111.gad25c.dirty
In-Reply-To: <cover.1323401278.git.joe@perches.com>
References: <cover.1323401278.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit c103de240439d ("gpio: reorganize drivers") renamed
the file, update the pattern.

CC: Grant Likely <grant.likely@secretlab.ca>
CC: Michael Buesch <m@bues.ch>

Signed-off-by: Joe Perches <joe@perches.com>
---
 MAINTAINERS |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index bfa54c1..df2bef0 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -1630,7 +1630,7 @@ BT8XXGPIO DRIVER
 M:	Michael Buesch <m@bues.ch>
 W:	http://bu3sch.de/btgpio.php
 S:	Maintained
-F:	drivers/gpio/bt8xxgpio.c
+F:	drivers/gpio/gpio-bt8xx.c
 
 BTRFS FILE SYSTEM
 M:	Chris Mason <chris.mason@oracle.com>
-- 
1.7.8.111.gad25c.dirty

