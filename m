Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030211Ab2EPKYq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 May 2012 06:24:46 -0400
Received: from skyrme.org ([193.175.80.135]:36908 "EHLO skyrme.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966982Ab2EPKXd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 May 2012 06:23:33 -0400
Date: 16 May 2012 09:41:16 +0000
Message-Id: <1337161280-28953-2-git-send-email-oskar@scara.com>
From: "Oskar Schirmer" <oskar@scara.com>
To: linux-kernel@vger.kernel.org
Cc: trivial@kernel.org, hannes@cmpxchg.org, shess@hessware.de,
        "Oskar Schirmer" <oskar@scara.com>, "Chris Zankel" <chris@zankel.net>
Subject: [PATCH 1/5] xtensa: Change mail addresses of Hannes Weiner and Oskar
X-Mailer: git-send-email 1.6.0.3
In-Reply-To: <1337161280-28953-1-git-send-email-oskar@scara.com>
References: <1337161280-28953-1-git-send-email-oskar@scara.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These old mail addresses dont exist any more.
This changes all occurences to the authors' current addresses.

Signed-off-by: Oskar Schirmer <oskar@scara.com>
Cc: Hannes Weiner <hannes@cmpxchg.org>
Cc: Chris Zankel <chris@zankel.net>
---
 arch/xtensa/variants/s6000/dmac.c                 |    2 +-
 arch/xtensa/variants/s6000/gpio.c                 |    4 ++--
 arch/xtensa/variants/s6000/include/variant/dmac.h |    2 +-
 arch/xtensa/variants/s6000/irq.c                  |    4 ++--
 4 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/arch/xtensa/variants/s6000/dmac.c b/arch/xtensa/variants/s6000/dmac.c
index dc7f7c5..340f5bb 100644
--- a/arch/xtensa/variants/s6000/dmac.c
+++ b/arch/xtensa/variants/s6000/dmac.c
@@ -1,5 +1,5 @@
 /*
- * Authors:	Oskar Schirmer <os@emlix.com>
+ * Authors:	Oskar Schirmer <oskar@scara.com>
  *		Daniel Gloeckner <dg@emlix.com>
  * (c) 2008 emlix GmbH http://www.emlix.com
  *
diff --git a/arch/xtensa/variants/s6000/gpio.c b/arch/xtensa/variants/s6000/gpio.c
index 7af0757..b89541b 100644
--- a/arch/xtensa/variants/s6000/gpio.c
+++ b/arch/xtensa/variants/s6000/gpio.c
@@ -2,8 +2,8 @@
  * s6000 gpio driver
  *
  * Copyright (c) 2009 emlix GmbH
- * Authors:	Oskar Schirmer <os@emlix.com>
- *		Johannes Weiner <jw@emlix.com>
+ * Authors:	Oskar Schirmer <oskar@scara.com>
+ *		Johannes Weiner <hannes@cmpxchg.org>
  *		Daniel Gloeckner <dg@emlix.com>
  */
 #include <linux/bitops.h>
diff --git a/arch/xtensa/variants/s6000/include/variant/dmac.h b/arch/xtensa/variants/s6000/include/variant/dmac.h
index e81735b..3f88d9f 100644
--- a/arch/xtensa/variants/s6000/include/variant/dmac.h
+++ b/arch/xtensa/variants/s6000/include/variant/dmac.h
@@ -8,7 +8,7 @@
  * Copyright (C) 2006 Tensilica Inc.
  * Copyright (C) 2008 Emlix GmbH <info@emlix.com>
  * Authors:	Fabian Godehardt <fg@emlix.com>
- *		Oskar Schirmer <os@emlix.com>
+ *		Oskar Schirmer <oskar@scara.com>
  *		Daniel Gloeckner <dg@emlix.com>
  */
 
diff --git a/arch/xtensa/variants/s6000/irq.c b/arch/xtensa/variants/s6000/irq.c
index 6651e32..81a241e 100644
--- a/arch/xtensa/variants/s6000/irq.c
+++ b/arch/xtensa/variants/s6000/irq.c
@@ -2,8 +2,8 @@
  * s6000 irq crossbar
  *
  * Copyright (c) 2009 emlix GmbH
- * Authors:	Johannes Weiner <jw@emlix.com>
- *		Oskar Schirmer <os@emlix.com>
+ * Authors:	Johannes Weiner <hannes@cmpxchg.org>
+ *		Oskar Schirmer <oskar@scara.com>
  */
 #include <linux/io.h>
 #include <asm/irq.h>
-- 
1.7.5.4

