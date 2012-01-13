Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932598Ab2AMPxm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jan 2012 10:53:42 -0500
Received: from mail-gx0-f174.google.com ([209.85.161.174]:43115 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932583Ab2AMPxj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jan 2012 10:53:39 -0500
From: Akinobu Mita <akinobu.mita@gmail.com>
To: linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Cc: Akinobu Mita <akinobu.mita@gmail.com>,
        Robert Richter <robert.richter@amd.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org
Subject: [PATCH 2/7] bitops: remove for_each_set_bit_cont
Date: Sat, 14 Jan 2012 00:53:19 +0900
Message-Id: <1326470004-10096-3-git-send-email-akinobu.mita@gmail.com>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1326470004-10096-1-git-send-email-akinobu.mita@gmail.com>
References: <1326470004-10096-1-git-send-email-akinobu.mita@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove for_each_set_bit_cont() after confirming that no one uses
for_each_set_bit_cont() anymore.

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Cc: Robert Richter <robert.richter@amd.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: x86@kernel.org
---
 include/linux/bitops.h |    3 ---
 1 files changed, 0 insertions(+), 3 deletions(-)

diff --git a/include/linux/bitops.h b/include/linux/bitops.h
index 9e79b2a..15ad702 100644
--- a/include/linux/bitops.h
+++ b/include/linux/bitops.h
@@ -32,9 +32,6 @@ extern unsigned long __sw_hweight64(__u64 w);
 	     (bit) < (size);					\
 	     (bit) = find_next_bit((addr), (size), (bit) + 1))
 
-#define for_each_set_bit_cont(bit, addr, size) \
-	for_each_set_bit_from(bit, addr, size)
-
 static __inline__ int get_bitmask_order(unsigned int count)
 {
 	int order;
-- 
1.7.4.4

