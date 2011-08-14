Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753951Ab1HNUyk (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Aug 2011 16:54:40 -0400
Received: from smtp.gentoo.org ([140.211.166.183]:51059 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753638Ab1HNUyj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Aug 2011 16:54:39 -0400
From: Sergei Trofimovich <slyfox@gentoo.org>
To: linux-kernel@vger.kernel.org
Cc: Sergei Trofimovich <slyfox@gentoo.org>,
        Ben Collins <bcollins@bluecherry.net>,
        Greg Kroah-Hartman <gregkh@suse.de>,
        =?UTF-8?q?Krzysztof=20Ha=C5=82asa?= <khalasa@piap.pl>,
        devel@driverdev.osuosl.org
Subject: =?UTF-8?q?=5BPATCH=5D=20staging=3A=20solo6x10/g723=3A=20fix=20build=20failure?=
Date: Sun, 14 Aug 2011 23:52:57 +0300
Message-Id: <1313355177-12605-7-git-send-email-slyfox@gentoo.org>
X-Mailer: git-send-email 1.7.3.4
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Found on allmodconfig build (ARCH=alpha)

    drivers/staging/solo6x10/g723.c: In function 'snd_solo_pcm_open':
    drivers/staging/solo6x10/g723.c:139: error: implicit declaration of function 'kzalloc'

Signed-off-by: Sergei Trofimovich <slyfox@gentoo.org>
Cc: Ben Collins <bcollins@bluecherry.net>
Cc: Greg Kroah-Hartman <gregkh@suse.de>
Cc: "Krzysztof Hałasa" <khalasa@piap.pl>
Cc: devel@driverdev.osuosl.org
---
 drivers/staging/solo6x10/g723.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/staging/solo6x10/g723.c b/drivers/staging/solo6x10/g723.c
index bd8eb92..1a4f19e 100644
--- a/drivers/staging/solo6x10/g723.c
+++ b/drivers/staging/solo6x10/g723.c
@@ -22,6 +22,7 @@
 #include <linux/poll.h>
 #include <linux/kthread.h>
 #include <linux/freezer.h>
+#include <linux/slab.h>
 #include <sound/core.h>
 #include <sound/initval.h>
 #include <sound/pcm.h>
-- 
1.7.3.4

