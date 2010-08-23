Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752515Ab0HWIjw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Aug 2010 04:39:52 -0400
Received: from smtp.gentoo.org ([140.211.166.183]:57200 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751704Ab0HWIjs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Aug 2010 04:39:48 -0400
From: Mike Frysinger <vapier@gentoo.org>
To: uclinux-dist-devel@blackfin.uclinux.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 2/3] ADI/ASoC: add MAINTAINERS entries
Date: Mon, 23 Aug 2010 04:40:04 -0400
Message-Id: <1282552805-18989-3-git-send-email-vapier@gentoo.org>
X-Mailer: git-send-email 1.7.2
In-Reply-To: <1282552805-18989-1-git-send-email-vapier@gentoo.org>
References: <1282552805-18989-1-git-send-email-vapier@gentoo.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Mike Frysinger <vapier@gentoo.org>
---
 MAINTAINERS |   11 +++++++++++
 1 files changed, 11 insertions(+), 0 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 433f353..a1df54b 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -454,6 +454,17 @@ L:	linux-rdma@vger.kernel.org
 S:	Maintained
 F:	drivers/infiniband/hw/amso1100/
 
+ANALOG DEVICES INC ASOC DRIVERS
+L:	uclinux-dist-devel@blackfin.uclinux.org
+L:	alsa-devel@alsa-project.org (moderated for non-subscribers)
+W:	http://blackfin.uclinux.org/
+S:	Supported
+F:	sound/soc/blackfin/*
+F:	sound/soc/codecs/ad1*
+F:	sound/soc/codecs/adau*
+F:	sound/soc/codecs/adav*
+F:	sound/soc/codecs/ssm*
+
 AOA (Apple Onboard Audio) ALSA DRIVER
 M:	Johannes Berg <johannes@sipsolutions.net>
 L:	linuxppc-dev@lists.ozlabs.org
-- 
1.7.2

