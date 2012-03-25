Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756857Ab2CYTEk (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Mar 2012 15:04:40 -0400
Received: from shards.monkeyblade.net ([198.137.202.13]:51106 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756813Ab2CYTEj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Mar 2012 15:04:39 -0400
Date: Sun, 25 Mar 2012 15:04:22 -0400 (EDT)
Message-Id: <20120325.150422.2000357641354896689.davem@davemloft.net>
To: consul.kautuk@gmail.com
Cc: paul.gortmaker@windriver.com, mingo@elte.hu, joe@perches.com,
        a.p.zijlstra@chello.nl, sparclinux@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 19/20 v2] sparc/mm/fault_32.c: Port OOM changes to
 do_sparc_fault
From: David Miller <davem@davemloft.net>
In-Reply-To: <1332698315-2218-1-git-send-email-consul.kautuk@gmail.com>
References: <1332698315-2218-1-git-send-email-consul.kautuk@gmail.com>
X-Mailer: Mew version 6.4 on Emacs 23.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Sun, 25 Mar 2012 12:04:27 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Kautuk Consul <consul.kautuk@gmail.com>
Date: Sun, 25 Mar 2012 13:58:35 -0400

> +	unsigned int flags = (FAULT_FLAG_ALLOW_RETRY | FAULT_FLAG_KILLABLE |
> +					(write ? FAULT_FLAG_WRITE : 0));

Still indented wrong, it should be:

	unsigned int flags = (FAULT_FLAG_ALLOW_RETRY | FAULT_FLAG_KILLABLE |
			      (write ? FAULT_FLAG_WRITE : 0));

The second line must have the openning parenthesis line up with
the column after the openning parenthesis on the first line.  Do
not use only tabs to indent this stuff, line it up properly.

You need to use tabs and spaces to line it up.  Use something like
emacs's C-mode to help you if you can't do it right by hand.

> +			perf_sw_event(PERF_COUNT_SW_PAGE_FAULTS_MAJ,
> +					1, regs, address);

Still wrong, for the same exact reason.

I went out of my way to reply to your private email (which I usually
ignore, you should never email developers privately) and you didn't
even listen to the feedback I gave you.
