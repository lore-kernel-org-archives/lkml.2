Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754686Ab1DSK1O (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Apr 2011 06:27:14 -0400
Received: from ganesha.gnumonks.org ([213.95.27.120]:55452 "EHLO
	ganesha.gnumonks.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753637Ab1DSK1M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Apr 2011 06:27:12 -0400
From: Kukjin Kim <kgene.kim@samsung.com>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, Kukjin Kim <kgene.kim@samsung.com>,
        Grant Likely <grant.likely@secretlab.ca>
Subject: [PATCH] MAINTAINERS: Update Documentation file entry of GPIO subsystem
Date: Tue, 19 Apr 2011 18:52:51 +0900
Message-Id: <1303206771-29525-1-git-send-email-kgene.kim@samsung.com>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Cc: Grant Likely <grant.likely@secretlab.ca>
Signed-off-by: Kukjin Kim <kgene.kim@samsung.com>
---
 MAINTAINERS |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 649600c..e43374a 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -2802,7 +2802,7 @@ GPIO SUBSYSTEM
 M:	Grant Likely <grant.likely@secretlab.ca>
 S:	Maintained
 T:	git git://git.secretlab.ca/git/linux-2.6.git
-F:	Documentation/gpio/gpio.txt
+F:	Documentation/gpio.txt
 F:	drivers/gpio/
 F:	include/linux/gpio*
 
-- 
1.7.1

