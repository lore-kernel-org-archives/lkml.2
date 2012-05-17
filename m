Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030436Ab2EQUNc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 May 2012 16:13:32 -0400
Received: from shards.monkeyblade.net ([198.137.202.13]:34669 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030403Ab2EQUN1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 May 2012 16:13:27 -0400
Date: Thu, 17 May 2012 16:13:16 -0400 (EDT)
Message-Id: <20120517.161316.302543932768181836.davem@davemloft.net>
To: mgorman@suse.de
Cc: akpm@linux-foundation.org, linux-mm@kvack.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, neilb@suse.de, a.p.zijlstra@chello.nl,
        michaelc@cs.wisc.edu, emunson@mgebm.net
Subject: Re: [PATCH 13/17] netvm: Set PF_MEMALLOC as appropriate during SKB
 processing
From: David Miller <davem@davemloft.net>
In-Reply-To: <1337266231-8031-14-git-send-email-mgorman@suse.de>
References: <1337266231-8031-1-git-send-email-mgorman@suse.de>
	<1337266231-8031-14-git-send-email-mgorman@suse.de>
X-Mailer: Mew version 6.5 on Emacs 24.0.95 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Thu, 17 May 2012 13:13:18 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mel Gorman <mgorman@suse.de>
Date: Thu, 17 May 2012 15:50:27 +0100

> In order to make sure pfmemalloc packets receive all memory
> needed to proceed, ensure processing of pfmemalloc SKBs happens
> under PF_MEMALLOC. This is limited to a subset of protocols that
> are expected to be used for writing to swap. Taps are not allowed to
> use PF_MEMALLOC as these are expected to communicate with userspace
> processes which could be paged out.
> 
> [a.p.zijlstra@chello.nl: Ideas taken from various patches]
> [jslaby@suse.cz: Lock imbalance fix]
> Signed-off-by: Mel Gorman <mgorman@suse.de>

Acked-by: David S. Miller <davem@davemloft.net>
