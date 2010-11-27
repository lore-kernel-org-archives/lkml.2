Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752616Ab0K0GWr (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Nov 2010 01:22:47 -0500
Received: from mail-gx0-f174.google.com ([209.85.161.174]:43979 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752322Ab0K0GWL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Nov 2010 01:22:11 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=hM8Nhox9+Z9mdpIdGLvkOWwpZoJwQFLp5/2xvGqvLz0NJJ2yZolbZ2fi3YRTA09anv
         3fB5vBhZIE5JdRqlu3DrpjnU4VxK+i49x8PHkr/VKOFC18DF1a0bissuEx/jyxnKlY7r
         EFA7BfeyilrWghzfPSKtStiu5ATFHoPAmgb58=
From: "Justin P. Mattock" <justinmattock@gmail.com>
To: trivial@kernel.org
Cc: linux-rdma@vger.kernel.org, linux-ide@vger.kernel.org,
        linux-mtd@lists.infradead.org, linux-wireless@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        "Justin P. Mattock" <justinmattock@gmail.com>
Subject: [RFC 8/9]drivers:net Change the copyright info.
Date: Fri, 26 Nov 2010 22:21:18 -0800
Message-Id: <1290838879-11038-9-git-send-email-justinmattock@gmail.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1290838879-11038-1-git-send-email-justinmattock@gmail.com>
References: <1290838879-11038-1-git-send-email-justinmattock@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Change the copyright info from Sun Microsystems to Oracle since Oracle now owns them.

Signed-off-by: Justin P. Mattock <justinmattock@gmail.com>

---
 drivers/net/cassini.c   |    2 +-
 drivers/net/cassini.h   |    4 ++--
 drivers/net/mlx4/cq.c   |    2 +-
 drivers/net/mlx4/main.c |    2 +-
 drivers/net/mlx4/mlx4.h |    2 +-
 drivers/net/natsemi.c   |    2 +-
 drivers/net/tg3.c       |    2 +-
 drivers/net/tg3.h       |    2 +-
 8 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/drivers/net/cassini.c b/drivers/net/cassini.c
index d6b6d6a..f09f544 100644
--- a/drivers/net/cassini.c
+++ b/drivers/net/cassini.c
@@ -1,6 +1,6 @@
 /* cassini.c: Sun Microsystems Cassini(+) ethernet driver.
  *
- * Copyright (C) 2004 Sun Microsystems Inc.
+ * Copyright (C) 2004 Oracle and/or its affiliates. 
  * Copyright (C) 2003 Adrian Sun (asun@darksunrising.com)
  *
  * This program is free software; you can redistribute it and/or
diff --git a/drivers/net/cassini.h b/drivers/net/cassini.h
index dbc4787..30c760c 100644
--- a/drivers/net/cassini.h
+++ b/drivers/net/cassini.h
@@ -1,7 +1,7 @@
 /* $Id: cassini.h,v 1.16 2004/08/17 21:15:16 zaumen Exp $
  * cassini.h: Definitions for Sun Microsystems Cassini(+) ethernet driver.
  *
- * Copyright (C) 2004 Sun Microsystems Inc.
+ * Copyright (C) 2004 Oracle and/or its affiliates. 
  * Copyright (c) 2003 Adrian Sun (asun@darksunrising.com)
  *
  * This program is free software; you can redistribute it and/or
@@ -19,7 +19,7 @@
  * Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA
  * 02111-1307, USA.
  *
- * vendor id: 0x108E (Sun Microsystems, Inc.)
+ * vendor id: 0x108E (Oracle and/or its affiliates.)
  * device id: 0xabba (Cassini)
  * revision ids: 0x01 = Cassini
  *               0x02 = Cassini rev 2
diff --git a/drivers/net/mlx4/cq.c b/drivers/net/mlx4/cq.c
index 7cd34e9..d730de4 100644
--- a/drivers/net/mlx4/cq.c
+++ b/drivers/net/mlx4/cq.c
@@ -1,6 +1,6 @@
 /*
  * Copyright (c) 2004, 2005 Topspin Communications.  All rights reserved.
- * Copyright (c) 2005 Sun Microsystems, Inc. All rights reserved.
+ * Copyright (c) 2005 Oracle and/or its affiliates. All rights reserved.
  * Copyright (c) 2005, 2006, 2007 Cisco Systems, Inc. All rights reserved.
  * Copyright (c) 2005, 2006, 2007, 2008 Mellanox Technologies. All rights reserved.
  * Copyright (c) 2004 Voltaire, Inc. All rights reserved.
diff --git a/drivers/net/mlx4/main.c b/drivers/net/mlx4/main.c
index 782f11d..4e711e3 100644
--- a/drivers/net/mlx4/main.c
+++ b/drivers/net/mlx4/main.c
@@ -1,6 +1,6 @@
 /*
  * Copyright (c) 2004, 2005 Topspin Communications.  All rights reserved.
- * Copyright (c) 2005 Sun Microsystems, Inc. All rights reserved.
+ * Copyright (c) 2005 Oracle and/or its affiliates. All rights reserved.
  * Copyright (c) 2005, 2006, 2007, 2008 Mellanox Technologies. All rights reserved.
  * Copyright (c) 2006, 2007 Cisco Systems, Inc. All rights reserved.
  *
diff --git a/drivers/net/mlx4/mlx4.h b/drivers/net/mlx4/mlx4.h
index 0da5bb7..4fc154c 100644
--- a/drivers/net/mlx4/mlx4.h
+++ b/drivers/net/mlx4/mlx4.h
@@ -1,6 +1,6 @@
 /*
  * Copyright (c) 2004, 2005 Topspin Communications.  All rights reserved.
- * Copyright (c) 2005 Sun Microsystems, Inc. All rights reserved.
+ * Copyright (c) 2005 Oracle and/or its affiliates. All rights reserved.
  * Copyright (c) 2005, 2006, 2007 Cisco Systems.  All rights reserved.
  * Copyright (c) 2005, 2006, 2007, 2008 Mellanox Technologies. All rights reserved.
  * Copyright (c) 2004 Voltaire, Inc. All rights reserved.
diff --git a/drivers/net/natsemi.c b/drivers/net/natsemi.c
index 2fd3963..406f43a 100644
--- a/drivers/net/natsemi.c
+++ b/drivers/net/natsemi.c
@@ -1,7 +1,7 @@
 /* natsemi.c: A Linux PCI Ethernet driver for the NatSemi DP8381x series. */
 /*
 	Written/copyright 1999-2001 by Donald Becker.
-	Portions copyright (c) 2001,2002 Sun Microsystems (thockin@sun.com)
+	Portions copyright (c) 2001,2002 Oracle and/or its affiliates. (thockin@sun.com)
 	Portions copyright 2001,2002 Manfred Spraul (manfred@colorfullife.com)
 	Portions copyright 2004 Harald Welte <laforge@gnumonks.org>
 
diff --git a/drivers/net/tg3.c b/drivers/net/tg3.c
index 30ccbb6..337850a 100644
--- a/drivers/net/tg3.c
+++ b/drivers/net/tg3.c
@@ -3,7 +3,7 @@
  *
  * Copyright (C) 2001, 2002, 2003, 2004 David S. Miller (davem@redhat.com)
  * Copyright (C) 2001, 2002, 2003 Jeff Garzik (jgarzik@pobox.com)
- * Copyright (C) 2004 Sun Microsystems Inc.
+ * Copyright (C) 2004 Oracle and/or its affiliates. 
  * Copyright (C) 2005-2010 Broadcom Corporation.
  *
  * Firmware is:
diff --git a/drivers/net/tg3.h b/drivers/net/tg3.h
index 4a19748..f8d7210 100644
--- a/drivers/net/tg3.h
+++ b/drivers/net/tg3.h
@@ -3,7 +3,7 @@
  *
  * Copyright (C) 2001, 2002, 2003, 2004 David S. Miller (davem@redhat.com)
  * Copyright (C) 2001 Jeff Garzik (jgarzik@pobox.com)
- * Copyright (C) 2004 Sun Microsystems Inc.
+ * Copyright (C) 2004 Oracle and/or its affiliates. 
  * Copyright (C) 2007-2010 Broadcom Corporation.
  */
 
-- 
1.7.1

