Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751170Ab1ADKRi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jan 2011 05:17:38 -0500
Received: from casper.infradead.org ([85.118.1.10]:49230 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750825Ab1ADKRh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jan 2011 05:17:37 -0500
Subject: Re: [PATCH 1/3] sched: add __rcu annotation
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: Ingo Molnar <mingo@elte.hu>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Arnd Bergmann <arnd@arndb.de>, LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <4D22D4EE.3020604@cn.fujitsu.com>
References: <4D22D4EE.3020604@cn.fujitsu.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Tue, 04 Jan 2011 11:17:47 +0100
Message-ID: <1294136267.2016.105.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-01-04 at 16:06 +0800, Lai Jiangshan wrote:
> Add __rcu annotation to :
> 	(struct rq)->sd

That's a broken changelog, it's about as good as:

 i++; /* increment i */

I'm really starting to detest sparse (lock annotations), it keeps adding
these annotations, but does it ever catch an actual bug?
