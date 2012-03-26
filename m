Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757434Ab2CZVhJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Mar 2012 17:37:09 -0400
Received: from shards.monkeyblade.net ([198.137.202.13]:34912 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757292Ab2CZVhH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Mar 2012 17:37:07 -0400
Date: Mon, 26 Mar 2012 17:36:14 -0400 (EDT)
Message-Id: <20120326.173614.1619139899994626442.davem@davemloft.net>
To: consul.kautuk@gmail.com
Cc: paul.gortmaker@windriver.com, mingo@elte.hu, joe@perches.com,
        a.p.zijlstra@chello.nl, sparclinux@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 20/20 v4] sparc/mm/fault_64.c: Port OOM changes to
 do_sparc64_fault
From: David Miller <davem@davemloft.net>
In-Reply-To: <1332780049-2777-1-git-send-email-consul.kautuk@gmail.com>
References: <1332780049-2777-1-git-send-email-consul.kautuk@gmail.com>
X-Mailer: Mew version 6.4 on Emacs 23.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Mon, 26 Mar 2012 14:36:16 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Kautuk Consul <consul.kautuk@gmail.com>
Date: Mon, 26 Mar 2012 12:40:49 -0400

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
> Port these changes to 64-bit sparc.
> 
> Signed-off-by: Kautuk Consul <consul.kautuk@gmail.com>

Acked-by: David S. Miller <davem@davemloft.net>
