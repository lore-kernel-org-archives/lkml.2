Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753256Ab1JMTFV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Oct 2011 15:05:21 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:39122 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751259Ab1JMTFS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Oct 2011 15:05:18 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [PATCH v2 2/3] Mutually exclude cpu online and suspend/hibernate
Date: Thu, 13 Oct 2011 21:07:38 +0200
User-Agent: KMail/1.13.6 (Linux/3.1.0-rc9+; KDE/4.6.0; x86_64; ; )
Cc: Borislav Petkov <bp@amd64.org>, Tejun Heo <tj@kernel.org>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, "pavel@ucw.cz" <pavel@ucw.cz>,
        "len.brown@intel.com" <len.brown@intel.com>,
        "mingo@elte.hu" <mingo@elte.hu>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "suresh.b.siddha@intel.com" <suresh.b.siddha@intel.com>,
        "lucas.demarchi@profusion.mobi" <lucas.demarchi@profusion.mobi>,
        "rusty@rustcorp.com.au" <rusty@rustcorp.com.au>,
        "rdunlap@xenotime.net" <rdunlap@xenotime.net>,
        "vatsa@linux.vnet.ibm.com" <vatsa@linux.vnet.ibm.com>,
        "ashok.raj@intel.com" <ashok.raj@intel.com>,
        "tigran@aivazian.fsnet.co.uk" <tigran@aivazian.fsnet.co.uk>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "hpa@zytor.com" <hpa@zytor.com>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>
References: <Pine.LNX.4.44L0.1110131400000.2026-100000@iolanthe.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.1110131400000.2026-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201110132107.38604.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, October 13, 2011, Alan Stern wrote:
> On Thu, 13 Oct 2011, Borislav Petkov wrote:
> 
> > On Thu, Oct 13, 2011 at 12:06:02PM -0400, Tejun Heo wrote:
> > > I hate to sound like a broken recorder but the above patch isn't
> > > strictly correct for hot-swap cases, right?
> > 
> > hpa is working on a ucode loading solution which will take care of your
> > hotswap case too.
> 
> You know, it would be a good idea to take a step back and think about a 
> broader picture.  Suspend and hibernate need to be mutually exclusive 
> with other things as well.  The two examples which people have been 
> talking about are firmware updates (if the computer goes to sleep 
> while the firmware is being changed, it ends up as a brick) and battery 
> recharging (the CPU needs to respond quickly to temperature and charger 
> events).
> 
> There ought to be a general-purpose "prevent system sleep" mechanism 
> usable both from within the kernel and from userspace.

I have a patch for that ready, will post it later today.

Thanks,
Rafael
