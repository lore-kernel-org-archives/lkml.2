Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751713Ab1B0Ege (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Feb 2011 23:36:34 -0500
Received: from mail-iw0-f174.google.com ([209.85.214.174]:60433 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751908Ab1B0Eep (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Feb 2011 23:34:45 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=sdadyIdzEw8Q9X4fODP2Ugo7brUlvroHCRMP8cY5lEJ9yJIlYXWkVeXSzDk7X5XIsp
         t+g8D9KXWOfinPrfW6Oule/P9HWLcb9cufQDh4W+mXisLptWqSwP/6JBkqr/0zgI78+3
         fWJcXmiOvcoNuWuW49sXBfGhZ9l/ZhoIt1v00=
From: "Justin P. Mattock" <justinmattock@gmail.com>
To: trivial@kernel.org
Cc: linux-kernel@vger.kernel.org,
        "Justin P. Mattock" <justinmattock@gmail.com>,
        Greg Kroah-Hartman <gregkh@suse.de>,
        Stephen Hemminger <shemminger@vyatta.com>, devel@driverdev.osuosl.org
Subject: [PATCH 09/17]drivers:staging:bcm:CmHost.c Remove one to many n's in a word.
Date: Sat, 26 Feb 2011 20:34:02 -0800
Message-Id: <1298781250-2718-10-git-send-email-justinmattock@gmail.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1298781250-2718-1-git-send-email-justinmattock@gmail.com>
References: <1298781250-2718-1-git-send-email-justinmattock@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The Patch below removes one to many "n's" in a word..

Signed-off-by: Justin P. Mattock <justinmattock@gmail.com>
CC: Greg Kroah-Hartman <gregkh@suse.de>
CC: Stephen Hemminger <shemminger@vyatta.com>
CC: devel@driverdev.osuosl.org
---
 drivers/staging/bcm/CmHost.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/staging/bcm/CmHost.c b/drivers/staging/bcm/CmHost.c
index 5ac4582..017b471 100644
--- a/drivers/staging/bcm/CmHost.c
+++ b/drivers/staging/bcm/CmHost.c
@@ -1,6 +1,6 @@
 /************************************************************
 *			CMHOST.C
-*	This file contains the routines for handling Connnection
+*	This file contains the routines for handling Connection
 *	Management.
 ************************************************************/
 
-- 
1.7.4.1

