Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755511Ab2HGRus (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2012 13:50:48 -0400
Received: from mga02.intel.com ([134.134.136.20]:48349 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752435Ab2HGRuq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2012 13:50:46 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,351,1309762800"; 
   d="scan'208";a="182779197"
Subject: Re: do_IRQ: 1.55 No irq handler for vector (irq -1)
From: Suresh Siddha <suresh.b.siddha@intel.com>
Reply-To: Suresh Siddha <suresh.b.siddha@intel.com>
To: Robert Richter <robert.richter@amd.com>
Cc: Borislav Petkov <bp@amd64.org>, mingo@kernel.org, hpa@zytor.com,
        linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, a.p.zijlstra@chello.nl,
        tglx@linutronix.de, linux-tip-commits@vger.kernel.org,
        "Petkov, Borislav" <borislav.petkov@amd.com>
Date: Tue, 07 Aug 2012 10:47:40 -0700
In-Reply-To: <20120807172806.GK3732@erda.amd.com>
References: <1337644682-19854-1-git-send-email-suresh.b.siddha@intel.com>
	 <tip-332afa656e76458ee9cf0f0d123016a0658539e4@git.kernel.org>
	 <20120807153149.GI3732@erda.amd.com>
	 <20120807154134.GA7456@aftab.osrc.amd.com>
	 <1344356662.2041.48.camel@sbsiddha-desk.sc.intel.com>
	 <20120807172806.GK3732@erda.amd.com>
Organization: Intel Corp
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.0.3 (3.0.3-1.fc15) 
Content-Transfer-Encoding: 7bit
Message-ID: <1344361660.27383.4.camel@sbsiddha-desk.sc.intel.com>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-08-07 at 19:28 +0200, Robert Richter wrote:
> On 07.08.12 09:24:21, Suresh Siddha wrote:
> > Boris, Robert, Can you please send me the complete dmesg
> > and /proc/interrupts on a successful boot?
> 
> Sent to you in private mail.

Thanks.

> 
> What information are you looking for specifically? Maybe we can
> provide something here on the ml.

I was looking for what APIC mode and it was a PIC/IO-APIC interrupt.

So it looks like it is using logical flat mode and the interrupt was
from IO-APIC.

So most likely on your system after a successful boot, if you manually
set the affinity of one of those SATA/PATA interrupts to a specific
logical cpu say 0, I think the interrupt still get routed to other
logical cpu's. Can you confirm?

thanks,
suresh

