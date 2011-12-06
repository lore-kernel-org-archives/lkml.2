Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933232Ab1LFKg6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Dec 2011 05:36:58 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:34595 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933096Ab1LFKg5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Dec 2011 05:36:57 -0500
Date: Tue, 6 Dec 2011 11:35:00 +0100
From: Ingo Molnar <mingo@elte.hu>
To: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Cc: Fenghua Yu <fenghua.yu@intel.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        Thomas Gleixner <tglx@linutronix.de>, H Peter Anvin <hpa@zytor.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Tony Luck <tony.luck@intel.com>,
        Arjan van de Ven <arjan.van.de.ven@intel.com>,
        Suresh B Siddha <suresh.b.siddha@intel.com>,
        Len Brown <len.brown@intel.com>, Randy Dunlap <rdunlap@xenotime.net>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Peter Zijlstra <peterz@infradead.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        linux-pm <linux-pm@vger.kernel.org>, x86 <x86@kernel.org>,
        Tejun Heo <tj@kernel.org>, Borislav Petkov <bp@amd64.org>,
        "Herrmann3, Andreas" <Andreas.Herrmann3@amd.com>
Subject: Re: [PATCH v4 0/7] x86: BSP or CPU0 online/offline
Message-ID: <20111206103500.GD15966@elte.hu>
References: <1321075592-31600-1-git-send-email-fenghua.yu@intel.com>
 <20111206084230.GC30062@elte.hu>
 <20111206085816.GA11116@elte.hu>
 <4EDDE5D0.7030906@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4EDDE5D0.7030906@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=AWL,BAYES_00 autolearn=no SpamAssassin version=3.3.1
	-2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
	[score: 0.0000]
	0.0 AWL                    AWL: From: address is in the auto white-list
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com> wrote:

> > But the hibernation angle should be considered. Hibernation 
> > already has to deal with the case where someone physically 
> > unplugs a CPU and then resumes from the disk image, right? 
> > How does the hibernation code handle that case currently?
> 
> Oh, wait a minute. Are we talking about physical CPU Hotplug 
> in between hibernation and restore? AFAIK, currently we don't 
> handle that at all. [...]

Well, not hotplug, but plain old-fashioned: 'hibernate the box, 
take out a CPU physically and thaw' kind of hardware change.

How will the hibernation code handle this case?

Thanks,

	Ingo
