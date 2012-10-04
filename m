Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756844Ab2JDTqb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Oct 2012 15:46:31 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:45211 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756528Ab2JDTq3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Oct 2012 15:46:29 -0400
Date: Thu, 04 Oct 2012 15:46:24 -0400 (EDT)
Message-Id: <20121004.154624.923241475790311926.davem@davemloft.net>
To: linux-mm@kvack.org
CC: sparclinux@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arch@vger.kernel.org, akpm@linux-foundation.org,
        aarcange@redhat.com, hannes@cmpxchg.org
Subject: [PATCH v2 0/8] THP support for Sparc64
From: David Miller <davem@davemloft.net>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Changes since V1:

1) Respun against mmotm

2) Bug fix for pgtable allocation, need real locking instead of
   just preemption disabling.

Andrew, you can probably take patch #5 in this series and combine
it into:

mm-thp-fix-the-update_mmu_cache-last-argument-passing-in-mm-huge_memoryc.patch

in your batch.  And finally add a NOP implementation for S390
and any other huge page supporting architectures.

Signed-off-by: David S. Miller <davem@davemloft.net>
