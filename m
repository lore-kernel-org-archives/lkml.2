Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754021Ab0FGVOo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jun 2010 17:14:44 -0400
Received: from mail.perches.com ([173.55.12.10]:2752 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752103Ab0FGVOn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jun 2010 17:14:43 -0400
Subject: [PATCH V2 03/17] MAINTAINERS: Add STAGING - COMEDI
From: Joe Perches <joe@perches.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org,
       Ian Abbott <abbotti@mev.co.uk>,
       Frank Mori Hess <fmhess@users.sourceforge.net>
In-Reply-To: <cover.1275935090.git.joe@perches.com>
References: <cover.1275935090.git.joe@perches.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 07 Jun 2010 14:14:40 -0700
Message-ID: <1275945280.22353.1.camel@Joe-Laptop.home>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mr. Hess informs me he has a first name.

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
+M:	Frank Mori Hess <fmhess@users.sourceforge.net>
+S:	Odd Fixes
+F:	drivers/staging/comedi/
+
 STARFIRE/DURALAN NETWORK DRIVER
 M:	Ion Badulescu <ionut@badula.org>
 S:	Odd Fixes
-- 
1.7.1.244.gbdc4


