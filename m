Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752802Ab1FAGSc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jun 2011 02:18:32 -0400
Received: from s15228384.onlinehome-server.info ([87.106.30.177]:44139 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752301Ab1FAGSb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jun 2011 02:18:31 -0400
Date: Wed, 1 Jun 2011 08:18:16 +0200
From: Borislav Petkov <bp@amd64.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Borislav Petkov <bp@amd64.org>, Joe Perches <joe@perches.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [GIT PULL] x86 fixes
Message-ID: <20110601061816.GB21247@aftab>
References: <20110531163022.GA15435@elte.hu>
 <1306859709.20175.27.camel@Joe-Laptop>
 <20110531181650.GA1854@gere.osrc.amd.com>
 <BANLkTi=ysOYxxu1_PV3R1BNgjM996A2CKg@mail.gmail.com>
 <20110601060046.GA27375@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110601060046.GA27375@elte.hu>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 01, 2011 at 02:00:46AM -0400, Ingo Molnar wrote:
> 
> * Linus Torvalds <torvalds@linux-foundation.org> wrote:
> 
> > On Wed, Jun 1, 2011 at 3:16 AM, Borislav Petkov <bp@amd64.org> wrote:
> > >
> > > Crap, there's no fixing this string :)
> > 
> > I tried to fix it up in the merge.  We call these "evil merges" in 
> > git-speak, but I hope the problem was worth doing one ;)
> 
> You have not pushed it out yet, right? [ Or if you have then the 
> evilness is well hidden! :-) ]

Oh yeah, looks good: af0d6a0a3a30946f7df69c764791f1b0643f7cd6

Thank you Linus for being evil! :-)

-- 
Regards/Gruss,
Boris.

Advanced Micro Devices GmbH
Einsteinring 24, 85609 Dornach
General Managers: Alberto Bozzo, Andrew Bowd
Registration: Dornach, Gemeinde Aschheim, Landkreis Muenchen
Registergericht Muenchen, HRB Nr. 43632
