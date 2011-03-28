Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753919Ab1C1OOc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Mar 2011 10:14:32 -0400
Received: from mail.perches.com ([173.55.12.10]:4304 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752443Ab1C1OOb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Mar 2011 10:14:31 -0400
Subject: Re: [PATCH] apm: orphan the driver
From: Joe Perches <joe@perches.com>
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
In-Reply-To: <alpine.LNX.2.00.1103281604040.26754@pobox.suse.cz>
References: <20110326172204.05e52c10.sfr@canb.auug.org.au>
	 <alpine.LRH.2.00.1103281443240.8162@twin.jikos.cz>
	 <20110329004438.d9e755ef.sfr@canb.auug.org.au>
	 <alpine.LNX.2.00.1103281604040.26754@pobox.suse.cz>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 28 Mar 2011 07:14:27 -0700
Message-ID: <1301321667.30628.21.camel@Joe-Laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-03-28 at 16:05 +0200, Jiri Kosina wrote:
> On Tue, 29 Mar 2011, Stephen Rothwell wrote:
> > > I still have some hardware that uses APM and put a new 2.6 on it time 
> > > to time, so I can take this driver over if you want to. According to 
> > > git log it's really low effort anyway :)
> > If you want it, its yours :-)
> Not really fighting for maintaining it actively, but can certainly give it 
> some care when necessary.
> diff --git a/MAINTAINERS b/MAINTAINERS
[]
> @@ -548,8 +548,9 @@ S:	Maintained
>  F:	sound/aoa/
>  
>  APM DRIVER
> -L:	linux-laptop@vger.kernel.org
> -S:	Orphan
> +M:	Jiri Kosina <jkosina@suse.cz>
> +L:	linux-kernel@vger.kernel.org

Please don't add L: LKML as it's the default
and it could confuse people that read the file
and see some sections with LKML and other without
and may think that LKML is somehow optional.

> +S:	Maintained

If you're not actively maintaining it, maybe
S:	Odd Fixes
instead?


