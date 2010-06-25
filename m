Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756833Ab0FYW37 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jun 2010 18:29:59 -0400
Received: from one.firstfloor.org ([213.235.205.2]:45149 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751807Ab0FYW36 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jun 2010 18:29:58 -0400
Date: Sat, 26 Jun 2010 00:29:53 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Andi Kleen <andi@firstfloor.org>, Huang Ying <ying.huang@intel.com>,
       Ingo Molnar <mingo@elte.hu>, "H.PeterA" <"nvin hpa"@zytor.com>,
       linux-kernel@vger.kernel.org, tglx <tglx@linutronix.de>,
       davem <davem@davemloft.net>, paulus <paulus@samba.org>
Subject: Re: [RFC][PATCH] irq_work -v2
Message-ID: <20100625222953.GE13421@basil.fritz.box>
References: <1277348698-17311-1-git-send-email-ying.huang@intel.com>
 <1277361352.1875.838.camel@laptop>
 <1277490625.1875.986.camel@laptop>
 <20100625193031.GD13421@basil.fritz.box>
 <1277494784.1875.989.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1277494784.1875.989.camel@laptop>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> perf has two different reasons to for the callback, what I do is set the
> state and enqueue, if its already enqueued the pending callback will
> handle both.
> 
> Its cheaper than having two callback structures per event.

Again it sounds like you just need a bit...
> 
> We can expose the claim/enqueue thing separately so that users can
> choose.

Yes it would be good to separate that, because I doubt other users
will require similar hacks.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
