Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756300Ab2EUN1J (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2012 09:27:09 -0400
Received: from orion.tchmachines.com ([208.76.84.200]:52557 "EHLO
	orion.tchmachines.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755598Ab2EUN1H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2012 09:27:07 -0400
From: Vlad Zolotarov <vlad@scalemp.com>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "Shai Fultheim (Shai@ScaleMP.com)" <Shai@scalemp.com>,
        Ido Yariv <ido@wizery.com>
Subject: Re: [PATCH v3 1/2] x86: Define early read-mostly per-cpu macros
Date: Mon, 21 May 2012 16:27:01 +0300
Message-ID: <40553348.tpY4157LUQ@vlad>
Organization: ScaleMP Ltd.
User-Agent: KMail/4.8.2 (Linux/3.2.0-24-generic; KDE/4.8.2; i686; ; )
In-Reply-To: <20120521122859.GA17065@gmail.com>
References: <1337527154.6093.15.camel@vlad> <10387490.kMM6uuuW2C@vlad> <20120521122859.GA17065@gmail.com>
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

> > 
> > Thanks, Ingo. I understand. However the "history" of this
> > patch is not as simple as u represent. ;)
> > 
> > It was originally written by Ido and I just posted it (then I
> > put my SOB at the end of SOB list). But after u noted that it
> > didn't compile on !SMP i reworked it but yet Ido did at least
> > half of the coding, so I put my SOB at the first place (as I
> > was the last one writing the code) and then Ido's as he
> > actually wrote the code in this patch as well and I do wanted
> > to give him a credit.
> 
> The proper way to do that is to add a "Originally-From: " tag,
> or to keep him as the author (and first SOB) and desccribe your
> own changes as comments between the SOBs:
> 
>  Signed-off-by: Original Author
>  [ cleaned up the code a bit ]
>  Signed-off-by: Second Author
>  [ restructured it ]
>  Signed-off-by: You
> 
> > Do u still think changing his (Ido's) SOB to Acked-by was the
> > right thing to do?
> 
> If they agree with it then you can send it to me that way - or
> the above way, or you can add any extra authors in a copyright
> notice - but the signoff chain should be a chain, with the
> primary author as the first SOB and the person sending me the
> patch being the last SOB.

Got it. I think the "above" way would describe the reality in the most exact 
manner and would give the credit in the most exact manner.

I'd like to respin the series if it's still possible. 
Pls., let me know.

thanks,
vlad

> 
> Thanks,
> 
> 	Ingo
