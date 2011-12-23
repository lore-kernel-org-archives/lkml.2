Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757636Ab1LWS40 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Dec 2011 13:56:26 -0500
Received: from mga03.intel.com ([143.182.124.21]:42351 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757613Ab1LWS4X (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Dec 2011 13:56:23 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="50162099"
Subject: Re: [patch 4/5] x86, x2apic: allow "nox2apic" to disable x2apic
 mode setup by bios
From: Suresh Siddha <suresh.b.siddha@intel.com>
Reply-To: Suresh Siddha <suresh.b.siddha@intel.com>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "flyboy@gmail.com" <flyboy@gmail.com>
Date: Fri, 23 Dec 2011 11:01:29 -0800
In-Reply-To: <CAE9FiQUeB-3uxJAMiHsz=uPWoFv5Hg1pVepz7aU6YtqOxMC-=Q@mail.gmail.com>
References: <20111222014514.410584964@sbsiddha-desk.sc.intel.com>
	 <20111222014632.644264512@sbsiddha-desk.sc.intel.com>
	 <CAE9FiQUeB-3uxJAMiHsz=uPWoFv5Hg1pVepz7aU6YtqOxMC-=Q@mail.gmail.com>
Organization: Intel Corp
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.0.3 (3.0.3-1.fc15) 
Content-Transfer-Encoding: 7bit
Message-ID: <1324666889.4167.35.camel@sbsiddha-desk.sc.intel.com>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-12-21 at 23:24 -0800, Yinghai Lu wrote:
> On Wed, Dec 21, 2011 at 5:45 PM, Suresh Siddha
> <suresh.b.siddha@intel.com> wrote:
> 
> > @@ -1453,12 +1462,17 @@ static void disable_x2apic(void)
> >        if (msr & X2APIC_ENABLE) {
> >                u32 x2apic_id = read_apic_id();
> >
> > -               if (x2apic_id > 255)
> > -                       panic("Can not disable x2apic, id: %08x\n", x2apic_id);
> > +               if (x2apic_id >= 255)
> > +                       panic("Cannot disable x2apic, id: %08x\n", x2apic_id);
> 
> can not be applied cleanly.
> 
> update it a little bit.
> 
> need to use attached one to replace 4/5.
> 

Thanks Yinghai. updated patch look good.

Ingo, can you please queue this series to -tip?

thanks,
suresh

