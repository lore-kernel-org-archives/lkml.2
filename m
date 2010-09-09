Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756393Ab0IIWYq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Sep 2010 18:24:46 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:38003 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756359Ab0IIWYn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Sep 2010 18:24:43 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=Qpp4aIH6ujc72tWm/0gv7ciuw6VsY6rbSDbsD4sgnTzFK6H7yJXzc7VmVPbP8Kr3nJ
         QztfwmiSIwXd0j051OEZq1/5MwPD44bIzu5Mqe28vcKwQFR3Qc+axczkTS//SuMqU7Ia
         93bBhzY5EmHCzMQ5fDDsyjcjZvwH5nRSDkFMA=
From: "Justin P. Mattock" <justinmattock@gmail.com>
To: trivial@kernel.org
Cc: linux-kernel@vger.kernel.org,
        "Justin P. Mattock" <justinmattock@gmail.com>
Subject: [PATCH 007/223]drivers/char/apm-emulation.c Update broken web addresses.
Date: Thu,  9 Sep 2010 15:24:43 -0700
Message-Id: <1284071091-7676-8-git-send-email-justinmattock@gmail.com>
X-Mailer: git-send-email 1.7.2.1
In-Reply-To: <1284071091-7676-1-git-send-email-justinmattock@gmail.com>
References: <1284071091-7676-1-git-send-email-justinmattock@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Below you will find an Update to a broken web address.
Please let me know if this needs to be changed.

Signed-off-by: Justin P. Mattock <justinmattock@gmail.com>

---
 drivers/char/apm-emulation.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/char/apm-emulation.c b/drivers/char/apm-emulation.c
index 033e150..d7d9a78 100644
--- a/drivers/char/apm-emulation.c
+++ b/drivers/char/apm-emulation.c
@@ -8,7 +8,7 @@
  *   (APM) BIOS Interface Specification, Revision 1.2, February 1996.
  *
  * [This document is available from Microsoft at:
- *    http://www.microsoft.com/hwdev/busbios/amp_12.htm]
+ *    http://www.microsoft.com/whdc/archive/amp_12.mspx]
  */
 #include <linux/module.h>
 #include <linux/poll.h>
-- 
1.7.2.1

