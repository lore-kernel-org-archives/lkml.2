Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753841Ab2AYPgd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jan 2012 10:36:33 -0500
Received: from casper.infradead.org ([85.118.1.10]:59976 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752858Ab2AYPgb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jan 2012 10:36:31 -0500
Subject: Re: [RFC PATCH v1 1/2] sched: unified sched_powersavings sysfs
 tunable
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Arjan van de Ven <arjan@linux.intel.com>
Cc: Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Indan Zupancic <indan@nul.nu>, Youquan Song <youquan.song@intel.com>,
        Ingo Molnar <mingo@elte.hu>, Suresh Siddha <suresh.b.siddha@intel.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <4F201BE4.6000503@linux.intel.com>
References: <20120116161740.29759.4679.stgit@localhost>
	 <20120116162241.29759.13220.stgit@localhost>
	 <1327504213.2614.78.camel@laptop>  <4F201BE4.6000503@linux.intel.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 25 Jan 2012 16:36:28 +0100
Message-ID: <1327505788.2614.81.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-01-25 at 07:12 -0800, Arjan van de Ven wrote:
> On 1/25/2012 7:10 AM, Peter Zijlstra wrote:
> 
> 
> btw... any reason why this feature is a config option with tons of
> ifdefs... why not just have this available all the time?
> it shouldn't be all that much code in the first place.

I guess its because SCHED_SMT and SCHED_MC also indicate the
availability of the topology functions like cpu_coregroup_mask() etc.

The whole powersave stuff got intermixed with all that.

But yes, I agree, we should kill all that and sort the topology stuff
differently.

