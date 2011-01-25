Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753702Ab1AYUpJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jan 2011 15:45:09 -0500
Received: from lo.gmane.org ([80.91.229.12]:56205 "EHLO lo.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753409Ab1AYUpH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jan 2011 15:45:07 -0500
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Andi Kleen <ak@linux.intel.com>
Subject: Re: [PATCH 00/25] mm: Preemptibility -v7
Date: Tue, 25 Jan 2011 11:45:28 -0800
Message-ID: <m2ipxcsr6v.fsf@linux.intel.com>
References: <20110125173111.720927511@chello.nl>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Complaints-To: usenet@dough.gmane.org
Cc: linux-mm@kvack.org, linux-arch@vger.kernel.org
X-Gmane-NNTP-Posting-Host: jfdmzpr02-ext.jf.intel.com
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.2 (gnu/linux)
Cancel-Lock: sha1:po9hh0br9vzHOJ/DqLJuEZ77lE8=
Cc: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Peter Zijlstra <a.p.zijlstra@chello.nl> writes:

> This patch-set makes part of the mm a lot more preemptible. It converts
> i_mmap_lock and anon_vma->lock to mutexes and makes mmu_gather fully
> preemptible.
>
> The main motivation was making mm_take_all_locks() preemptible, since it
> appears people are nesting hundreds of spinlocks there.

Just curious: why is mm_take_all_locks() a problem? As far as I can see
it's just used when starting KVM or GRU the first time. Is that a common
situation?

-Andi

-- 
Andi Kleen
Intel Open Source Technology Center

