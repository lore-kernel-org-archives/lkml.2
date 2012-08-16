Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753745Ab2HPFpz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Aug 2012 01:45:55 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:45474 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751164Ab2HPFpy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Aug 2012 01:45:54 -0400
Date: Thu, 16 Aug 2012 06:45:46 +0100
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Alex Shi <alex.shi@intel.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        Arjan van de Ven <arjan@linux.intel.com>, vincent.guittot@linaro.org,
        svaidy@linux.vnet.ibm.com, Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [discussion]sched: a rough proposal to enable power saving in
 scheduler
Message-ID: <20120816054546.GA31864@srcf.ucam.org>
References: <5028F12C.7080405@intel.com>
 <20120815161911.GA14534@srcf.ucam.org>
 <502C7F24.6020900@intel.com>
 <20120816053133.GA31623@srcf.ucam.org>
 <502C8798.8060807@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <502C8798.8060807@intel.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 16, 2012 at 01:39:36PM +0800, Alex Shi wrote:
> On 08/16/2012 01:31 PM, Matthew Garrett wrote:
> > will tend to split them across packages?
> 
> 
> No, there is still has balance idea in this rough proposal. If a domain
> is not overload, it is better to left old tasks unchanged. I should say,
> current scheduler is the 'performance' trend scheme.

The current process isn't necessarily ideal for all workloads - that's 
one of the reasons for letting workspace modify process affinity. I 
agree that the "performance" mode will tend to provide better 
performance than the "power" mode for an arbitrary workload, but if 
there are workloads that would perform better in "power" then it's a 
poor naming scheme.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
