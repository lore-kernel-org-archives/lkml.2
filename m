Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755139Ab1KZXu5 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Nov 2011 18:50:57 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:38922 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753889Ab1KZXuz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Nov 2011 18:50:55 -0500
Date: Sat, 26 Nov 2011 23:50:32 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Kautuk Consul <consul.kautuk@gmail.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will.deacon@arm.com>, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1 v5] arm: fault.c: Port OOM changes into
	do_page_fault
Message-ID: <20111126235032.GC9581@n2100.arm.linux.org.uk>
References: <1321986690-6079-1-git-send-email-consul.kautuk@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1321986690-6079-1-git-send-email-consul.kautuk@gmail.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 22, 2011 at 01:31:30PM -0500, Kautuk Consul wrote:
> Commit d065bd810b6deb67d4897a14bfe21f8eb526ba99
> (mm: retry page fault when blocking on disk transfer) and
> commit 37b23e0525d393d48a7d59f870b3bc061a30ccdb
> (x86,mm: make pagefault killable)
> 
> The above commits introduced changes into the x86 pagefault handler
> for making the page fault handler retryable as well as killable.
> 
> These changes reduce the mmap_sem hold time, which is crucial
> during OOM killer invocation.
> 
> Port these changes to ARM.
> 
> Without these changes, my ARM board encounters many hang and livelock
> scenarios.
> After applying this patch, OOM feature performance improves according to
> my testing.
> 
> Signed-off-by: Kautuk Consul <consul.kautuk@gmail.com>

Thanks.  I think this is fine.  Please put it in the patch system so it's
not forgotten, and I'll get to it sometime during the next week.  Thanks.
