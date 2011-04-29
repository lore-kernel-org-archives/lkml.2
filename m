Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758809Ab1D2OHX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Apr 2011 10:07:23 -0400
Received: from va3ehsobe004.messaging.microsoft.com ([216.32.180.14]:34919
	"EHLO VA3EHSOBE004.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751886Ab1D2OHW convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Apr 2011 10:07:22 -0400
X-SpamScore: -8
X-BigFish: VPS-8(zz1432N98dKzz1202hzz8275bh8275dhz32i668h839h61h)
X-Spam-TCS-SCL: 0:0
X-Forefront-Antispam-Report: KIP:(null);UIP:(null);IPVD:NLI;H:ausb3twp01.amd.com;RD:none;EFVD:NLI
X-WSS-ID: 0LKF383-01-5DV-02
X-M-MSG: 
Date: Fri, 29 Apr 2011 16:07:14 +0200
From: Andreas Herrmann <andreas.herrmann3@amd.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
CC: Ingo Molnar <mingo@elte.hu>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Anton Blanchard <anton@au1.ibm.com>,
        Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        Venkatesh Pallipadi <venki@google.com>, Paul Turner <pjt@google.com>,
        Mike Galbraith <efault@gmx.de>, Thomas Gleixner <tglx@linutronix.de>,
        Heiko Carstens <heiko.carstens@de.ibm.com>
Subject: Re: [PATCH 00/23] sched: Rewrite sched_domain/sched_group creation
Message-ID: <20110429140714.GC22001@alberich.amd.com>
References: <20110407120941.400629539@chello.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
In-Reply-To: <20110407120941.400629539@chello.nl>
User-Agent: Mutt/1.5.21 (2010-09-15)
Content-Transfer-Encoding: 8BIT
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 07, 2011 at 08:09:41AM -0400, Peter Zijlstra wrote:
> This series rewrite the sched_domain and sched_group creation code.
> 
> While its still not completely finished it does get us a lot of cleanups
> and code reduction and seems fairly stable at this point and should thus
> be a fairly good base to continue from.

Hi Peter,

finally I've reviewed the entire patch set.
Didn't find suspicious things.
So if you care you can add a
Reviewed-by: Andreas Herrmann <andreas.herrmann3@amd.com>
to each of the 23 patches.

> Also available through:
>   git://git.kernel.org/pub/scm/linux/kernel/git/peterz/linux-2.6-sched.git sched_domain

I've also tested that stuff on a Magny-Cours and other systems.  Seems
to be quite stable so far. (Especially also on multi-node CPUs;-)
(I've used your branch rebased (w/o issues) on -rc5.)


Regards,

Andreas

-- 
Operating | Advanced Micro Devices GmbH
  System  | Einsteinring 24, 85609 Dornach b. München, Germany
 Research | Geschäftsführer: Alberto Bozzo, Andrew Bowd
  Center  | Sitz: Dornach, Gemeinde Aschheim, Landkreis München
  (OSRC)  | Registergericht München, HRB Nr. 43632


