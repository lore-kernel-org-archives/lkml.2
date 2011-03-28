Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754682Ab1C1VT0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Mar 2011 17:19:26 -0400
Received: from cantor.suse.de ([195.135.220.2]:50546 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753064Ab1C1VTZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Mar 2011 17:19:25 -0400
Date: Mon, 28 Mar 2011 23:19:16 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andi Kleen <andi@firstfloor.org>, "H. Peter Anvin" <hpa@zytor.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>, x86@kernel.org,
        Len Brown <lenb@kernel.org>, linux-pm@lists.linux-foundation.org,
        Henrique de Moraes Holschuh <hmh@hmh.eng.br>,
        Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
        Ondrej Zary <linux@rainbow-software.org>
Subject: Re: [PATCH] apm: orphan the driver
In-Reply-To: <AANLkTimqE2YZCH5GonnqeHGGBwzggTymauS1KYuTsqOX@mail.gmail.com>
Message-ID: <alpine.LNX.2.00.1103282309290.26754@pobox.suse.cz>
References: <20110326172204.05e52c10.sfr@canb.auug.org.au> <alpine.LRH.2.00.1103281443240.8162@twin.jikos.cz> <20110329004438.d9e755ef.sfr@canb.auug.org.au> <alpine.LNX.2.00.1103281604040.26754@pobox.suse.cz> <20110328174542.GW21838@one.firstfloor.org>
 <4D90CC0B.8070105@zytor.com> <20110328182123.GX21838@one.firstfloor.org> <AANLkTimqE2YZCH5GonnqeHGGBwzggTymauS1KYuTsqOX@mail.gmail.com>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 28 Mar 2011, Linus Torvalds wrote:

> > Phasing out APM idle at least would be reasonable.  resumably even if the old
> > laptops still work they are likely on AC because their batteries have
> > long died. So using a bit more power in idle shouldn't be a big
> > issue.
> 
> Agreed. Especially since I'm not at all convinced that APM CPU idling
> ever really worked in the first place.
> 
> And as you say, it's not a catastrophic failure even if we were to
> remove it, and even if it were to have mattered on those old laptops
> years ago. I think we can happily say "not worth worrying about" when
> it comes to APM_CPU_IDLE.
> 
> And shutdown, suspend and screensaver should all be much easier to
> continue to support - they shouldn't have any serious infrastructure
> issues.

APM_CPU_IDLE removal doesn't really sound as a disaster, yes. I doubt 
anyone would even notice.

So deprecating it altogether with planned Len's code reshuffling seems 
like reasonable aproach to me.

_SUSPEND, poweroff and probably _STANDBY are the parts I would care much 
more about.

-- 
Jiri Kosina
SUSE Labs, Novell Inc.
