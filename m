Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752677Ab2K1QUG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Nov 2012 11:20:06 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:50042 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751036Ab2K1QUE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Nov 2012 11:20:04 -0500
Date: Wed, 28 Nov 2012 11:20:01 -0500 (EST)
Message-Id: <20121128.112001.1723079532431419311.davem@davemloft.net>
To: paolo.valente@unimore.it
Cc: jhs@mojatatu.com, shemminger@vyatta.com, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, rizzo@iet.unipi.it, fchecconi@gmail.com
Subject: Re: [PATCH] pkt_sched: QFQ Plus: fair-queueing service at DRR cost
From: David Miller <davem@davemloft.net>
In-Reply-To: <20121123210319.GA15775@paolo-ThinkPad-W520>
References: <20121123210319.GA15775@paolo-ThinkPad-W520>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Paolo Valente <paolo.valente@unimore.it>
Date: Fri, 23 Nov 2012 22:03:19 +0100

> This patch turns QFQ into QFQ+, a variant of QFQ that provides the
> following two benefits: 1) QFQ+ is faster than QFQ, 2) differently
> from QFQ, QFQ+ correctly schedules also non-leaves classes in a
> hierarchical setting. A detailed description of QFQ+, plus a
> performance comparison with DRR and QFQ, can be found in [1].
> 
> [1] P. Valente, "Reducing the Execution Time of Fair-Queueing Schedulers"
> http://algo.ing.unimo.it/people/paolo/agg-sched/agg-sched.pdf
> 
> Signed-off-by: Paolo Valente <paolo.valente@unimore.it>

Applied, thanks.
