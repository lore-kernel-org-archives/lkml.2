Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753243Ab0HSNRi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Aug 2010 09:17:38 -0400
Received: from tx2ehsobe003.messaging.microsoft.com ([65.55.88.13]:46435 "EHLO
	TX2EHSOBE006.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751712Ab0HSNRf convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Aug 2010 09:17:35 -0400
X-SpamScore: -14
X-BigFish: VPS-14(zz936eK1432N98dNzz1202hzzz32i2a8h43h61h)
X-Spam-TCS-SCL: 0:0
X-WSS-ID: 0L7EI91-01-HB6-02
X-M-MSG: 
Date: Thu, 19 Aug 2010 14:32:38 +0200
From: Andreas Herrmann <andreas.herrmann3@amd.com>
To: Peter Zijlstra <peterz@infradead.org>
CC: Heiko Carstens <heiko.carstens@de.ibm.com>, Mike Galbraith <efault@gmx.de>,
        Ingo Molnar <mingo@elte.hu>, Suresh Siddha <suresh.b.siddha@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>
Subject: Re: [PATCH/RFC 2/5] [PATCH] sched: pass sched_domain_level to
 sched_power_savings_store
Message-ID: <20100819123238.GG4659@loge.amd.com>
References: <20100812172544.655648128@de.ibm.com>
 <20100812172622.349333778@de.ibm.com>
 <1281947397.1926.1012.camel@laptop>
 <20100819114102.GE4659@loge.amd.com>
 <1282221311.2605.81.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
In-Reply-To: <1282221311.2605.81.camel@laptop>
User-Agent: Mutt/1.5.20 (2009-06-14)
Content-Transfer-Encoding: 8BIT
X-Reverse-DNS: unknown
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 19, 2010 at 08:35:11AM -0400, Peter Zijlstra wrote:
> On Thu, 2010-08-19 at 13:41 +0200, Andreas Herrmann wrote:
> > It just allows to use the same store functions for three instead of
> > two different knobs. 
> 
> Creating more knobs for powersave scheduling is a fail.
> 
> We already have 2^3 powersave scheduling states, it should be decreased
> to 2 (namely on/off), not increased to 3^3.

I think it should be possible to select a domain level at which power
saving scheduling should happen (this would result in 3 states in the
z196 case).


Andreas

-- 
Operating | Advanced Micro Devices GmbH
  System  | Einsteinring 24, 85609 Dornach b. München, Germany
 Research | Geschäftsführer: Alberto Bozzo, Andrew Bowd
  Center  | Sitz: Dornach, Gemeinde Aschheim, Landkreis München
  (OSRC)  | Registergericht München, HRB Nr. 43632


