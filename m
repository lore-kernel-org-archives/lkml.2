Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752541Ab0K0GXg (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Nov 2010 01:23:36 -0500
Received: from mail-gw0-f46.google.com ([74.125.83.46]:60399 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752028Ab0K0GWB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Nov 2010 01:22:01 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=Vxi72zxfw0allpTkq/3Af/9r0ln4g6+KRW2uqqoogpddDCkLEXlP2LU/JkHpoMoicV
         fmXo0aCjuvSQ5T7LUf2t4E4T81fgCJ8ucgp5tstBYHMYjYBqUPmSqThFakX/NDtcYWxf
         5X2aJFowN1t4yp5xRE6E7fLNlVKdwLtLzfA6w=
From: "Justin P. Mattock" <justinmattock@gmail.com>
To: trivial@kernel.org
Cc: linux-rdma@vger.kernel.org, linux-ide@vger.kernel.org,
        linux-mtd@lists.infradead.org, linux-wireless@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        "Justin P. Mattock" <justinmattock@gmail.com>
Subject: [RFC 5/9]drivers:mtd:maps Change the copyright info.
Date: Fri, 26 Nov 2010 22:21:15 -0800
Message-Id: <1290838879-11038-6-git-send-email-justinmattock@gmail.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1290838879-11038-1-git-send-email-justinmattock@gmail.com>
References: <1290838879-11038-1-git-send-email-justinmattock@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Change the copyright info from Sun Microsystems to Oracle since Oracle now owns them.

Signed-off-by: Justin P. Mattock <justinmattock@gmail.com>

---
 drivers/mtd/maps/scb2_flash.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/mtd/maps/scb2_flash.c b/drivers/mtd/maps/scb2_flash.c
index 7e329f0..9841bb2 100644
--- a/drivers/mtd/maps/scb2_flash.c
+++ b/drivers/mtd/maps/scb2_flash.c
@@ -1,6 +1,6 @@
 /*
  * MTD map driver for BIOS Flash on Intel SCB2 boards
- * Copyright (C) 2002 Sun Microsystems, Inc.
+ * Copyright (C) 2002 Oracle and/or its affiliates. 
  * Tim Hockin <thockin@sun.com>
  *
  * A few notes on this MTD map:
-- 
1.7.1

