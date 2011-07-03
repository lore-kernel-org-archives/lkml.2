Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754923Ab1GCN6a (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Jul 2011 09:58:30 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:61248 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754403Ab1GCN60 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Jul 2011 09:58:26 -0400
From: Akinobu Mita <akinobu.mita@gmail.com>
To: linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Cc: Akinobu Mita <akinobu.mita@gmail.com>
Subject: [PATCH 1/7] fault-injection: do not include unneeded header
Date: Sun,  3 Jul 2011 22:59:42 +0900
Message-Id: <1309701588-16588-2-git-send-email-akinobu.mita@gmail.com>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1309701588-16588-1-git-send-email-akinobu.mita@gmail.com>
References: <1309701588-16588-1-git-send-email-akinobu.mita@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

No need to include linux/kallsyms.h.

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
---
 lib/fault-inject.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/lib/fault-inject.c b/lib/fault-inject.c
index 7e65af7..e6430e1 100644
--- a/lib/fault-inject.c
+++ b/lib/fault-inject.c
@@ -8,7 +8,6 @@
 #include <linux/module.h>
 #include <linux/interrupt.h>
 #include <linux/stacktrace.h>
-#include <linux/kallsyms.h>
 #include <linux/fault-inject.h>
 
 /*
-- 
1.7.4.4

