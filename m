Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755603Ab2CZULV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Mar 2012 16:11:21 -0400
Received: from shards.monkeyblade.net ([198.137.202.13]:34109 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754090Ab2CZULT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Mar 2012 16:11:19 -0400
Date: Mon, 26 Mar 2012 16:11:05 -0400 (EDT)
Message-Id: <20120326.161105.1592652605352070253.davem@davemloft.net>
To: consul.kautuk@gmail.com
Cc: paul.gortmaker@windriver.com, mingo@elte.hu, joe@perches.com,
        a.p.zijlstra@chello.nl, sparclinux@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 20/20 v3] sparc/mm/fault_64.c: Port OOM changes to
 do_sparc64_fault
From: David Miller <davem@davemloft.net>
In-Reply-To: <1332775997-2197-1-git-send-email-consul.kautuk@gmail.com>
References: <1332775997-2197-1-git-send-email-consul.kautuk@gmail.com>
X-Mailer: Mew version 6.4 on Emacs 23.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Mon, 26 Mar 2012 13:11:07 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Kautuk Consul <consul.kautuk@gmail.com>
Date: Mon, 26 Mar 2012 11:33:17 -0400

> +	fault = handle_mm_fault(mm, vma, address,
> +							flags | ((fault_code & FAULT_CODE_WRITE) ?
> +									 FAULT_FLAG_WRITE : 0);

This is so shockingly gross I'm at a loss for words.  Why are you
tabbing this crap all the way into outer-space?

Make the "flags | ..." line up with the first column after the
openning parenthesis of "handle_mm_fault(".

> +			perf_sw_event(PERF_COUNT_SW_PAGE_FAULTS_MAJ,
> +						  1, regs, address);

Same problem.

> +			perf_sw_event(PERF_COUNT_SW_PAGE_FAULTS_MIN,
> +						  1, regs, address);

Same problem.

You're making the coding style worse each iteration, not better.
