Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752213Ab0HSMV5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Aug 2010 08:21:57 -0400
Received: from tx2ehsobe002.messaging.microsoft.com ([65.55.88.12]:54546 "EHLO
	TX2EHSOBE003.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750883Ab0HSMVz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Aug 2010 08:21:55 -0400
X-SpamScore: -14
X-BigFish: VPS-14(zz936eK1432N98dNzz1202hzz8275bhz32i2a8h61h)
X-Spam-TCS-SCL: 0:0
X-WSS-ID: 0L7EFMV-01-E8R-02
X-M-MSG: 
Date: Thu, 19 Aug 2010 13:36:17 +0200
From: Andreas Herrmann <andreas.herrmann3@amd.com>
To: Suresh Siddha <suresh.b.siddha@intel.com>
CC: Heiko Carstens <heiko.carstens@de.ibm.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Mike Galbraith <efault@gmx.de>, Ingo Molnar <mingo@elte.hu>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>
Subject: Re: [PATCH/RFC 2/5] [PATCH] sched: pass sched_domain_level to
 sched_power_savings_store
Message-ID: <20100819113617.GD4659@loge.amd.com>
References: <20100812172544.655648128@de.ibm.com>
 <20100812172622.349333778@de.ibm.com>
 <1281734020.2704.30.camel@sbsiddha-MOBL3.sc.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1281734020.2704.30.camel@sbsiddha-MOBL3.sc.intel.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Reverse-DNS: ausb3extmailp02.amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 13, 2010 at 05:13:40PM -0400, Suresh Siddha wrote:
> On Thu, 2010-08-12 at 10:25 -0700, Heiko Carstens wrote:
> > From: Heiko Carstens <heiko.carstens@de.ibm.com>
> > 
> > Pass the corresponding sched domain level to sched_power_savings_store instead
> > of a yes/no flag which indicates if the level is SMT or MC.
> > This is needed to easily extend the function so it can be used for a third
> > level.
> > 
> > Signed-off-by: Heiko Carstens <heiko.carstens@de.ibm.com>
> 
> Acked-by: Suresh Siddha <suresh.b.siddha@intel.com>

Acked-by: Andreas Herrmann <andreas.herrmann3@amd.com>


