Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932490Ab0FITis (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jun 2010 15:38:48 -0400
Received: from mail.perches.com ([173.55.12.10]:2944 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932407Ab0FITip (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jun 2010 15:38:45 -0400
From: Joe Perches <joe@perches.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH 05/12] MAINTAINERS: Update NETWORKING [WIRELESS] file patterns
Date: Wed,  9 Jun 2010 12:38:31 -0700
Message-Id: <bdce03a248755fab416aa00bbb0c64e77c5520e0.1276112117.git.joe@perches.com>
X-Mailer: git-send-email 1.7.1.244.gbdc4
In-Reply-To: <cover.1276112117.git.joe@perches.com>
References: <cover.1276112117.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Joe Perches <joe@perches.com>
Cc: "John W. Linville" <linville@tuxdriver.com>
---
 MAINTAINERS |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 6facecc..70742db 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -4013,7 +4013,7 @@ F:	net/rfkill/
 F:	net/wireless/
 F:	include/net/ieee80211*
 F:	include/linux/wireless.h
-F:	include/linux/iw_handler.h
+F:	include/net/iw_handler.h
 F:	drivers/net/wireless/
 
 NETWORKING DRIVERS
-- 
1.7.1.244.gbdc4

