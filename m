Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758907Ab1KVWEV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Nov 2011 17:04:21 -0500
Received: from smtp5-g21.free.fr ([212.27.42.5]:34738 "EHLO smtp5-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758850Ab1KVWES (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Nov 2011 17:04:18 -0500
From: Corentin Chary <corentincj@iksaif.net>
To: platform-driver-x86@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@suse.de>,
        Corentin Chary <corentincj@iksaif.net>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        Joe Perches <joe@perches.com>, "David S. Miller" <davem@davemloft.net>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 15/15] samsung-laptop: promote myself as maintainer of samsung-laptop
Date: Tue, 22 Nov 2011 23:02:46 +0100
Message-Id: <1321999366-23784-16-git-send-email-corentincj@iksaif.net>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1321999366-23784-1-git-send-email-corentincj@iksaif.net>
References: <1321999366-23784-1-git-send-email-corentincj@iksaif.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Corentin Chary <corentincj@iksaif.net>
---
 MAINTAINERS |    6 ++++++
 1 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 3523ab0..bdde26f 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -5666,6 +5666,12 @@ F:	drivers/media/common/saa7146*
 F:	drivers/media/video/*7146*
 F:	include/media/*7146*
 
+SAMSUNG LAPTOP DRIVER
+M:	Corentin Chary <corentincj@iksaif.net>
+L:	platform-driver-x86@vger.kernel.org
+S:	Maintained
+F:	drivers/platform/x86/samsung-laptop.c
+
 SAMSUNG AUDIO (ASoC) DRIVERS
 M:	Jassi Brar <jassisinghbrar@gmail.com>
 M:	Sangbeom Kim <sbkim73@samsung.com>
-- 
1.7.5.4

