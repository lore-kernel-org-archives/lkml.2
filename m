Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932213Ab1KBNeH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Nov 2011 09:34:07 -0400
Received: from cantor2.suse.de ([195.135.220.15]:54828 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932136Ab1KBNeC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Nov 2011 09:34:02 -0400
Date: Wed, 2 Nov 2011 14:34:00 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: Fabio Estevam <festevam@gmail.com>
Cc: Paul Bolle <pebolle@tiscali.nl>,
        Fabio Estevam <fabio.estevam@freescale.com>,
        Russell King <linux@arm.linux.org.uk>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        =?ISO-8859-15?Q?Uwe_Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
Subject: Re: [PATCH] [TRIVIAL] ARM: imx: Fix typo
 'MACH_MX31_3DS_MXC_NAND_USE_BBT'
In-Reply-To: <CAOMZO5DZ6KYa_SLVavorPPyV_Ggspa4Cae+eK7oj1mh=O4J4+w@mail.gmail.com>
Message-ID: <alpine.LNX.2.00.1111021433220.348@pobox.suse.cz>
References: <1318421062.2336.4.camel@x61.thuisdomein> <alpine.LNX.2.00.1110311110370.3541@pobox.suse.cz> <CAOMZO5DZ6KYa_SLVavorPPyV_Ggspa4Cae+eK7oj1mh=O4J4+w@mail.gmail.com>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 1 Nov 2011, Fabio Estevam wrote:

> >> Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
> >> ---
> >> This is trivial because this is what apparently was intended. On the
> >> other hand this should open code paths that were hidden until now. So
> >> perhaps this needs the maintainer's approval. (I cannot meaningfully
> >> test this.)
> >
> > I'd like to have this tested by some relevant people before taking it
> > myself (added some CCs).
> 
> On a mx31pdk board I get the following with this patch applied and
> CONFIG_MACH_MX31_3DS_MXC_NAND_USE_BBT selected:
> 
> NAND device: Manufacturer ID: 0xec, Chip ID: 0xaa (Samsung NAND 256MiB
> 1,8V 8-bit)
> Bad block table not found for chip 0
> Bad block table not found for chip 0
> Scanning device for bad blocks
> Registering mxc_nand as whole device
> 
> Tested-by: Fabio Estevam <fabio.estevam@freescale.com>

Thank you, I will be appplying it.

-- 
Jiri Kosina
SUSE Labs
