Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751430Ab1ADLBb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jan 2011 06:01:31 -0500
Received: from casper.infradead.org ([85.118.1.10]:55166 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750954Ab1ADLBa convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jan 2011 06:01:30 -0500
Subject: Re: [PATCH 1/3] sched: add __rcu annotation
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Eric Dumazet <eric.dumazet@gmail.com>
Cc: Lai Jiangshan <laijs@cn.fujitsu.com>, Ingo Molnar <mingo@elte.hu>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Arnd Bergmann <arnd@arndb.de>, LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <1294138545.3579.53.camel@edumazet-laptop>
References: <4D22D4EE.3020604@cn.fujitsu.com>
	 <1294136267.2016.105.camel@laptop>
	 <1294138545.3579.53.camel@edumazet-laptop>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Tue, 04 Jan 2011 12:01:24 +0100
Message-ID: <1294138884.2016.106.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-01-04 at 11:55 +0100, Eric Dumazet wrote:
> Le mardi 04 janvier 2011 à 11:17 +0100, Peter Zijlstra a écrit :
> 
> > I'm really starting to detest sparse (lock annotations), it keeps adding
> > these annotations, but does it ever catch an actual bug?
> 
> Actually I caught at least one bug in networking (FIB code ?) thanks to
> these __rcu annotations ;)
> 
> Cannot remember the exact bug, sorry ;)

Ah, ok.. then they're not completely pointless. Lai, can you resend with
a slightly better changelog?
