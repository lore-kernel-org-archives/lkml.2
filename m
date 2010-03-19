Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752866Ab0CSAFT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Mar 2010 20:05:19 -0400
Received: from smtp188-pc.aruba.it ([62.149.157.188]:50665 "HELO
	smtp2-pc.aruba.it" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with SMTP id S1752039Ab0CSAFR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Mar 2010 20:05:17 -0400
From: Michele Ballabio <barra_cuda@katamail.com>
To: Takashi Iwai <tiwai@suse.de>
Subject: Re: [PATCH] ALSA: hda - Add ASRock mobo to MSI blacklist
Date: Fri, 19 Mar 2010 01:07:03 +0100
User-Agent: KMail/1.12.4 (Linux/2.6.33-mike-1mike; KDE/4.3.5; i686; ; )
Cc: linux-kernel@vger.kernel.org, perex@perex.cz, stable@kernel.org
References: <201003062106.47245.barra_cuda@katamail.com> <s5hk4tojzy8.wl%tiwai@suse.de>
In-Reply-To: <s5hk4tojzy8.wl%tiwai@suse.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201003190107.04074.barra_cuda@katamail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 07 March 2010, Takashi Iwai wrote:
> At Sat, 6 Mar 2010 21:06:46 +0100,
> Michele Ballabio wrote:
> > 
> > This avoids a lockup at boot.
> > 
> > Signed-off-by: Michele Ballabio <barra_cuda@katamail.com>
> 
> Applied now.  Thanks.
> 
> 
> Takashi

This patch should go to the -stable queue (on CC) for 2.6.33.x, too.
Sorry, I should have said it before.

This is commit 4193d13b2c2b694aa59e629e6daf6269d7922f13
upstream.

> > ---
> >  sound/pci/hda/hda_intel.c |    1 +
> >  1 files changed, 1 insertions(+), 0 deletions(-)
> > 
> > diff --git a/sound/pci/hda/hda_intel.c b/sound/pci/hda/hda_intel.c
> > index ff6da6f..1306193 100644
> > --- a/sound/pci/hda/hda_intel.c
> > +++ b/sound/pci/hda/hda_intel.c
> > @@ -2351,6 +2351,7 @@ static void __devinit check_probe_mask(struct azx *chip, int dev)
> >  static struct snd_pci_quirk msi_black_list[] __devinitdata = {
> >  	SND_PCI_QUIRK(0x1043, 0x81f2, "ASUS", 0), /* Athlon64 X2 + nvidia */
> >  	SND_PCI_QUIRK(0x1043, 0x81f6, "ASUS", 0), /* nvidia */
> > +	SND_PCI_QUIRK(0x1849, 0x0888, "ASRock", 0), /* Athlon64 X2 + nvidia */
> >  	{}
> >  };
> >  
