Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752863Ab2KTSAk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2012 13:00:40 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:42085 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752511Ab2KTSAj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2012 13:00:39 -0500
Date: Tue, 20 Nov 2012 13:00:37 -0500 (EST)
Message-Id: <20121120.130037.1623510190807242010.davem@davemloft.net>
To: paolo.valente@unimore.it
Cc: jhs@mojatatu.com, shemminger@vyatta.com, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, rizzo@iet.unipi.it, fchecconi@gmail.com
Subject: Re: [PATCH] pkt_sched: QFQ Plus: fair-queueing service at DRR cost
From: David Miller <davem@davemloft.net>
In-Reply-To: <50ABC19E.9030209@unimore.it>
References: <20121112164833.GA12970@paolo-ThinkPad-W520>
	<20121119.184828.628106002307042971.davem@davemloft.net>
	<50ABC19E.9030209@unimore.it>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Paolo Valente <paolo.valente@unimore.it>
Date: Tue, 20 Nov 2012 18:45:02 +0100

> Unfortunately I could not reproduce the warning (with
> gcc-4.7 -Wmaybe-uninitialized). I am however about to send a new
> version with skb initialized to NULL. I hope that this fix properly
> addresses this issue.

It triggers readily with Fedora's gcc-4.7.2-2 with "allmodconfig" on
x86-64.

