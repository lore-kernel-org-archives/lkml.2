Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754821Ab1G1FQx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jul 2011 01:16:53 -0400
Received: from mail.windriver.com ([147.11.1.11]:51297 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753703Ab1G1FQd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jul 2011 01:16:33 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: mingo@elte.hu, torvalds@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        linux-arch@vger.kernel.org
Subject: [PATCH 04/11] device_cgroup.h: delete needless include <linux/module.h>
Date: Thu, 28 Jul 2011 01:16:11 -0400
Message-Id: <1311830178-30314-5-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.6
In-Reply-To: <1311830178-30314-1-git-send-email-paul.gortmaker@windriver.com>
References: <1311830178-30314-1-git-send-email-paul.gortmaker@windriver.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There is nothing modular in this file, and no reason to drag
in all the 357 headers that module.h brings with it, since
it just slows down compiles.

Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 include/linux/device_cgroup.h |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/include/linux/device_cgroup.h b/include/linux/device_cgroup.h
index 7aad1f4..8b64221 100644
--- a/include/linux/device_cgroup.h
+++ b/include/linux/device_cgroup.h
@@ -1,4 +1,3 @@
-#include <linux/module.h>
 #include <linux/fs.h>
 
 #ifdef CONFIG_CGROUP_DEVICE
-- 
1.7.6

