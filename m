Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754077Ab2KUREw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Nov 2012 12:04:52 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:53487 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751821Ab2KUREu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Nov 2012 12:04:50 -0500
Date: Wed, 21 Nov 2012 12:04:47 -0500 (EST)
Message-Id: <20121121.120447.533618493809264831.davem@davemloft.net>
To: paolo.valente@unimore.it
Cc: jhs@mojatatu.com, shemminger@vyatta.com, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, rizzo@iet.unipi.it, fchecconi@gmail.com
Subject: Re: [PATCH] pkt_sched: QFQ Plus: fair-queueing service at DRR cost
From: David Miller <davem@davemloft.net>
In-Reply-To: <50ACA2AA.1020206@unimore.it>
References: <20121120174513.GA21618@paolo-ThinkPad-W520>
	<20121120.135409.1810847883436963918.davem@davemloft.net>
	<50ACA2AA.1020206@unimore.it>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Paolo Valente <paolo.valente@unimore.it>
Date: Wed, 21 Nov 2012 10:45:14 +0100

> Got it. Actually, if the first qfq_peek_skb returns NULL, then the
> example version that you are proposing apparently may behave in a
> different way than the original one: in your proposal the scheduler
> tries to switch to a new aggregate and may return a non-NULL value,
> whereas the original version would immediately return NULL. I guess
> that this slightly different behavior is fine as well, and I am
> preparing a new patch that integrates these changes.

Thanks.
