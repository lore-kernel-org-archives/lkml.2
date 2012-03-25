Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756894Ab2CYTFa (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Mar 2012 15:05:30 -0400
Received: from shards.monkeyblade.net ([198.137.202.13]:51112 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756861Ab2CYTFB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Mar 2012 15:05:01 -0400
Date: Sun, 25 Mar 2012 15:04:52 -0400 (EDT)
Message-Id: <20120325.150452.2130364052890102881.davem@davemloft.net>
To: consul.kautuk@gmail.com
Cc: paul.gortmaker@windriver.com, mingo@elte.hu, joe@perches.com,
        a.p.zijlstra@chello.nl, sparclinux@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 20/20 v2] sparc/mm/fault_64.c: Port OOM changes to
 do_sparc64_fault
From: David Miller <davem@davemloft.net>
In-Reply-To: <1332698348-2253-1-git-send-email-consul.kautuk@gmail.com>
References: <1332698348-2253-1-git-send-email-consul.kautuk@gmail.com>
X-Mailer: Mew version 6.4 on Emacs 23.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Sun, 25 Mar 2012 12:04:54 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Kautuk Consul <consul.kautuk@gmail.com>
Date: Sun, 25 Mar 2012 13:59:08 -0400

> +			perf_sw_event(PERF_COUNT_SW_PAGE_FAULTS_MAJ,
> +					1, regs, address);

Improperly indented still.

> +			perf_sw_event(PERF_COUNT_SW_PAGE_FAULTS_MIN,
> +					1, regs, address);

Likewise.
