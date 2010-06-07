Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753959Ab0FGSxn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jun 2010 14:53:43 -0400
Received: from mail.perches.com ([173.55.12.10]:2680 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753349Ab0FGSuC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jun 2010 14:50:02 -0400
From: Joe Perches <joe@perches.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org,
       Ian Abbott <abbotti@mev.co.uk>,
       Mori Hess <fmhess@users.sourceforge.net>
Subject: [PATCH 03/17] MAINTAINERS: Add STAGING - COMEDI
Date: Mon,  7 Jun 2010 11:49:37 -0700
Message-Id: <62375afe6c747a8d91fb08ed788eba27b2730dba.1275935090.git.joe@perches.com>
X-Mailer: git-send-email 1.7.1.244.gbdc4
In-Reply-To: <cover.1275935090.git.joe@perches.com>
References: <cover.1275935090.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Joe Perches <joe@perches.com>
---
 MAINTAINERS |    6 ++++++
 1 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index c4de33b..b175605 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -5461,6 +5461,12 @@ L:	b.a.t.m.a.n@lists.open-mesh.net
 S:	Maintained
 F:	drivers/staging/batman-adv/
 
+STAGING - COMEDI
+M:	Ian Abbott <abbotti@mev.co.uk>
+M:	Mori Hess <fmhess@users.sourceforge.net>
+S:	Odd Fixes
+F:	drivers/staging/comedi/
+
 STARFIRE/DURALAN NETWORK DRIVER
 M:	Ion Badulescu <ionut@badula.org>
 S:	Odd Fixes
-- 
1.7.1.244.gbdc4

