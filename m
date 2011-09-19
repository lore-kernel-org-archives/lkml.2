Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752293Ab1ISHiQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Sep 2011 03:38:16 -0400
Received: from casper.infradead.org ([85.118.1.10]:60657 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751425Ab1ISHiP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Sep 2011 03:38:15 -0400
Subject: Re: [RFC][PATCH 2/3] futex: Reduce hash bucket lock contention
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Manfred Spraul <manfred@colorfullife.com>
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
        linux-kernel@vger.kernel.org, Steven Rostedt <rostedt@goodmis.org>,
        Darren Hart <dvhart@linux.intel.com>,
        David Miller <davem@davemloft.net>,
        Eric Dumazet <eric.dumazet@gmail.com>, Mike Galbraith <efault@gmx.de>
In-Reply-To: <4E749937.5090803@colorfullife.com>
References: <20110914133034.687048806@chello.nl>
	 <20110914133750.831707072@chello.nl> <1316176490.10174.22.camel@twins>
	 <4E749937.5090803@colorfullife.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Mon, 19 Sep 2011 09:37:20 +0200
Message-ID: <1316417840.10174.46.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 3.0.3- 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2011-09-17 at 14:57 +0200, Manfred Spraul wrote:
> How do we verify that everything is able to deal with spurious
> wakeups?
> 
Well, I could go audit all 1400+ *schedule*() callsites in the kernel.
Or we can rely on the fact that current code can already cause spurious
wakeups due to signals.


