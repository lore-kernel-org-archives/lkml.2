Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933017Ab0D3UbA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Apr 2010 16:31:00 -0400
Received: from mga02.intel.com ([134.134.136.20]:21930 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753951Ab0D3Uax (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Apr 2010 16:30:53 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.52,304,1270450800"; 
   d="scan'208";a="617947672"
Date: Fri, 30 Apr 2010 13:30:52 -0700 (Pacific Daylight Time)
From: Peter P Waskiewicz Jr <peter.p.waskiewicz.jr@intel.com>
To: Thomas Gleixner <tglx@linutronix.de>
cc: "davem@davemloft.net" <davem@davemloft.net>,
       "arjan@linux.jf.intel.com" <arjan@linux.jf.intel.com>,
       "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH linux-next v3 1/2] irq: Add CPU mask affinity hint
In-Reply-To: <alpine.LFD.2.00.1004302220270.2951@localhost.localdomain>
Message-ID: <Pine.WNT.4.64.1004301329390.6532@PPWASKIE-MOBL2.amr.corp.intel.com>
References: <20100430202343.4591.66240.stgit@ppwaskie-hc2.jf.intel.com>
 <alpine.LFD.2.00.1004302220270.2951@localhost.localdomain>
X-X-Sender: ppwaskie@imapmail.glb.intel.com
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 30 Apr 2010, Thomas Gleixner wrote:

> Peter,
>
> On Fri, 30 Apr 2010, Peter P Waskiewicz Jr wrote:
>>
>> +extern int irq_register_affinity_hint(unsigned int irq,
>> +                                      const struct cpumask *m);
>
> One last nitpick.
>
> Can you please rename to irq_set_affinity_hint() ?

Not a problem.  It's a better name anyways now that we've dropped the 
callback function.  Patch update incoming.

>
> Otherwise, I'm happy with the outcome. Thanks for your patience!

Thanks for your help getting this pulled together.  This is a big step for 
our performance tuning goals.

Cheers,
-PJ
