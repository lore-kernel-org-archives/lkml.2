Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935087Ab1JET2M (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Oct 2011 15:28:12 -0400
Received: from casper.infradead.org ([85.118.1.10]:60971 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934271Ab1JET2M convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Oct 2011 15:28:12 -0400
Subject: RE: [PATCH 0/8] Online/offline BSP on x86
From: Peter Zijlstra <peterz@infradead.org>
To: "Yu, Fenghua" <fenghua.yu@intel.com>
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
        H Peter Anvin <hpa@zytor.com>, "Luck, Tony" <tony.luck@intel.com>,
        "Mallick, Asit K" <asit.k.mallick@intel.com>,
        "Siddha, Suresh B" <suresh.b.siddha@intel.com>,
        "Brown, Len" <len.brown@intel.com>,
        linux-kernel <linux-kernel@vger.kernel.org>
Date: Wed, 05 Oct 2011 21:28:04 +0200
In-Reply-To: <493994B35A117E4F832F97C4719C4C040136F7CC16@orsmsx505.amr.corp.intel.com>
References: <1317832759-10223-1-git-send-email-fenghua.yu@intel.com>
	 <1317842195.6766.40.camel@twins>
	 <493994B35A117E4F832F97C4719C4C040136F7CC16@orsmsx505.amr.corp.intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.0.3- 
Message-ID: <1317842884.6766.45.camel@twins>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-10-05 at 12:22 -0700, Yu, Fenghua wrote:
> 
> > -----Original Message-----
> > From: Peter Zijlstra [mailto:peterz@infradead.org]
> > Sent: Wednesday, October 05, 2011 12:17 PM
> > To: Yu, Fenghua
> > Cc: Ingo Molnar; Thomas Gleixner; H Peter Anvin; Zwane Mwaikambo; Luck,
> > Tony; Mallick, Asit K; Siddha, Suresh B; Len Brown; linux-kernel
> > Subject: Re: [PATCH 0/8] Online/offline BSP on x86
> > 
> > On Wed, 2011-10-05 at 09:39 -0700, Fenghua Yu wrote:
> > >
> > > BSP or CPU0 has been the last obstacle to CPU hotplug on x86. This
> > patch set
> > > implements BSP online and offline and removes this obstacle to CPU
> > hotplug.
> > 
> > Are you talking about physical cpu hotplug on x86? And you need to
> > offline the BSP so you can replace socket0 ?
> 
> 
> This patch set is for BSP online/offline.

Yes, I got that part. Why do you care?
