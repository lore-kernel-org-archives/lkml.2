Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964983Ab2ERQoN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 May 2012 12:44:13 -0400
Received: from mx1.redhat.com ([209.132.183.28]:57105 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758581Ab2ERQdG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 May 2012 12:33:06 -0400
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
        Linux Edac Mailing List <linux-edac@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH EDAC v26 65/66] edac: Increase version to 3.0.0
Date: Fri, 18 May 2012 13:32:52 -0300
Message-Id: <1337358773-6919-66-git-send-email-mchehab@redhat.com>
In-Reply-To: <1337358773-6919-1-git-send-email-mchehab@redhat.com>
References: <1337358773-6919-1-git-send-email-mchehab@redhat.com>
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There were lots of changes introduced to justify renaming it to
3.0.0:

  - EDAC core were redesigned to represent all types of
    memory controllers;

  - EDAC API were redesigned to properly represent the memory
    controller hierarchy;

  - a tracepoint-based API were added to report memory errors.

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
---
 drivers/edac/edac_module.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/edac/edac_module.c b/drivers/edac/edac_module.c
index cbba80d..3454798 100644
--- a/drivers/edac/edac_module.c
+++ b/drivers/edac/edac_module.c
@@ -15,7 +15,7 @@
 #include "edac_core.h"
 #include "edac_module.h"
 
-#define EDAC_VERSION "Ver: 2.1.0"
+#define EDAC_VERSION "Ver: 3.0.0"
 
 #ifdef CONFIG_EDAC_DEBUG
 /* Values of 0 to 4 will generate output */
-- 
1.7.8

