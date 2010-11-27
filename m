Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752357Ab0K0GWM (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Nov 2010 01:22:12 -0500
Received: from mail-gx0-f174.google.com ([209.85.161.174]:43979 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751039Ab0K0GV6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Nov 2010 01:21:58 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=uRjiFr/NDUZJ3jkz8wO1MbH7lEJm1IqicpW2qfb12wdNRr2nfY3irBMGQdwvJVJ4MK
         Esy+Wi7KzBgpDMqahIIxhFyUA3NSlhia0WtpJ+8SI6zgtE6m7M9bhL9gfyOE8qE4ueKh
         jw6t9N+VBf2fqGqbhohiDyZJjLaCBnrTTDryE=
From: "Justin P. Mattock" <justinmattock@gmail.com>
To: trivial@kernel.org
Cc: linux-rdma@vger.kernel.org, linux-ide@vger.kernel.org,
        linux-mtd@lists.infradead.org, linux-wireless@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        "Justin P. Mattock" <justinmattock@gmail.com>
Subject: [RFC 4/9]drivers:ide Change the copyright info.
Date: Fri, 26 Nov 2010 22:21:14 -0800
Message-Id: <1290838879-11038-5-git-send-email-justinmattock@gmail.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1290838879-11038-1-git-send-email-justinmattock@gmail.com>
References: <1290838879-11038-1-git-send-email-justinmattock@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Change the copyright info from Sun Microsystems to Oracle since Oracle now owns them.

Signed-off-by: Justin P. Mattock <justinmattock@gmail.com>

---
 drivers/ide/hpt366.c      |    2 +-
 drivers/ide/serverworks.c |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/ide/hpt366.c b/drivers/ide/hpt366.c
index 58c51cd..8e31cfa 100644
--- a/drivers/ide/hpt366.c
+++ b/drivers/ide/hpt366.c
@@ -1,6 +1,6 @@
 /*
  * Copyright (C) 1999-2003		Andre Hedrick <andre@linux-ide.org>
- * Portions Copyright (C) 2001	        Sun Microsystems, Inc.
+ * Portions Copyright (C) 2001	        Oracle and/or its affiliates. 
  * Portions Copyright (C) 2003		Red Hat Inc
  * Portions Copyright (C) 2007		Bartlomiej Zolnierkiewicz
  * Portions Copyright (C) 2005-2009	MontaVista Software, Inc.
diff --git a/drivers/ide/serverworks.c b/drivers/ide/serverworks.c
index 35fb8da..267c87e 100644
--- a/drivers/ide/serverworks.c
+++ b/drivers/ide/serverworks.c
@@ -3,7 +3,7 @@
  * Copyright (C) 1998-2000 Andrzej Krzysztofowicz
  * Copyright (C) 1998-2000 Andre Hedrick <andre@linux-ide.org>
  * Copyright (C) 2007-2010 Bartlomiej Zolnierkiewicz
- * Portions copyright (c) 2001 Sun Microsystems
+ * Portions copyright (c) 2001 Oracle and/or its affiliates. 
  *
  *
  * RCC/ServerWorks IDE driver for Linux
-- 
1.7.1

