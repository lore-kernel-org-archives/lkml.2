Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755235Ab1C1Rpr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Mar 2011 13:45:47 -0400
Received: from one.firstfloor.org ([213.235.205.2]:53912 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751089Ab1C1Rpq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Mar 2011 13:45:46 -0400
Date: Mon, 28 Mar 2011 19:45:42 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Jiri Kosina <jkosina@suse.cz>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>,
        Linus <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>, x86@kernel.org,
        Len Brown <lenb@kernel.org>, linux-pm@lists.linux-foundation.org,
        Henrique de Moraes Holschuh <hmh@hmh.eng.br>,
        Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@zytor.com>, Andi Kleen <andi@firstfloor.org>,
        Ondrej Zary <linux@rainbow-software.org>
Subject: Re: [PATCH] apm: orphan the driver
Message-ID: <20110328174542.GW21838@one.firstfloor.org>
References: <20110326172204.05e52c10.sfr@canb.auug.org.au> <alpine.LRH.2.00.1103281443240.8162@twin.jikos.cz> <20110329004438.d9e755ef.sfr@canb.auug.org.au> <alpine.LNX.2.00.1103281604040.26754@pobox.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LNX.2.00.1103281604040.26754@pobox.suse.cz>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 28, 2011 at 04:05:14PM +0200, Jiri Kosina wrote:
> On Tue, 29 Mar 2011, Stephen Rothwell wrote:
> 
> > > I still have some hardware that uses APM and put a new 2.6 on it time 
> > > to time, so I can take this driver over if you want to. According to 
> > > git log it's really low effort anyway :)
> > 
> > If you want it, its yours :-)
> 
> Not really fighting for maintaining it actively, but can certainly give it 
> some care when necessary.

FWIW
Since Len plans some larger changes to the idle code 
(moving everything to cpuidle) active care may be needed soon.

Effectively it would need a APM cpuidle driver.

Just that you know what you're signing up for...

-Andi
