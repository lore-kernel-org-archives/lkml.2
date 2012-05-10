Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761165Ab2EJT5s (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2012 15:57:48 -0400
Received: from mx1.redhat.com ([209.132.183.28]:20892 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755736Ab2EJT5q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2012 15:57:46 -0400
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
        Linux Edac Mailing List <linux-edac@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH] edac: Increase version to 3.0.0 (aka: "HERM" version)
Date: Thu, 10 May 2012 16:57:40 -0300
Message-Id: <1336679860-5340-1-git-send-email-mchehab@redhat.com>
In-Reply-To: <4FABDBE6.3060901@redhat.com>
References: <4FABDBE6.3060901@redhat.com>
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There were lots of changes introduced to justify renaming it to
3.0.0 (HERM - Hardware Events Report Method):

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

