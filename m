Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967263Ab2EPKY1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 May 2012 06:24:27 -0400
Received: from skyrme.org ([193.175.80.135]:36921 "EHLO skyrme.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S967138Ab2EPKXz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 May 2012 06:23:55 -0400
Date: 16 May 2012 09:41:19 +0000
Message-Id: <1337161280-28953-5-git-send-email-oskar@scara.com>
From: "Oskar Schirmer" <oskar@scara.com>
To: linux-kernel@vger.kernel.org
Cc: trivial@kernel.org, hannes@cmpxchg.org, shess@hessware.de,
        "Oskar Schirmer" <oskar@scara.com>,
        "Paul Gortmaker" <paul.gortmaker@windriver.com>
Subject: [PATCH 4/5] lib: Change mail address of Oskar Schirmer
X-Mailer: git-send-email 1.6.0.3
In-Reply-To: <1337161280-28953-1-git-send-email-oskar@scara.com>
References: <1337161280-28953-1-git-send-email-oskar@scara.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

That old mail address doesnt exist any more.
This changes all occurences to my new address.

Signed-off-by: Oskar Schirmer <oskar@scara.com>
Cc: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 include/linux/rational.h |    2 +-
 lib/rational.c           |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/include/linux/rational.h b/include/linux/rational.h
index 4f532fc..bfa6a2b 100644
--- a/include/linux/rational.h
+++ b/include/linux/rational.h
@@ -1,7 +1,7 @@
 /*
  * rational fractions
  *
- * Copyright (C) 2009 emlix GmbH, Oskar Schirmer <os@emlix.com>
+ * Copyright (C) 2009 emlix GmbH, Oskar Schirmer <oskar@scara.com>
  *
  * helper functions when coping with rational numbers,
  * e.g. when calculating optimum numerator/denominator pairs for
diff --git a/lib/rational.c b/lib/rational.c
index d326da3..f0aa21c 100644
--- a/lib/rational.c
+++ b/lib/rational.c
@@ -1,7 +1,7 @@
 /*
  * rational fractions
  *
- * Copyright (C) 2009 emlix GmbH, Oskar Schirmer <os@emlix.com>
+ * Copyright (C) 2009 emlix GmbH, Oskar Schirmer <oskar@scara.com>
  *
  * helper functions when coping with rational numbers
  */
-- 
1.7.5.4

