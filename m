Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757405Ab0IBVIh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Sep 2010 17:08:37 -0400
Received: from mail-qw0-f46.google.com ([209.85.216.46]:51682 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757532Ab0IBVIf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Sep 2010 17:08:35 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=LsidO5csM73EmdbVATpINiSzATY//l4b5TodCIC3aiVe4JsltgmHxWdlOxKGbeovCT
         kpjA2Ldpchr73X+xvT1hfGs9umnPP472QGRrB4W8CHJVcw85xWGQZ4I3mipwU6NYoeJE
         iZGDwNmIlmOyI3u1mvrc+LV09hE7ZFX5iDYzw=
From: "Justin P. Mattock" <justinmattock@gmail.com>
To: trivial@kernel.org
Cc: linux-alpha@vger.kernel.org, linux-kernel@vger.kernel.org, jkosina@suse.cz,
        "Justin P. Mattock" <justinmattock@gmail.com>
Subject: [PATCH 30/91] arch/ia64/sn/kernel/sn2/timer_interrupt.c Update broken web addresses in the arch directory.
Date: Thu,  2 Sep 2010 14:07:59 -0700
Message-Id: <1283461679-7851-15-git-send-email-justinmattock@gmail.com>
X-Mailer: git-send-email 1.7.2.1
In-Reply-To: <1283461679-7851-1-git-send-email-justinmattock@gmail.com>
References: <1283461679-7851-1-git-send-email-justinmattock@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The below patch updates a broken web address that is no longer
working due to company buyout, and/or change of location.
(Please have a look through, and let me know if any of them
need to be changed, and I'll resend an updated patch).

Signed-off-by: Justin P. Mattock <justinmattock@gmail.com>

---
 arch/ia64/sn/kernel/sn2/timer_interrupt.c |    4 +---
 1 files changed, 1 insertions(+), 3 deletions(-)

diff --git a/arch/ia64/sn/kernel/sn2/timer_interrupt.c b/arch/ia64/sn/kernel/sn2/timer_interrupt.c
index 103d6ea..9f9d5f2 100644
--- a/arch/ia64/sn/kernel/sn2/timer_interrupt.c
+++ b/arch/ia64/sn/kernel/sn2/timer_interrupt.c
@@ -1,6 +1,4 @@
 /*
- *
- *
  * Copyright (c) 2005, 2006 Silicon Graphics, Inc.  All Rights Reserved.
  * 
  * This program is free software; you can redistribute it and/or modify it 
@@ -24,7 +22,7 @@
  * 
  * For further information regarding this notice, see: 
  * 
- * http://oss.sgi.com/projects/GenInfo/NoticeExplan
+ * http://oss.sgi.com/
  */
 
 #include <linux/interrupt.h>
-- 
1.7.2.1

