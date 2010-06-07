Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753684Ab0FGSxl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jun 2010 14:53:41 -0400
Received: from mail.perches.com ([173.55.12.10]:2696 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753342Ab0FGSuC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jun 2010 14:50:02 -0400
From: Joe Perches <joe@perches.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org,
       Naren Sankar <nsankar@broadcom.com>, Jarod Wilson <jarod@wilsonet.com>,
       Scott Davilla <davilla@4pi.com>, Manu Abraham <abraham.manu@gmail.com>
Subject: [PATCH 04/17] MAINTAINERS: Add STAGING - CRYSTAL HD VIDEO DECODER
Date: Mon,  7 Jun 2010 11:49:38 -0700
Message-Id: <bd85c049121e9aac042b0dd3637a2db1c28fa5a1.1275935090.git.joe@perches.com>
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
index b175605..c277684 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -5467,6 +5467,14 @@ M:	Mori Hess <fmhess@users.sourceforge.net>
 S:	Odd Fixes
 F:	drivers/staging/comedi/
 
+STAGING - CRYSTAL HD VIDEO DECODER
+M:	Naren Sankar <nsankar@broadcom.com>
+M:	Jarod Wilson <jarod@wilsonet.com>
+M:	Scott Davilla <davilla@4pi.com>
+M:	Manu Abraham <abraham.manu@gmail.com>
+S:	Odd Fixes
+F:	drivers/staging/crystalhd/
+
 STARFIRE/DURALAN NETWORK DRIVER
 M:	Ion Badulescu <ionut@badula.org>
 S:	Odd Fixes
-- 
1.7.1.244.gbdc4

