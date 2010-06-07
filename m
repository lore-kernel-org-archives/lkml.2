Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753388Ab0FGSuF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jun 2010 14:50:05 -0400
Received: from mail.perches.com ([173.55.12.10]:2680 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753325Ab0FGSuA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jun 2010 14:50:00 -0400
From: Joe Perches <joe@perches.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org,
       Marek Lindner <lindner_marek@yahoo.de>,
       Simon Wunderlich <siwu@hrz.tu-chemnitz.de>,
       Andrew Lunn <andrew@lunn.ch>
Subject: [PATCH 02/17] MAINTAINERS: Add STAGING - B.A.T.M.A.N.
Date: Mon,  7 Jun 2010 11:49:36 -0700
Message-Id: <06f9a3670042abc6d50992e28227a4cb577a7702.1275935090.git.joe@perches.com>
X-Mailer: git-send-email 1.7.1.244.gbdc4
In-Reply-To: <cover.1275935090.git.joe@perches.com>
References: <cover.1275935090.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Joe Perches <joe@perches.com>
---
 MAINTAINERS |    8 ++++++++
 1 files changed, 8 insertions(+), 0 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 004c343..c4de33b 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -5453,6 +5453,14 @@ M:	Jakub Schmidtke <sjakub@gmail.com>
 S:	Odd Fixes
 F:	drivers/staging/asus_oled/
 
+STAGING - B.A.T.M.A.N.
+M:	Marek Lindner <lindner_marek@yahoo.de>
+M:	Simon Wunderlich <siwu@hrz.tu-chemnitz.de>
+M:	Andrew Lunn <andrew@lunn.ch>
+L:	b.a.t.m.a.n@lists.open-mesh.net
+S:	Maintained
+F:	drivers/staging/batman-adv/
+
 STARFIRE/DURALAN NETWORK DRIVER
 M:	Ion Badulescu <ionut@badula.org>
 S:	Odd Fixes
-- 
1.7.1.244.gbdc4

