Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753791Ab1LIEWp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Dec 2011 23:22:45 -0500
Received: from perches-mx.perches.com ([206.117.179.246]:43999 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753277Ab1LIEWk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Dec 2011 23:22:40 -0500
From: Joe Perches <joe@perches.com>
To: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Cc: Jonathan Corbet <corbet@lwn.net>,
        Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: [PATCH v3.2 05/10] MAINTAINERS: Update marvell ccic F: patterns
Date: Thu,  8 Dec 2011 20:21:43 -0800
Message-Id: <1d1251f2213424a52340275e411fcff2ff4b2385.1323401278.git.joe@perches.com>
X-Mailer: git-send-email 1.7.8.111.gad25c.dirty
In-Reply-To: <cover.1323401278.git.joe@perches.com>
References: <cover.1323401278.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit f8fc729870ee
("[media] marvell-cam: Move cafe-ccic into its own directory")
moved the files, update the pattern.

CC: Jonathan Corbet <corbet@lwn.net>
CC: Mauro Carvalho Chehab <mchehab@redhat.com>

Signed-off-by: Joe Perches <joe@perches.com>
---
 MAINTAINERS |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index df2bef0..6d98e5e 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -1671,7 +1671,7 @@ L:	linux-media@vger.kernel.org
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/mchehab/linux-2.6.git
 S:	Maintained
 F:	Documentation/video4linux/cafe_ccic
-F:	drivers/media/video/cafe_ccic*
+F:	drivers/media/video/marvell-ccic/
 
 CAIF NETWORK LAYER
 M:	Sjur Braendeland <sjur.brandeland@stericsson.com>
-- 
1.7.8.111.gad25c.dirty

