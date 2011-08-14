Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754182Ab1HNUum (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Aug 2011 16:50:42 -0400
Received: from smtp.gentoo.org ([140.211.166.183]:40947 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753730Ab1HNUuU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Aug 2011 16:50:20 -0400
From: Sergei Trofimovich <slyfox@gentoo.org>
To: linux-kernel@vger.kernel.org
Cc: Sergei Trofimovich <slyfox@gentoo.org>,
        Ben Collins <bcollins@bluecherry.net>,
        Greg Kroah-Hartman <gregkh@suse.de>,
        =?UTF-8?q?Krzysztof=20Ha=C5=82asa?= <khalasa@piap.pl>,
        devel@driverdev.osuosl.org
Subject: =?UTF-8?q?=5BPATCH=5D=20staging=3A=20solo6x10/core=3A=20fix=20build=20failure?=
Date: Sun, 14 Aug 2011 23:52:54 +0300
Message-Id: <1313355177-12605-4-git-send-email-slyfox@gentoo.org>
X-Mailer: git-send-email 1.7.3.4
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Found on allmodconfig build (ARCH=alpha)

    drivers/staging/solo6x10/core.c: In function 'solo_pci_probe':
    drivers/staging/solo6x10/core.c:140: error: implicit declaration of function 'kzalloc'

Signed-off-by: Sergei Trofimovich <slyfox@gentoo.org>
Cc: Ben Collins <bcollins@bluecherry.net>
Cc: Greg Kroah-Hartman <gregkh@suse.de>
Cc: "Krzysztof Hałasa" <khalasa@piap.pl>
Cc: devel@driverdev.osuosl.org
---
 drivers/staging/solo6x10/core.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/staging/solo6x10/core.c b/drivers/staging/solo6x10/core.c
index 7677994..f974f64 100644
--- a/drivers/staging/solo6x10/core.c
+++ b/drivers/staging/solo6x10/core.c
@@ -21,6 +21,7 @@
 #include <linux/module.h>
 #include <linux/pci.h>
 #include <linux/interrupt.h>
+#include <linux/slab.h>
 #include <linux/videodev2.h>
 #include "solo6x10.h"
 #include "tw28.h"
-- 
1.7.3.4

