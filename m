Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755238Ab2GXC3M (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jul 2012 22:29:12 -0400
Received: from ch1ehsobe001.messaging.microsoft.com ([216.32.181.181]:25897
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755111Ab2GXC3L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jul 2012 22:29:11 -0400
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: -2
X-BigFish: VS-2(zz98dI1432Izz1202hzz8275bhz2dh2a8h668h839h944hd25hf0ah107ah)
Date: Tue, 24 Jul 2012 10:30:44 +0800
From: Zhao Chenhui <chenhui.zhao@freescale.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: <linuxppc-dev@lists.ozlabs.org>, <galak@kernel.crashing.org>,
        <linux-kernel@vger.kernel.org>, <leoli@freescale.com>
Subject: Re: [PATCH] mpc85xx_defconfig: add IDE support for MPC85xxCDS
Message-ID: <20120724023044.GA30275@localhost.localdomain>
References: <1342788325-27609-1-git-send-email-chenhui.zhao@freescale.com>
 <20120720150900.082afc7c@pyramind.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20120720150900.082afc7c@pyramind.ukuu.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: freescale.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 20, 2012 at 03:09:00PM +0100, Alan Cox wrote:
> On Fri, 20 Jul 2012 20:45:25 +0800
> Zhao Chenhui <chenhui.zhao@freescale.com> wrote:
> 
> > Add IDE support for MPC85xxCDS.
> > 
> > Signed-off-by: Zhao Chenhui <chenhui.zhao@freescale.com>
> > ---
> >  arch/powerpc/configs/mpc85xx_defconfig |    2 ++
> >  1 files changed, 2 insertions(+), 0 deletions(-)
> > 
> > diff --git a/arch/powerpc/configs/mpc85xx_defconfig b/arch/powerpc/configs/mpc85xx_defconfig
> > index 03ee911..45eda33 100644
> > --- a/arch/powerpc/configs/mpc85xx_defconfig
> > +++ b/arch/powerpc/configs/mpc85xx_defconfig
> > @@ -105,6 +105,8 @@ CONFIG_BLK_DEV_RAM=y
> >  CONFIG_BLK_DEV_RAM_SIZE=131072
> >  CONFIG_MISC_DEVICES=y
> >  CONFIG_EEPROM_LEGACY=y
> > +CONFIG_IDE=y
> > +CONFIG_BLK_DEV_VIA82CXXX=y
> 
> CONFIG_IDE is obsolete we shouldn't be adding it to anything as it will
> eventually go away. Please use the ATA drivers.
> 

Thanks. I will replace it with the ATA driver.

-Chenhui

