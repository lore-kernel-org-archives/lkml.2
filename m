Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752278Ab0K0GWI (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Nov 2010 01:22:08 -0500
Received: from mail-gw0-f46.google.com ([74.125.83.46]:60399 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751841Ab0K0GV4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Nov 2010 01:21:56 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=kXn3PuBQnGlOLqlO4mAAd9rUg1rwOCw6tfBAW/ssZCE0u/c1T5l1Ms0o4i+A0UEZeW
         8rFvB1Ty7NREOTev3f6gT8fFsTEcCsXQ8zUpgxMVTFSM3NSJK4zEwFYhomHlgVWGFf6J
         lMicThJvW0zK4jmy1kej0BxIaap8NYilZOpbI=
From: "Justin P. Mattock" <justinmattock@gmail.com>
To: trivial@kernel.org
Cc: linux-rdma@vger.kernel.org, linux-ide@vger.kernel.org,
        linux-mtd@lists.infradead.org, linux-wireless@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        "Justin P. Mattock" <justinmattock@gmail.com>
Subject: [RFC 3/9]drivers:infiniband:ulp Change the copyright info.
Date: Fri, 26 Nov 2010 22:21:13 -0800
Message-Id: <1290838879-11038-4-git-send-email-justinmattock@gmail.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1290838879-11038-1-git-send-email-justinmattock@gmail.com>
References: <1290838879-11038-1-git-send-email-justinmattock@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Change the copyright info from Sun Microsystems to Oracle since Oracle now owns them.

Signed-off-by: Justin P. Mattock <justinmattock@gmail.com>

---
 drivers/infiniband/ulp/ipoib/ipoib.h           |    2 +-
 drivers/infiniband/ulp/ipoib/ipoib_ib.c        |    2 +-
 drivers/infiniband/ulp/ipoib/ipoib_main.c      |    2 +-
 drivers/infiniband/ulp/ipoib/ipoib_multicast.c |    2 +-
 4 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/infiniband/ulp/ipoib/ipoib.h b/drivers/infiniband/ulp/ipoib/ipoib.h
index 753a983..bdf2efb 100644
--- a/drivers/infiniband/ulp/ipoib/ipoib.h
+++ b/drivers/infiniband/ulp/ipoib/ipoib.h
@@ -1,6 +1,6 @@
 /*
  * Copyright (c) 2004, 2005 Topspin Communications.  All rights reserved.
- * Copyright (c) 2005 Sun Microsystems, Inc. All rights reserved.
+ * Copyright (c) 2005 Oracle and/or its affiliates. All rights reserved.
  * Copyright (c) 2004 Voltaire, Inc. All rights reserved.
  *
  * This software is available to you under a choice of one of two
diff --git a/drivers/infiniband/ulp/ipoib/ipoib_ib.c b/drivers/infiniband/ulp/ipoib/ipoib_ib.c
index dfa7190..87ff9eb 100644
--- a/drivers/infiniband/ulp/ipoib/ipoib_ib.c
+++ b/drivers/infiniband/ulp/ipoib/ipoib_ib.c
@@ -1,6 +1,6 @@
 /*
  * Copyright (c) 2004, 2005 Topspin Communications.  All rights reserved.
- * Copyright (c) 2005 Sun Microsystems, Inc. All rights reserved.
+ * Copyright (c) 2005 Oracle and/or its affiliates. All rights reserved.
  * Copyright (c) 2005 Mellanox Technologies. All rights reserved.
  * Copyright (c) 2004, 2005 Voltaire, Inc. All rights reserved.
  *
diff --git a/drivers/infiniband/ulp/ipoib/ipoib_main.c b/drivers/infiniband/ulp/ipoib/ipoib_main.c
index 9ff7bc7..43df433 100644
--- a/drivers/infiniband/ulp/ipoib/ipoib_main.c
+++ b/drivers/infiniband/ulp/ipoib/ipoib_main.c
@@ -1,6 +1,6 @@
 /*
  * Copyright (c) 2004 Topspin Communications.  All rights reserved.
- * Copyright (c) 2005 Sun Microsystems, Inc. All rights reserved.
+ * Copyright (c) 2005 Oracle and/or its affiliates. All rights reserved.
  * Copyright (c) 2004 Voltaire, Inc. All rights reserved.
  *
  * This software is available to you under a choice of one of two
diff --git a/drivers/infiniband/ulp/ipoib/ipoib_multicast.c b/drivers/infiniband/ulp/ipoib/ipoib_multicast.c
index 3871ac6..af52828 100644
--- a/drivers/infiniband/ulp/ipoib/ipoib_multicast.c
+++ b/drivers/infiniband/ulp/ipoib/ipoib_multicast.c
@@ -1,6 +1,6 @@
 /*
  * Copyright (c) 2004, 2005 Topspin Communications.  All rights reserved.
- * Copyright (c) 2005 Sun Microsystems, Inc. All rights reserved.
+ * Copyright (c) 2005 Oracle and/or its affiliates. All rights reserved.
  * Copyright (c) 2004 Voltaire, Inc. All rights reserved.
  *
  * This software is available to you under a choice of one of two
-- 
1.7.1

