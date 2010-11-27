Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752122Ab0K0GWC (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Nov 2010 01:22:02 -0500
Received: from mail-gy0-f174.google.com ([209.85.160.174]:54639 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751223Ab0K0GVm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Nov 2010 01:21:42 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=s2Qgn+uS5h4aAbxGKHaOPoHBJ1Y7YBoimH+ZP6WtQYZ0ClhO6Kcx09QLlrED5HPCbk
         OqzYBPjvfJUeLz10yl7T9lRYzf0xwzQQsHug861Xh0HjvaYnC9/dFOz5dvqDL1DLHLKP
         tqXs8ulFfPw3mhmoBY/WJ29sillBL72OMXx4I=
From: "Justin P. Mattock" <justinmattock@gmail.com>
To: trivial@kernel.org
Cc: linux-rdma@vger.kernel.org, linux-ide@vger.kernel.org,
        linux-mtd@lists.infradead.org, linux-wireless@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        "Justin P. Mattock" <justinmattock@gmail.com>
Subject: [RFC 2/9]drivers:infiniband:core Change the copyright info.
Date: Fri, 26 Nov 2010 22:21:12 -0800
Message-Id: <1290838879-11038-3-git-send-email-justinmattock@gmail.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1290838879-11038-1-git-send-email-justinmattock@gmail.com>
References: <1290838879-11038-1-git-send-email-justinmattock@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Change the copyright info from Sun Microsystems to Oracle since Oracle now owns them.

Signed-off-by: Justin P. Mattock <justinmattock@gmail.com>

---
 drivers/infiniband/core/agent.c     |    2 +-
 drivers/infiniband/core/cache.c     |    2 +-
 drivers/infiniband/core/cm.c        |    2 +-
 drivers/infiniband/core/device.c    |    2 +-
 drivers/infiniband/core/fmr_pool.c  |    2 +-
 drivers/infiniband/core/iwcm.c      |    2 +-
 drivers/infiniband/core/mad_priv.h  |    2 +-
 drivers/infiniband/core/packer.c    |    2 +-
 drivers/infiniband/core/smi.c       |    2 +-
 drivers/infiniband/core/sysfs.c     |    2 +-
 drivers/infiniband/core/ud_header.c |    2 +-
 drivers/infiniband/core/user_mad.c  |    2 +-
 drivers/infiniband/core/verbs.c     |    2 +-
 13 files changed, 13 insertions(+), 13 deletions(-)

diff --git a/drivers/infiniband/core/agent.c b/drivers/infiniband/core/agent.c
index 91916a8..5152553 100644
--- a/drivers/infiniband/core/agent.c
+++ b/drivers/infiniband/core/agent.c
@@ -4,7 +4,7 @@
  * Copyright (c) 2004, 2005 Intel Corporation.  All rights reserved.
  * Copyright (c) 2004, 2005 Topspin Corporation.  All rights reserved.
  * Copyright (c) 2004-2007 Voltaire Corporation.  All rights reserved.
- * Copyright (c) 2005 Sun Microsystems, Inc. All rights reserved.
+ * Copyright (c) 2005 Oracle and/or its affiliates. All rights reserved.
  *
  * This software is available to you under a choice of one of two
  * licenses.  You may choose to be licensed under the terms of the GNU
diff --git a/drivers/infiniband/core/cache.c b/drivers/infiniband/core/cache.c
index 6888356..dcf17a1 100644
--- a/drivers/infiniband/core/cache.c
+++ b/drivers/infiniband/core/cache.c
@@ -1,7 +1,7 @@
 /*
  * Copyright (c) 2004 Topspin Communications.  All rights reserved.
  * Copyright (c) 2005 Intel Corporation. All rights reserved.
- * Copyright (c) 2005 Sun Microsystems, Inc. All rights reserved.
+ * Copyright (c) 2005 Oracle and/or its affiliates. All rights reserved.
  * Copyright (c) 2005 Voltaire, Inc. All rights reserved.
  *
  * This software is available to you under a choice of one of two
diff --git a/drivers/infiniband/core/cm.c b/drivers/infiniband/core/cm.c
index 64e0903..d0f37d5 100644
--- a/drivers/infiniband/core/cm.c
+++ b/drivers/infiniband/core/cm.c
@@ -2,7 +2,7 @@
  * Copyright (c) 2004-2007 Intel Corporation.  All rights reserved.
  * Copyright (c) 2004 Topspin Corporation.  All rights reserved.
  * Copyright (c) 2004, 2005 Voltaire Corporation.  All rights reserved.
- * Copyright (c) 2005 Sun Microsystems, Inc. All rights reserved.
+ * Copyright (c) 2005 Oracle and/or its affiliates. All rights reserved.
  *
  * This software is available to you under a choice of one of two
  * licenses.  You may choose to be licensed under the terms of the GNU
diff --git a/drivers/infiniband/core/device.c b/drivers/infiniband/core/device.c
index a19effa..73cab4c 100644
--- a/drivers/infiniband/core/device.c
+++ b/drivers/infiniband/core/device.c
@@ -1,6 +1,6 @@
 /*
  * Copyright (c) 2004 Topspin Communications.  All rights reserved.
- * Copyright (c) 2005 Sun Microsystems, Inc. All rights reserved.
+ * Copyright (c) 2005 Oracle and/or its affiliates. All rights reserved.
  *
  * This software is available to you under a choice of one of two
  * licenses.  You may choose to be licensed under the terms of the GNU
diff --git a/drivers/infiniband/core/fmr_pool.c b/drivers/infiniband/core/fmr_pool.c
index 4507043..44eac01 100644
--- a/drivers/infiniband/core/fmr_pool.c
+++ b/drivers/infiniband/core/fmr_pool.c
@@ -1,6 +1,6 @@
 /*
  * Copyright (c) 2004 Topspin Communications.  All rights reserved.
- * Copyright (c) 2005 Sun Microsystems, Inc. All rights reserved.
+ * Copyright (c) 2005 Oracle and/or its affiliates. All rights reserved.
  *
  * This software is available to you under a choice of one of two
  * licenses.  You may choose to be licensed under the terms of the GNU
diff --git a/drivers/infiniband/core/iwcm.c b/drivers/infiniband/core/iwcm.c
index 2a1e9ae..8cc6f01 100644
--- a/drivers/infiniband/core/iwcm.c
+++ b/drivers/infiniband/core/iwcm.c
@@ -2,7 +2,7 @@
  * Copyright (c) 2004, 2005 Intel Corporation.  All rights reserved.
  * Copyright (c) 2004 Topspin Corporation.  All rights reserved.
  * Copyright (c) 2004, 2005 Voltaire Corporation.  All rights reserved.
- * Copyright (c) 2005 Sun Microsystems, Inc. All rights reserved.
+ * Copyright (c) 2005 Oracle and/or its affiliates. All rights reserved.
  * Copyright (c) 2005 Open Grid Computing, Inc. All rights reserved.
  * Copyright (c) 2005 Network Appliance, Inc. All rights reserved.
  *
diff --git a/drivers/infiniband/core/mad_priv.h b/drivers/infiniband/core/mad_priv.h
index 9430ab4..ec30aea 100644
--- a/drivers/infiniband/core/mad_priv.h
+++ b/drivers/infiniband/core/mad_priv.h
@@ -1,7 +1,7 @@
 /*
  * Copyright (c) 2004, 2005, Voltaire, Inc. All rights reserved.
  * Copyright (c) 2005 Intel Corporation. All rights reserved.
- * Copyright (c) 2005 Sun Microsystems, Inc. All rights reserved.
+ * Copyright (c) 2005 Oracle and/or its affiliates. All rights reserved.
  * Copyright (c) 2009 HNR Consulting. All rights reserved.
  *
  * This software is available to you under a choice of one of two
diff --git a/drivers/infiniband/core/packer.c b/drivers/infiniband/core/packer.c
index 019bd4b..32754d2 100644
--- a/drivers/infiniband/core/packer.c
+++ b/drivers/infiniband/core/packer.c
@@ -1,6 +1,6 @@
 /*
  * Copyright (c) 2004 Topspin Corporation.  All rights reserved.
- * Copyright (c) 2005 Sun Microsystems, Inc. All rights reserved.
+ * Copyright (c) 2005 Oracle and/or its affiliates. All rights reserved.
  *
  * This software is available to you under a choice of one of two
  * licenses.  You may choose to be licensed under the terms of the GNU
diff --git a/drivers/infiniband/core/smi.c b/drivers/infiniband/core/smi.c
index 5855e44..9687b80 100644
--- a/drivers/infiniband/core/smi.c
+++ b/drivers/infiniband/core/smi.c
@@ -4,7 +4,7 @@
  * Copyright (c) 2004, 2005 Intel Corporation.  All rights reserved.
  * Copyright (c) 2004, 2005 Topspin Corporation.  All rights reserved.
  * Copyright (c) 2004-2007 Voltaire Corporation.  All rights reserved.
- * Copyright (c) 2005 Sun Microsystems, Inc. All rights reserved.
+ * Copyright (c) 2005 Oracle and/or its affiliates. All rights reserved.
  *
  * This software is available to you under a choice of one of two
  * licenses.  You may choose to be licensed under the terms of the GNU
diff --git a/drivers/infiniband/core/sysfs.c b/drivers/infiniband/core/sysfs.c
index 9ab5df7..010ea2d 100644
--- a/drivers/infiniband/core/sysfs.c
+++ b/drivers/infiniband/core/sysfs.c
@@ -1,7 +1,7 @@
 /*
  * Copyright (c) 2004, 2005 Topspin Communications.  All rights reserved.
  * Copyright (c) 2005 Mellanox Technologies Ltd.  All rights reserved.
- * Copyright (c) 2005 Sun Microsystems, Inc. All rights reserved.
+ * Copyright (c) 2005 Oracle and/or its affiliates. All rights reserved.
  *
  * This software is available to you under a choice of one of two
  * licenses.  You may choose to be licensed under the terms of the GNU
diff --git a/drivers/infiniband/core/ud_header.c b/drivers/infiniband/core/ud_header.c
index bb7e192..50f7b56 100644
--- a/drivers/infiniband/core/ud_header.c
+++ b/drivers/infiniband/core/ud_header.c
@@ -1,6 +1,6 @@
 /*
  * Copyright (c) 2004 Topspin Corporation.  All rights reserved.
- * Copyright (c) 2005 Sun Microsystems, Inc. All rights reserved.
+ * Copyright (c) 2005 Oracle and/or its affiliates. All rights reserved.
  *
  * This software is available to you under a choice of one of two
  * licenses.  You may choose to be licensed under the terms of the GNU
diff --git a/drivers/infiniband/core/user_mad.c b/drivers/infiniband/core/user_mad.c
index cd1996d..5ec2937 100644
--- a/drivers/infiniband/core/user_mad.c
+++ b/drivers/infiniband/core/user_mad.c
@@ -1,7 +1,7 @@
 /*
  * Copyright (c) 2004 Topspin Communications.  All rights reserved.
  * Copyright (c) 2005 Voltaire, Inc. All rights reserved.
- * Copyright (c) 2005 Sun Microsystems, Inc. All rights reserved.
+ * Copyright (c) 2005 Oracle and/or its affiliates. All rights reserved.
  * Copyright (c) 2008 Cisco. All rights reserved.
  *
  * This software is available to you under a choice of one of two
diff --git a/drivers/infiniband/core/verbs.c b/drivers/infiniband/core/verbs.c
index af7a8b0..02d9581 100644
--- a/drivers/infiniband/core/verbs.c
+++ b/drivers/infiniband/core/verbs.c
@@ -4,7 +4,7 @@
  * Copyright (c) 2004 Intel Corporation.  All rights reserved.
  * Copyright (c) 2004 Topspin Corporation.  All rights reserved.
  * Copyright (c) 2004 Voltaire Corporation.  All rights reserved.
- * Copyright (c) 2005 Sun Microsystems, Inc. All rights reserved.
+ * Copyright (c) 2005 Oracle and/or its affiliates. All rights reserved.
  * Copyright (c) 2005, 2006 Cisco Systems.  All rights reserved.
  *
  * This software is available to you under a choice of one of two
-- 
1.7.1

