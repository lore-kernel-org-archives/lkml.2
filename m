Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756514Ab2FJKua (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Jun 2012 06:50:30 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:64361 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756472Ab2FJKu1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Jun 2012 06:50:27 -0400
From: Sasha Levin <levinsasha928@gmail.com>
To: dan.magenheimer@oracle.com, konrad.wilk@oracle.com
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Sasha Levin <levinsasha928@gmail.com>
Subject: [PATCH v3 10/10] mm: frontswap: remove unneeded headers
Date: Sun, 10 Jun 2012 12:51:08 +0200
Message-Id: <1339325468-30614-11-git-send-email-levinsasha928@gmail.com>
X-Mailer: git-send-email 1.7.8.6
In-Reply-To: <1339325468-30614-1-git-send-email-levinsasha928@gmail.com>
References: <1339325468-30614-1-git-send-email-levinsasha928@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Sasha Levin <levinsasha928@gmail.com>
---
 mm/frontswap.c |    4 ----
 1 files changed, 0 insertions(+), 4 deletions(-)

diff --git a/mm/frontswap.c b/mm/frontswap.c
index c056f6e..9b667a4 100644
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

