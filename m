Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758451Ab2IEK7W (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Sep 2012 06:59:22 -0400
Received: from terminus.zytor.com ([198.137.202.10]:56354 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751864Ab2IEK7V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Sep 2012 06:59:21 -0400
Date: Wed, 5 Sep 2012 03:59:09 -0700
From: tip-bot for Mathias Krause <minipli@googlemail.com>
Message-ID: <tip-2b11afd1ab502d959ae8d6d5812923151b5bc505@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        joerg.roedel@amd.com, minipli@googlemail.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        joerg.roedel@amd.com, minipli@googlemail.com, tglx@linutronix.de
In-Reply-To: <1346621506-30857-7-git-send-email-minipli@googlemail.com>
References: <1346621506-30857-7-git-send-email-minipli@googlemail.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/debug] x86/iommu: Drop duplicate const in __IOMMU_INIT
Git-Commit-ID: 2b11afd1ab502d959ae8d6d5812923151b5bc505
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Wed, 05 Sep 2012 03:59:14 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  2b11afd1ab502d959ae8d6d5812923151b5bc505
Gitweb:     http://git.kernel.org/tip/2b11afd1ab502d959ae8d6d5812923151b5bc505
Author:     Mathias Krause <minipli@googlemail.com>
AuthorDate: Sun, 2 Sep 2012 23:31:45 +0200
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Wed, 5 Sep 2012 10:52:26 +0200

x86/iommu: Drop duplicate const in __IOMMU_INIT

It's redundant and makes sparse complain about it.

Signed-off-by: Mathias Krause <minipli@googlemail.com>
Cc: Joerg Roedel <joerg.roedel@amd.com>
Link: http://lkml.kernel.org/r/1346621506-30857-7-git-send-email-minipli@googlemail.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 arch/x86/include/asm/iommu_table.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/include/asm/iommu_table.h b/arch/x86/include/asm/iommu_table.h
index f229b13..bbf8fb2 100644
--- a/arch/x86/include/asm/iommu_table.h
+++ b/arch/x86/include/asm/iommu_table.h
@@ -48,7 +48,7 @@ struct iommu_table_entry {
 
 
 #define __IOMMU_INIT(_detect, _depend, _early_init, _late_init, _finish)\
-	static const struct iommu_table_entry const			\
+	static const struct iommu_table_entry				\
 		__iommu_entry_##_detect __used				\
 	__attribute__ ((unused, __section__(".iommu_table"),		\
 			aligned((sizeof(void *)))))	\
