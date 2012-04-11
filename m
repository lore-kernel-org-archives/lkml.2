Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751981Ab2DKFIO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Apr 2012 01:08:14 -0400
Received: from linux-sh.org ([111.68.239.195]:33595 "EHLO linux-sh.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751165Ab2DKFIM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Apr 2012 01:08:12 -0400
Date: Wed, 11 Apr 2012 14:07:57 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Kautuk Consul <consul.kautuk@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        linux-sh@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 16/19 v2] sh/mm/fault_32.c: Port OOM changes to do_page_fault
Message-ID: <20120411050756.GD19696@linux-sh.org>
References: <1333195571-5455-1-git-send-email-consul.kautuk@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1333195571-5455-1-git-send-email-consul.kautuk@gmail.com>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Mar 31, 2012 at 08:06:11AM -0400, Kautuk Consul wrote:
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
> Port these changes to the 32-bit SH platform.
> 
> Signed-off-by: Kautuk Consul <consul.kautuk@gmail.com>

Applied, thanks.

I've also made the change for sh64, and will send them out to Linus in
the next round of updates.
