Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751831Ab0K0GVz (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Nov 2010 01:21:55 -0500
Received: from mail-yw0-f46.google.com ([209.85.213.46]:37842 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751039Ab0K0GVk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Nov 2010 01:21:40 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=tbVxvNJzaspj5gyx6Gyg8xqQWvu5A1rjkA0qMXYpooERSAoYiVpJMbZn4pqbOeF/6J
         GYfaOIW6diOKV2urbznRpDiylHwdU+BeUGjF7pfSYPM59kvEUn1W6/VD1tpZLchuwope
         jq+wGdv2bv4PAj6UnHUUEgP1/h4Gwc8ApJcsM=
From: "Justin P. Mattock" <justinmattock@gmail.com>
To: trivial@kernel.org
Cc: linux-rdma@vger.kernel.org, linux-ide@vger.kernel.org,
        linux-mtd@lists.infradead.org, linux-wireless@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        "Justin P. Mattock" <justinmattock@gmail.com>
Subject: [RFC 1/9]drivers:infiniband:hw:mthca Change the copyright info.
Date: Fri, 26 Nov 2010 22:21:11 -0800
Message-Id: <1290838879-11038-2-git-send-email-justinmattock@gmail.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1290838879-11038-1-git-send-email-justinmattock@gmail.com>
References: <1290838879-11038-1-git-send-email-justinmattock@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Change the copyright info from Sun Microsystems to Oracle since Oracle now owns them.

Signed-off-by: Justin P. Mattock <justinmattock@gmail.com>

---
 drivers/infiniband/hw/amso1100/c2_cq.c       |    2 +-
 drivers/infiniband/hw/mthca/mthca_av.c       |    2 +-
 drivers/infiniband/hw/mthca/mthca_cq.c       |    2 +-
 drivers/infiniband/hw/mthca/mthca_dev.h      |    2 +-
 drivers/infiniband/hw/mthca/mthca_doorbell.h |    2 +-
 drivers/infiniband/hw/mthca/mthca_main.c     |    2 +-
 drivers/infiniband/hw/mthca/mthca_provider.c |    2 +-
 7 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/infiniband/hw/amso1100/c2_cq.c b/drivers/infiniband/hw/amso1100/c2_cq.c
index 49e0e85..2235d43 100644
--- a/drivers/infiniband/hw/amso1100/c2_cq.c
+++ b/drivers/infiniband/hw/amso1100/c2_cq.c
@@ -1,6 +1,6 @@
 /*
  * Copyright (c) 2004, 2005 Topspin Communications.  All rights reserved.
- * Copyright (c) 2005 Sun Microsystems, Inc. All rights reserved.
+ * Copyright (c) 2005 Oracle and/or its affiliates. All rights reserved.
  * Copyright (c) 2005 Cisco Systems, Inc. All rights reserved.
  * Copyright (c) 2005 Mellanox Technologies. All rights reserved.
  * Copyright (c) 2004 Voltaire, Inc. All rights reserved.
diff --git a/drivers/infiniband/hw/mthca/mthca_av.c b/drivers/infiniband/hw/mthca/mthca_av.c
index 32f6c63..e882071 100644
--- a/drivers/infiniband/hw/mthca/mthca_av.c
+++ b/drivers/infiniband/hw/mthca/mthca_av.c
@@ -1,6 +1,6 @@
 /*
  * Copyright (c) 2004 Topspin Communications.  All rights reserved.
- * Copyright (c) 2005 Sun Microsystems, Inc. All rights reserved.
+ * Copyright (c) 2005 Oracle and/or its affiliates. All rights reserved.
  *
  * This software is available to you under a choice of one of two
  * licenses.  You may choose to be licensed under the terms of the GNU
diff --git a/drivers/infiniband/hw/mthca/mthca_cq.c b/drivers/infiniband/hw/mthca/mthca_cq.c
index 18ee3fa..3a68bdc 100644
--- a/drivers/infiniband/hw/mthca/mthca_cq.c
+++ b/drivers/infiniband/hw/mthca/mthca_cq.c
@@ -1,6 +1,6 @@
 /*
  * Copyright (c) 2004, 2005 Topspin Communications.  All rights reserved.
- * Copyright (c) 2005 Sun Microsystems, Inc. All rights reserved.
+ * Copyright (c) 2005 Oracle and/or its affiliates. All rights reserved.
  * Copyright (c) 2005, 2006 Cisco Systems, Inc. All rights reserved.
  * Copyright (c) 2005 Mellanox Technologies. All rights reserved.
  * Copyright (c) 2004 Voltaire, Inc. All rights reserved.
diff --git a/drivers/infiniband/hw/mthca/mthca_dev.h b/drivers/infiniband/hw/mthca/mthca_dev.h
index 7e6a6d6..2af6812 100644
--- a/drivers/infiniband/hw/mthca/mthca_dev.h
+++ b/drivers/infiniband/hw/mthca/mthca_dev.h
@@ -1,6 +1,6 @@
 /*
  * Copyright (c) 2004, 2005 Topspin Communications.  All rights reserved.
- * Copyright (c) 2005 Sun Microsystems, Inc. All rights reserved.
+ * Copyright (c) 2005 Oracle and/or its affiliates. All rights reserved.
  * Copyright (c) 2005, 2006 Cisco Systems.  All rights reserved.
  * Copyright (c) 2005 Mellanox Technologies. All rights reserved.
  * Copyright (c) 2004 Voltaire, Inc. All rights reserved.
diff --git a/drivers/infiniband/hw/mthca/mthca_doorbell.h b/drivers/infiniband/hw/mthca/mthca_doorbell.h
index 14f51ef..c139265 100644
--- a/drivers/infiniband/hw/mthca/mthca_doorbell.h
+++ b/drivers/infiniband/hw/mthca/mthca_doorbell.h
@@ -1,6 +1,6 @@
 /*
  * Copyright (c) 2004 Topspin Communications.  All rights reserved.
- * Copyright (c) 2005 Sun Microsystems, Inc. All rights reserved.
+ * Copyright (c) 2005 Oracle and/or its affiliates. All rights reserved.
  * Copyright (c) 2005 Mellanox Technologies. All rights reserved.
  *
  * This software is available to you under a choice of one of two
diff --git a/drivers/infiniband/hw/mthca/mthca_main.c b/drivers/infiniband/hw/mthca/mthca_main.c
index 5eee666..7ff36b0 100644
--- a/drivers/infiniband/hw/mthca/mthca_main.c
+++ b/drivers/infiniband/hw/mthca/mthca_main.c
@@ -1,6 +1,6 @@
 /*
  * Copyright (c) 2004, 2005 Topspin Communications.  All rights reserved.
- * Copyright (c) 2005 Sun Microsystems, Inc. All rights reserved.
+ * Copyright (c) 2005 Oracle and/or its affiliates. All rights reserved.
  * Copyright (c) 2005 Mellanox Technologies. All rights reserved.
  *
  * This software is available to you under a choice of one of two
diff --git a/drivers/infiniband/hw/mthca/mthca_provider.c b/drivers/infiniband/hw/mthca/mthca_provider.c
index 1e0b4b6..7fb8b4f 100644
--- a/drivers/infiniband/hw/mthca/mthca_provider.c
+++ b/drivers/infiniband/hw/mthca/mthca_provider.c
@@ -1,6 +1,6 @@
 /*
  * Copyright (c) 2004, 2005 Topspin Communications.  All rights reserved.
- * Copyright (c) 2005 Sun Microsystems, Inc. All rights reserved.
+ * Copyright (c) 2005 Oracle and/or its affiliates. All rights reserved.
  * Copyright (c) 2005, 2006 Cisco Systems.  All rights reserved.
  * Copyright (c) 2005 Mellanox Technologies. All rights reserved.
  * Copyright (c) 2004 Voltaire, Inc. All rights reserved.
-- 
1.7.1

