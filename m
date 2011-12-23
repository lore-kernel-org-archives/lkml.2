Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757414Ab1LWQIw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Dec 2011 11:08:52 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:51926 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751764Ab1LWQIt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Dec 2011 11:08:49 -0500
From: Adam Jiang <jiang.adam@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Chao Jiang <chaoj@nvidia.com>
Subject: [PATCH] mtd: Added missing BUILD_BUG_ON definition
Date: Sat, 24 Dec 2011 01:08:42 +0900
Message-Id: <1324656522-7140-1-git-send-email-jiang.adam@gmail.com>
X-Mailer: git-send-email 1.7.8.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Chao Jiang <chaoj@nvidia.com>

Signed-off-by: Chao Jiang <chaoj@nvidia.com>
---
 include/linux/mtd/map.h |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/include/linux/mtd/map.h b/include/linux/mtd/map.h
index a9e6ba4..fc8d64a 100644
--- a/include/linux/mtd/map.h
+++ b/include/linux/mtd/map.h
@@ -22,6 +22,7 @@
 #ifndef __LINUX_MTD_MAP_H__
 #define __LINUX_MTD_MAP_H__
 
+#include <linux/kernel.h>
 #include <linux/types.h>
 #include <linux/list.h>
 #include <linux/string.h>
-- 
1.7.8

