Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752431Ab0K0GXH (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Nov 2010 01:23:07 -0500
Received: from mail-gw0-f46.google.com ([74.125.83.46]:60399 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752205Ab0K0GWH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Nov 2010 01:22:07 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=H+hs5l7d3w27fsz4VsFxYF9Iq2N3Zs00YjoKtbWnr/UNMZympHOS0t1Ay9BlJHeWCm
         kH0cy62GwkrqAtEooYT++YJD4nRgxbPp5qlPlZub09nVvCg8i2Mgy4uVrtmBWFyS0rbp
         NB7KQETZby1EgiJQs0rhWzWGqdIrnguSfCRd4=
From: "Justin P. Mattock" <justinmattock@gmail.com>
To: trivial@kernel.org
Cc: linux-rdma@vger.kernel.org, linux-ide@vger.kernel.org,
        linux-mtd@lists.infradead.org, linux-wireless@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        "Justin P. Mattock" <justinmattock@gmail.com>
Subject: [RFC 7/9]drivers:ata Change the copyright info.
Date: Fri, 26 Nov 2010 22:21:17 -0800
Message-Id: <1290838879-11038-8-git-send-email-justinmattock@gmail.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1290838879-11038-1-git-send-email-justinmattock@gmail.com>
References: <1290838879-11038-1-git-send-email-justinmattock@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Change the copyright info from Sun Microsystems to Oracle since Oracle now owns them.

Signed-off-by: Justin P. Mattock <justinmattock@gmail.com>

---
 drivers/ata/pata_hpt366.c      |    2 +-
 drivers/ata/pata_hpt37x.c      |    2 +-
 drivers/ata/pata_hpt3x2n.c     |    2 +-
 drivers/ata/pata_serverworks.c |    2 +-
 4 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/ata/pata_hpt366.c b/drivers/ata/pata_hpt366.c
index 7688868..bd52749 100644
--- a/drivers/ata/pata_hpt366.c
+++ b/drivers/ata/pata_hpt366.c
@@ -6,7 +6,7 @@
  * linux/drivers/ide/pci/hpt366.c		Version 0.36	April 25, 2003
  *
  * Copyright (C) 1999-2003		Andre Hedrick <andre@linux-ide.org>
- * Portions Copyright (C) 2001	        Sun Microsystems, Inc.
+ * Portions Copyright (C) 2001	        Oracle and/or its affiliates. 
  * Portions Copyright (C) 2003		Red Hat Inc
  *
  *
diff --git a/drivers/ata/pata_hpt37x.c b/drivers/ata/pata_hpt37x.c
index 9ae4c08..442575e 100644
--- a/drivers/ata/pata_hpt37x.c
+++ b/drivers/ata/pata_hpt37x.c
@@ -6,7 +6,7 @@
  * linux/drivers/ide/pci/hpt366.c		Version 0.36	April 25, 2003
  *
  * Copyright (C) 1999-2003		Andre Hedrick <andre@linux-ide.org>
- * Portions Copyright (C) 2001	        Sun Microsystems, Inc.
+ * Portions Copyright (C) 2001	        Oracle and/or its affiliates. 
  * Portions Copyright (C) 2003		Red Hat Inc
  * Portions Copyright (C) 2005-2009	MontaVista Software, Inc.
  *
diff --git a/drivers/ata/pata_hpt3x2n.c b/drivers/ata/pata_hpt3x2n.c
index 32f3463..d0780c8 100644
--- a/drivers/ata/pata_hpt3x2n.c
+++ b/drivers/ata/pata_hpt3x2n.c
@@ -6,7 +6,7 @@
  * linux/drivers/ide/pci/hpt366.c		Version 0.36	April 25, 2003
  *
  * Copyright (C) 1999-2003		Andre Hedrick <andre@linux-ide.org>
- * Portions Copyright (C) 2001	        Sun Microsystems, Inc.
+ * Portions Copyright (C) 2001	        Oracle and/or its affiliates. 
  * Portions Copyright (C) 2003		Red Hat Inc
  * Portions Copyright (C) 2005-2009	MontaVista Software, Inc.
  *
diff --git a/drivers/ata/pata_serverworks.c b/drivers/ata/pata_serverworks.c
index 86dd714..a8dd665 100644
--- a/drivers/ata/pata_serverworks.c
+++ b/drivers/ata/pata_serverworks.c
@@ -10,7 +10,7 @@
  * Copyright (C) 1998-2000 Michel Aubry
  * Copyright (C) 1998-2000 Andrzej Krzysztofowicz
  * Copyright (C) 1998-2000 Andre Hedrick <andre@linux-ide.org>
- * Portions copyright (c) 2001 Sun Microsystems
+ * Portions copyright (c) 2001 Oracle and/or its affiliates. 
  *
  *
  * RCC/ServerWorks IDE driver for Linux
-- 
1.7.1

