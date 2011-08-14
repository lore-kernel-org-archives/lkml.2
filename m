Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754313Ab1HNUyn (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Aug 2011 16:54:43 -0400
Received: from smtp.gentoo.org ([140.211.166.183]:51062 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753718Ab1HNUyj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Aug 2011 16:54:39 -0400
From: Sergei Trofimovich <slyfox@gentoo.org>
To: linux-kernel@vger.kernel.org
Cc: Sergei Trofimovich <slyfox@gentoo.org>,
        Ben Collins <bcollins@bluecherry.net>,
        Greg Kroah-Hartman <gregkh@suse.de>,
        =?UTF-8?q?Krzysztof=20Ha=C5=82asa?= <khalasa@piap.pl>,
        devel@driverdev.osuosl.org
Subject: =?UTF-8?q?=5BPATCH=5D=20staging=3A=20solo6x10/p2m=3A=20fix=20build=20failure?=
Date: Sun, 14 Aug 2011 23:52:55 +0300
Message-Id: <1313355177-12605-5-git-send-email-slyfox@gentoo.org>
X-Mailer: git-send-email 1.7.3.4
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Found on allmodconfig build (ARCH=alpha)

    drivers/staging/solo6x10/p2m.c: In function 'solo_p2m_dma_t':
    drivers/staging/solo6x10/p2m.c:52: error: implicit declaration of function 'kzalloc'

Signed-off-by: Sergei Trofimovich <slyfox@gentoo.org>
Cc: Ben Collins <bcollins@bluecherry.net>
Cc: Greg Kroah-Hartman <gregkh@suse.de>
Cc: "Krzysztof Hałasa" <khalasa@piap.pl>
Cc: devel@driverdev.osuosl.org
---
 drivers/staging/solo6x10/p2m.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/staging/solo6x10/p2m.c b/drivers/staging/solo6x10/p2m.c
index 5717eab..2fce566 100644
--- a/drivers/staging/solo6x10/p2m.c
+++ b/drivers/staging/solo6x10/p2m.c
@@ -19,6 +19,7 @@
 
 #include <linux/kernel.h>
 #include <linux/scatterlist.h>
+#include <linux/slab.h>
 #include "solo6x10.h"
 
 /* #define SOLO_TEST_P2M */
-- 
1.7.3.4

