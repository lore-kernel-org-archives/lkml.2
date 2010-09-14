Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753748Ab0INEYt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Sep 2010 00:24:49 -0400
Received: from mail.perches.com ([173.55.12.10]:1992 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752010Ab0INEYO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Sep 2010 00:24:14 -0400
From: Joe Perches <joe@perches.com>
To: linux-kernel@vger.kernel.org
Cc: Karsten Keil <isdn@linux-pingi.de>, netdev@vger.kernel.org
Subject: [PATCH next 06/16] drivers/isdn: Use static const char * const where possible
Date: Mon, 13 Sep 2010 21:23:52 -0700
Message-Id: <9a19051e63b3f6c857b08ccd1e0876c604713575.1284435709.git.joe@perches.com>
X-Mailer: git-send-email 1.7.3.rc1
In-Reply-To: <cover.1284435709.git.joe@perches.com>
References: <cover.1284435709.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/isdn/pcbit/edss1.c |    2 +-
 drivers/isdn/pcbit/edss1.h |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/isdn/pcbit/edss1.c b/drivers/isdn/pcbit/edss1.c
index d5920ae..80c9c16 100644
--- a/drivers/isdn/pcbit/edss1.c
+++ b/drivers/isdn/pcbit/edss1.c
@@ -33,7 +33,7 @@
 #include "callbacks.h"
 
 
-char * isdn_state_table[] = {
+const char * const isdn_state_table[] = {
   "Closed",
   "Call initiated",
   "Overlap sending",
diff --git a/drivers/isdn/pcbit/edss1.h b/drivers/isdn/pcbit/edss1.h
index 0b64f97..39f8346 100644
--- a/drivers/isdn/pcbit/edss1.h
+++ b/drivers/isdn/pcbit/edss1.h
@@ -90,7 +90,7 @@ struct fsm_timer_entry {
 	unsigned long timeout;          /* in seconds */
 };
 
-extern char * isdn_state_table[];
+extern const char * const isdn_state_table[];
 
 void pcbit_fsm_event(struct pcbit_dev *, struct pcbit_chan *,
 		     unsigned short event, struct callb_data *);
-- 
1.7.3.rc1

