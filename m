Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753324Ab0LLOWP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Dec 2010 09:22:15 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:36173 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751322Ab0LLOWO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Dec 2010 09:22:14 -0500
Date: Sun, 12 Dec 2010 14:22:00 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
Cc: Igor Plyatov <plyatov@gmail.com>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux@maxim.org.za,
        nicolas.ferre@atmel.com, costa.antonior@gmail.com,
        ryan@bluewatersys.com, christian.glindkamp@taskit.de,
        pgsellmann@portner-elektronik.at
Subject: Re: [PATCH v4] mach-at91: Support for gsia18s board added
Message-ID: <20101212142200.GG8665@n2100.arm.linux.org.uk>
References: <1292000411-6691-1-git-send-email-plyatov@gmail.com> <20101212005048.GH19897@game.jcrosoft.org> <1292135848.2456.19.camel@homepc> <20101212140727.GI19897@game.jcrosoft.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101212140727.GI19897@game.jcrosoft.org>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Dec 12, 2010 at 03:07:27PM +0100, Jean-Christophe PLAGNIOL-VILLARD wrote:
> On 09:37 Sun 12 Dec     , Igor Plyatov wrote:
> > Dear Jean-Christophe,
> > 
> > > On 20:00 Fri 10 Dec     , Igor Plyatov wrote:
> > > > +/*
> > > > + * Up to date linux/arch/arm/tools/mach-types database required to support this.

Please wrap comments.

> > > > +MACHINE_START(GSIA18S, "GS_IA18_S")
> > > > +*/
> > > > +MACHINE_START(STAMP9G20, "GS_IA18_S")
> > > if you do this you must use system_rev to identify the board
> > 
> > I can cite Christian Glindkamp:
> > "And for different carrier boards, system_rev does not make sense at
> > all."
> > 
> > Please, use more testimony why it is required to use system_rev here.
> > Yours position does not clear for me.
> > You can point me to the right documentation or discussion about this
> > requirements in the mail archives...
>
> two bards with the same machine id NACK as we can not compile them in the same
> kernel and this a target we all work on to allow
> if you want to tuse the same machine id as I did for other boards you must use
> system_rev or any detection to identify tehm

Well, the platform was registered into the machine database on 10th
December, so it's missed my recent update to the file queued for the next
-rc.

I also notice that the name has been changed - machine_is_gsia18s() vs
MACH_TYPE_GS_IA18_S / CONFIG_MACH_GS_IA18_S.  This means I'll simply
delete it from any future updates until someone talks to me about fixing
the entry, exactly as I'm doing with a bunch of others who also haven't
contacted me.

All it takes is an email and the entry gets quickly fixed...
