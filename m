Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754825Ab2EUM3I (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2012 08:29:08 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:45871 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754431Ab2EUM3F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2012 08:29:05 -0400
Date: Mon, 21 May 2012 14:28:59 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Vlad Zolotarov <vlad@scalemp.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "Shai Fultheim (Shai@ScaleMP.com)" <Shai@scalemp.com>,
        Ido Yariv <ido@wizery.com>
Subject: Re: [PATCH v3 1/2] x86: Define early read-mostly per-cpu macros
Message-ID: <20120521122859.GA17065@gmail.com>
References: <1337527154.6093.15.camel@vlad>
 <20120521084626.GD31407@gmail.com>
 <10387490.kMM6uuuW2C@vlad>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <10387490.kMM6uuuW2C@vlad>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Vlad Zolotarov <vlad@scalemp.com> wrote:

> On Monday, May 21, 2012 10:46:26 AM Ingo Molnar wrote:
> > * Vlad Zolotarov <vlad@scalemp.com> wrote:
> > > Some read-mostly per-cpu data may need to be declared or defined early,
> > > so it can be initialized and accessed before per_cpu areas are
> > > allocated.
> > > 
> > > Only the data that resides in the per_cpu areas should be read-mostly,
> > > as there is little benefit in optimizing cache lines on initialization.
> > > 
> > > Signed-off-by: Vlad Zolotarov <vlad@scalemp.com>
> > > Signed-off-by: Ido Yariv <ido@wizery.com>
> > > Signed-off-by: Shai Fultheim <shai@scalemp.com>
> > 
> > That's not a valid signoff chain. If you send me a patch then
> > you should be the last SOB - but as the author you should be the
> > first SOB as well. I edited the two SOBs to be Acked-by's.
> 
> Thanks, Ingo. I understand. However the "history" of this 
> patch is not as simple as u represent. ;)
> 
> It was originally written by Ido and I just posted it (then I 
> put my SOB at the end of SOB list). But after u noted that it 
> didn't compile on !SMP i reworked it but yet Ido did at least 
> half of the coding, so I put my SOB at the first place (as I 
> was the last one writing the code) and then Ido's as he 
> actually wrote the code in this patch as well and I do wanted 
> to give him a credit.

The proper way to do that is to add a "Originally-From: " tag, 
or to keep him as the author (and first SOB) and desccribe your 
own changes as comments between the SOBs:

 Signed-off-by: Original Author
 [ cleaned up the code a bit ]
 Signed-off-by: Second Author
 [ restructured it ]
 Signed-off-by: You

> Do u still think changing his (Ido's) SOB to Acked-by was the 
> right thing to do?

If they agree with it then you can send it to me that way - or 
the above way, or you can add any extra authors in a copyright 
notice - but the signoff chain should be a chain, with the 
primary author as the first SOB and the person sending me the 
patch being the last SOB.

Thanks,

	Ingo
