Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757324Ab2JQP0Y (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Oct 2012 11:26:24 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:40785 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751871Ab2JQP0W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Oct 2012 11:26:22 -0400
Date: Wed, 17 Oct 2012 11:26:20 -0400 (EDT)
Message-Id: <20121017.112620.1865348978594874782.davem@davemloft.net>
To: will.deacon@arm.com
Cc: akpm@linux-foundation.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
        mhocko@suse.cz, kirill@shutemov.name, aarcange@redhat.com,
        cmetcalf@tilera.com, Steve.Capper@arm.com
Subject: Re: [PATCH v2] mm: thp: Set the accessed flag for old pages on
 access fault.
From: David Miller <davem@davemloft.net>
In-Reply-To: <20121017130125.GH5973@mudshark.cambridge.arm.com>
References: <1349197151-19645-1-git-send-email-will.deacon@arm.com>
	<20121002150104.da57fa94.akpm@linux-foundation.org>
	<20121017130125.GH5973@mudshark.cambridge.arm.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Will Deacon <will.deacon@arm.com>
Date: Wed, 17 Oct 2012 14:01:25 +0100

> +		update_mmu_cache(vma, address, pmd);

This won't build, use update_mmu_cache_pmd().
