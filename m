Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754897Ab0IWWrw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Sep 2010 18:47:52 -0400
Received: from mail3.caviumnetworks.com ([12.108.191.235]:5684 "EHLO
	mail3.caviumnetworks.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753513Ab0IWWro (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Sep 2010 18:47:44 -0400
From: David Daney <ddaney@caviumnetworks.com>
To: linux-mips@linux-mips.org, ralf@linux-mips.org,
        linux-kernel@vger.kernel.org
Cc: David Daney <ddaney@caviumnetworks.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Ingo Molnar <mingo@elte.hu>,
        Andre Goddard Rosa <andre.goddard@gmail.com>
Subject: [PATCH 6/9] swiotlb: Declare swiotlb_init_with_default_size()
Date: Thu, 23 Sep 2010 15:47:30 -0700
Message-Id: <1285282051-24907-1-git-send-email-ddaney@caviumnetworks.com>
X-Mailer: git-send-email 1.7.2.2
In-Reply-To: <1285281496-24696-1-git-send-email-ddaney@caviumnetworks.com>
References: <1285281496-24696-1-git-send-email-ddaney@caviumnetworks.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-OriginalArrivalTime: 23 Sep 2010 22:47:43.0322 (UTC) FILETIME=[5572F3A0:01CB5B71]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It comes from swiotlb.c and must be called by external code, so declare it.

Signed-off-by: David Daney <ddaney@caviumnetworks.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Andre Goddard Rosa <andre.goddard@gmail.com>
---
 include/linux/swiotlb.h |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/include/linux/swiotlb.h b/include/linux/swiotlb.h
index 8c0e349..dba51fe 100644
--- a/include/linux/swiotlb.h
+++ b/include/linux/swiotlb.h
@@ -23,6 +23,7 @@ extern int swiotlb_force;
 #define IO_TLB_SHIFT 11
 
 extern void swiotlb_init(int verbose);
+extern void swiotlb_init_with_default_size(size_t, int);
 extern void swiotlb_init_with_tbl(char *tlb, unsigned long nslabs, int verbose);
 
 /*
-- 
1.7.2.2

