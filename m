Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758076Ab1EaSQy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 May 2011 14:16:54 -0400
Received: from s15228384.onlinehome-server.info ([87.106.30.177]:37134 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757978Ab1EaSQw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 May 2011 14:16:52 -0400
Date: Tue, 31 May 2011 20:16:50 +0200
From: Borislav Petkov <bp@amd64.org>
To: Joe Perches <joe@perches.com>
Cc: Ingo Molnar <mingo@elte.hu>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [GIT PULL] x86 fixes
Message-ID: <20110531181650.GA1854@gere.osrc.amd.com>
References: <20110531163022.GA15435@elte.hu>
 <1306859709.20175.27.camel@Joe-Laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1306859709.20175.27.camel@Joe-Laptop>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 31, 2011 at 09:35:09AM -0700, Joe Perches wrote:
> On Tue, 2011-05-31 at 18:30 +0200, Ingo Molnar wrote:
> > diff --git a/arch/x86/kernel/process.c b/arch/x86/kernel/process.c
> []
> > @@ -642,7 +642,7 @@ static int __init idle_setup(char *str)
> >  		boot_option_idle_override = IDLE_POLL;
> >  	} else if (!strcmp(str, "mwait")) {
> >  		boot_option_idle_override = IDLE_FORCE_MWAIT;
> > -		WARN_ONCE(1, "\idle=mwait\" will be removed in 2012\"\n");
> > +		WARN_ONCE(1, "\"idle=mwait\" will be removed in 2012\"\n");
> 
> Extra quote at end.  More likely you want:
> 
> 		WARN_ONCE(1, "\"idle=mwait\" will be removed in 2012\n");

Crap, there's no fixing this string :)

Reportedly, there's another fix from Len:

lkml.kernel.org/r/20110531101934.2737dc90.sfr@canb.auug.org.au

which is more complete. Ingo, you could drop this one.

Thanks.

-- 
Regards/Gruss,
Boris.

Advanced Micro Devices GmbH
Einsteinring 24, 85609 Dornach
General Managers: Alberto Bozzo, Andrew Bowd
Registration: Dornach, Gemeinde Aschheim, Landkreis Muenchen
Registergericht Muenchen, HRB Nr. 43632
