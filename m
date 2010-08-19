Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752888Ab0HSM0k (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Aug 2010 08:26:40 -0400
Received: from tx2ehsobe004.messaging.microsoft.com ([65.55.88.14]:32618 "EHLO
	TX2EHSOBE007.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752391Ab0HSM0i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Aug 2010 08:26:38 -0400
X-SpamScore: -14
X-BigFish: VPS-14(zz936eK1432N98dNzz1202hzzz32i2a8h43h61h)
X-Spam-TCS-SCL: 0:0
X-WSS-ID: 0L7EFUT-02-EG8-02
X-M-MSG: 
Date: Thu, 19 Aug 2010 13:41:02 +0200
From: Andreas Herrmann <andreas.herrmann3@amd.com>
To: Peter Zijlstra <peterz@infradead.org>
CC: Heiko Carstens <heiko.carstens@de.ibm.com>, Mike Galbraith <efault@gmx.de>,
        Ingo Molnar <mingo@elte.hu>, Suresh Siddha <suresh.b.siddha@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>
Subject: Re: [PATCH/RFC 2/5] [PATCH] sched: pass sched_domain_level to
 sched_power_savings_store
Message-ID: <20100819114102.GE4659@loge.amd.com>
References: <20100812172544.655648128@de.ibm.com>
 <20100812172622.349333778@de.ibm.com>
 <1281947397.1926.1012.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1281947397.1926.1012.camel@laptop>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Reverse-DNS: unknown
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 16, 2010 at 04:29:57AM -0400, Peter Zijlstra wrote:
> On Thu, 2010-08-12 at 19:25 +0200, Heiko Carstens wrote:
> > Pass the corresponding sched domain level to sched_power_savings_store instead
> > of a yes/no flag which indicates if the level is SMT or MC.
> > This is needed to easily extend the function so it can be used for a third
> > level. 
> 
> Ah, so the plan is to reduce the number of knobs, not create more.

Don't think so.

> Sysadmins really aren't interested in having a powersavings knob per
> topology level.

It just allows to use the same store functions for three instead of
two different knobs.


Andreas



