Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758407Ab0JSLZ5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Oct 2010 07:25:57 -0400
Received: from canuck.infradead.org ([134.117.69.58]:34776 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758372Ab0JSLZ4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Oct 2010 07:25:56 -0400
Subject: Re: [sparc build bug] Re: [tip:perf/core] irq: Add tracepoint to
 softirq_raise
From: Peter Zijlstra <peterz@infradead.org>
To: Koki Sanagi <sanagi.koki@jp.fujitsu.com>
Cc: Ingo Molnar <mingo@elte.hu>, mathieu.desnoyers@efficios.com,
        fweisbec@gmail.com, rostedt@goodmis.org, nhorman@tuxdriver.com,
        scott.a.mcmillan@intel.com, tglx@linutronix.de, laijs@cn.fujitsu.com,
        hpa@zytor.com, linux-kernel@vger.kernel.org, eric.dumazet@gmail.com,
        kaneshige.kenji@jp.fujitsu.com, davem@davemloft.net,
        izumi.taku@jp.fujitsu.com, kosaki.motohiro@jp.fujitsu.com,
        linux-tip-commits@vger.kernel.org,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        "Luck, Tony" <tony.luck@intel.com>
In-Reply-To: <4CBD79CF.2060706@jp.fujitsu.com>
References: <4C724298.4050509@jp.fujitsu.com>
	 <tip-2bf2160d8805de64308e2e7c3cd97813cb58ed2f@git.kernel.org>
	 <20100908112529.GA25931@elte.hu>  <1287395077.29097.1543.camel@twins>
	 <1287398936.29097.1548.camel@twins>  <4CBD79CF.2060706@jp.fujitsu.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Tue, 19 Oct 2010 13:25:32 +0200
Message-ID: <1287487532.1994.4.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-10-19 at 19:58 +0900, Koki Sanagi wrote:
> >> I could build sparc64_defconfig, but s390 is broken for me by
> this...
> > 
> > /me being very grumpy @ Lai.. ia64 is broken too!
> > 
> > /me goes revert this shite
> > 
> 
> Now it is fixed.
> 
> http://git.kernel.org/?p=linux/kernel/git/next/linux-next.git;a=commitdiff;h=9f081ce5da2c8af297a0a7d15a57fb4beeed374b;hp=43e3bf203456c4f06bdd6060426976ad2bed9081

No its not, -tip is still not buildable on s390 and ia64.

Please don't ever pull crap like this again.
