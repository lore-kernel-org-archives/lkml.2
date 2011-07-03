Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755359Ab1GCN7n (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Jul 2011 09:59:43 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:37409 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754571Ab1GCN63 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Jul 2011 09:58:29 -0400
From: Akinobu Mita <akinobu.mita@gmail.com>
To: linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Cc: Akinobu Mita <akinobu.mita@gmail.com>
Subject: [PATCH 2/7] fault-injection: remove nonexistent function extern
Date: Sun,  3 Jul 2011 22:59:43 +0900
Message-Id: <1309701588-16588-3-git-send-email-akinobu.mita@gmail.com>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1309701588-16588-1-git-send-email-akinobu.mita@gmail.com>
References: <1309701588-16588-1-git-send-email-akinobu.mita@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

should_fail_srandom() does not exist.

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
---
 include/linux/fault-inject.h |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/include/linux/fault-inject.h b/include/linux/fault-inject.h
index 7b64ad4..7b72328 100644
--- a/include/linux/fault-inject.h
+++ b/include/linux/fault-inject.h
@@ -57,7 +57,6 @@ struct fault_attr {
 
 #define DECLARE_FAULT_ATTR(name) struct fault_attr name = FAULT_ATTR_INITIALIZER
 int setup_fault_attr(struct fault_attr *attr, char *str);
-void should_fail_srandom(unsigned long entropy);
 bool should_fail(struct fault_attr *attr, ssize_t size);
 
 #ifdef CONFIG_FAULT_INJECTION_DEBUG_FS
-- 
1.7.4.4

