Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751840Ab2EULMX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2012 07:12:23 -0400
Received: from orion.tchmachines.com ([208.76.84.200]:46433 "EHLO
	orion.tchmachines.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751090Ab2EULMW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2012 07:12:22 -0400
From: Vlad Zolotarov <vlad@scalemp.com>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "Shai Fultheim (Shai@ScaleMP.com)" <Shai@scalemp.com>,
        Ido Yariv <ido@wizery.com>
Subject: Re: [PATCH v3 1/2] x86: Define early read-mostly per-cpu macros
Date: Mon, 21 May 2012 14:12:18 +0300
Message-ID: <10387490.kMM6uuuW2C@vlad>
Organization: ScaleMP Ltd.
User-Agent: KMail/4.8.2 (Linux/3.2.0-24-generic; KDE/4.8.2; i686; ; )
In-Reply-To: <20120521084626.GD31407@gmail.com>
References: <1337527154.6093.15.camel@vlad> <20120521084626.GD31407@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - orion.tchmachines.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - scalemp.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, May 21, 2012 10:46:26 AM Ingo Molnar wrote:
> * Vlad Zolotarov <vlad@scalemp.com> wrote:
> > Some read-mostly per-cpu data may need to be declared or defined early,
> > so it can be initialized and accessed before per_cpu areas are
> > allocated.
> > 
> > Only the data that resides in the per_cpu areas should be read-mostly,
> > as there is little benefit in optimizing cache lines on initialization.
> > 
> > Signed-off-by: Vlad Zolotarov <vlad@scalemp.com>
> > Signed-off-by: Ido Yariv <ido@wizery.com>
> > Signed-off-by: Shai Fultheim <shai@scalemp.com>
> 
> That's not a valid signoff chain. If you send me a patch then
> you should be the last SOB - but as the author you should be the
> first SOB as well. I edited the two SOBs to be Acked-by's.

Thanks, Ingo. I understand. However the "history" of this patch is not as 
simple as u represent. ;) 

It was originally written by Ido and I just posted it (then I put my SOB at 
the end of SOB list). But after u noted that it didn't compile on !SMP i 
reworked it but yet Ido did at least half of the coding, so I put my SOB at 
the first place (as I was the last one writing the code) and then Ido's as he 
actually wrote the code in this patch as well and I do wanted to give him a 
credit.

Do u still think changing his (Ido's) SOB to Acked-by was the right thing to 
do?

Thanks,
vlad

> 
> Thanks,
> 
> 	Ingo
