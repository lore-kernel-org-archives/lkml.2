Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753319Ab0LLOMR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Dec 2010 09:12:17 -0500
Received: from 63.mail-out.ovh.net ([91.121.185.56]:46367 "HELO
	63.mail-out.ovh.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753282Ab0LLOMP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Dec 2010 09:12:15 -0500
Date: Sun, 12 Dec 2010 15:07:27 +0100
From: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
To: Igor Plyatov <plyatov@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux@maxim.org.za, nicolas.ferre@atmel.com, linux@arm.linux.org.uk,
        costa.antonior@gmail.com, ryan@bluewatersys.com,
        christian.glindkamp@taskit.de, pgsellmann@portner-elektronik.at
Subject: Re: [PATCH v4] mach-at91: Support for gsia18s board added
Message-ID: <20101212140727.GI19897@game.jcrosoft.org>
References: <1292000411-6691-1-git-send-email-plyatov@gmail.com>
 <20101212005048.GH19897@game.jcrosoft.org>
 <1292135848.2456.19.camel@homepc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1292135848.2456.19.camel@homepc>
X-PGP-Key: http://uboot.jcrosoft.org/plagnioj.asc
X-PGP-key-fingerprint: 6309 2BBA 16C8 3A07 1772 CC24 DEFC FFA3 279C CE7C
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Ovh-Tracer-Id: 15578232586411420519
X-Ovh-Remote: 213.251.161.87 (ns32433.ovh.net)
X-Ovh-Local: 213.186.33.20 (ns0.ovh.net)
X-Spam-Check: DONE|U 0.5/N
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09:37 Sun 12 Dec     , Igor Plyatov wrote:
> Dear Jean-Christophe,
> 
> > On 20:00 Fri 10 Dec     , Igor Plyatov wrote:
> > > The GS_IA18_S (GMS) is a carrier board from GeoSIG Ltd used with the
> > > Stamp9G20 SoM from Taskit company.
> > > It operate as an internet accelerometer.
> > > 
> > > Signed-off-by: Igor Plyatov <plyatov@gmail.com>
> > > ---
> > >  arch/arm/configs/gsia18s_defconfig        |  147 +++++++
> > please no new defconfig
> > start to merge them
> 
> I already write that it is not possible to use same defconfig for our
> board and Stamp9G20, because 69 different CONFIG_xxx options required
> for our machine (compared with Portux G20 and Stamp9G20) and our options
> very excessive for other devices based on the Stamp9G20.
> This device for the embedded, where space constraints exists for memory
> and it is required to save resources as more as possible.
sorry as I explain before if you have exclusive option you need to create
kconfig options which are board specific to manage them
we work to reduce the number of defconfig in the mainline
and it's not PortuxG20 and Stamp9g20 specific but to have only one defconfig
for all 9g20 at a first step and late for all sam9
> 
> > your patch contain a lots of whitespace please fix it
> 
> There is no problems with whitespace. This patch checked by
> scripts/checkpatch.pl twice. It seems your mailer corrupt this patch.
my mailer no way mutt does not do it
and when I edit with vim I saw the whitespace too
please check again
> 
> > > +
> > > +/*
> > > + * Up to date linux/arch/arm/tools/mach-types database required to support this.
> > > +MACHINE_START(GSIA18S, "GS_IA18_S")
> > > +*/
> > > +MACHINE_START(STAMP9G20, "GS_IA18_S")
> > if you do this you must use system_rev to identify the board
> 
> I can cite Christian Glindkamp:
> "And for different carrier boards, system_rev does not make sense at
> all."
> 
> Please, use more testimony why it is required to use system_rev here.
> Yours position does not clear for me.
> You can point me to the right documentation or discussion about this
> requirements in the mail archives...
two bards with the same machine id NACK as we can not compile them in the same
kernel and this a target we all work on to allow
if you want to tuse the same machine id as I did for other boards you must use
system_rev or any detection to identify tehm

Best Regards,
J.
