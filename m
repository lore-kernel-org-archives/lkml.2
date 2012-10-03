Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756890Ab2JCAxe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Oct 2012 20:53:34 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:52625 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756771Ab2JCAxU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Oct 2012 20:53:20 -0400
Date: Tue, 02 Oct 2012 20:53:18 -0400 (EDT)
Message-Id: <20121002.205318.1484512119234167322.davem@davemloft.net>
To: akpm@linux-foundation.org
Cc: linux-mm@kvack.org, sparclinux@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
        aarcange@redhat.com, hannes@cmpxchg.org, gerald.schaefer@de.ibm.com
Subject: Re: [PATCH 0/8] THP support for Sparc64
From: David Miller <davem@davemloft.net>
In-Reply-To: <20121002155544.2c67b1e8.akpm@linux-foundation.org>
References: <20121002.182601.845433592794197720.davem@davemloft.net>
	<20121002155544.2c67b1e8.akpm@linux-foundation.org>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andrew Morton <akpm@linux-foundation.org>
Date: Tue, 2 Oct 2012 15:55:44 -0700

> I had a shot at integrating all this onto the pending stuff in linux-next. 
> "mm: Add and use update_mmu_cache_pmd() in transparent huge page code."
> needed minor massaging in huge_memory.c.  But as Andrea mentioned, we
> ran aground on Gerald's
> http://ozlabs.org/~akpm/mmotm/broken-out/thp-remove-assumptions-on-pgtable_t-type.patch,
> part of the thp-for-s390 work.

I'll rebase my work against that stuff, looks fine to me.
