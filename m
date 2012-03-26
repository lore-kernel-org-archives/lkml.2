Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755564Ab2CZUJo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Mar 2012 16:09:44 -0400
Received: from shards.monkeyblade.net ([198.137.202.13]:34092 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752184Ab2CZUJm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Mar 2012 16:09:42 -0400
Date: Mon, 26 Mar 2012 16:09:23 -0400 (EDT)
Message-Id: <20120326.160923.1071907261787727015.davem@davemloft.net>
To: consul.kautuk@gmail.com
Cc: paul.gortmaker@windriver.com, mingo@elte.hu, joe@perches.com,
        a.p.zijlstra@chello.nl, sparclinux@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 19/20 v3] sparc/mm/fault_32.c: Port OOM changes to
 do_sparc_fault
From: David Miller <davem@davemloft.net>
In-Reply-To: <1332775946-2162-1-git-send-email-consul.kautuk@gmail.com>
References: <1332775946-2162-1-git-send-email-consul.kautuk@gmail.com>
X-Mailer: Mew version 6.4 on Emacs 23.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Mon, 26 Mar 2012 13:09:28 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Kautuk Consul <consul.kautuk@gmail.com>
Date: Mon, 26 Mar 2012 11:32:26 -0400

> +	unsigned int flags = (FAULT_FLAG_ALLOW_RETRY | FAULT_FLAG_KILLABLE |
> +						  (write ? FAULT_FLAG_WRITE : 0));

Indentation is still wrong.  The "(write ..." on the second line must
line up with the column of the first "F" in "(FAULT_FLAG..." on the
first line.

+			perf_sw_event(PERF_COUNT_SW_PAGE_FAULTS_MAJ,
+						  1, regs, address);

+			perf_sw_event(PERF_COUNT_SW_PAGE_FAULTS_MIN,
+						  1, regs, address);

These are still wrong too, for the same reason.

You didn't fix anything.

