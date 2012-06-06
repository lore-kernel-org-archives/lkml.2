Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756109Ab2FFKyt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2012 06:54:49 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:45499 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755945Ab2FFKyr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2012 06:54:47 -0400
From: Sasha Levin <levinsasha928@gmail.com>
To: konrad.wilk@oracle.com, dan.magenheimer@oracle.com
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Sasha Levin <levinsasha928@gmail.com>
Subject: [PATCH 11/11] mm: frontswap: remove unneeded headers
Date: Wed,  6 Jun 2012 12:55:15 +0200
Message-Id: <1338980115-2394-11-git-send-email-levinsasha928@gmail.com>
X-Mailer: git-send-email 1.7.8.6
In-Reply-To: <1338980115-2394-1-git-send-email-levinsasha928@gmail.com>
References: <1338980115-2394-1-git-send-email-levinsasha928@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Sasha Levin <levinsasha928@gmail.com>
---
 mm/frontswap.c |    4 ----
 1 files changed, 0 insertions(+), 4 deletions(-)

diff --git a/mm/frontswap.c b/mm/frontswap.c
index 92e2e7b..2a5d421 100644
--- a/mm/frontswap.c
+++ b/mm/frontswap.c
@@ -12,15 +12,11 @@
  */
 
 #define CREATE_TRACE_POINTS
-#include <linux/mm.h>
 #include <linux/mman.h>
 #include <linux/swap.h>
 #include <linux/swapops.h>
-#include <linux/proc_fs.h>
 #include <linux/security.h>
-#include <linux/capability.h>
 #include <linux/module.h>
-#include <linux/uaccess.h>
 #include <linux/debugfs.h>
 #include <linux/frontswap.h>
 #include <linux/swapfile.h>
-- 
1.7.8.6

