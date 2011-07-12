Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753451Ab1GLMeP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jul 2011 08:34:15 -0400
Received: from casper.infradead.org ([85.118.1.10]:34626 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753306Ab1GLMeN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jul 2011 08:34:13 -0400
Message-Id: <20110712122608.938583937@chello.nl>
User-Agent: quilt/0.48-1
Date: Tue, 12 Jul 2011 14:26:08 +0200
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Linux-MM <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>,
        David Miller <davem@davemloft.net>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [PATCH 0/4] mm, sparc64: Implement gup_fast()
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With the recent mmu_gather changes that included generic RCU freeing of
page-tables, it is now quite straight forward to implement gup_fast() on
sparc64.

Andrew, please consider merging these patches.

Thanks.

