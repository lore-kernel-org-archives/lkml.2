Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756801Ab0EKPMe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 May 2010 11:12:34 -0400
Received: from cantor2.suse.de ([195.135.220.15]:38247 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756789Ab0EKPMc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 May 2010 11:12:32 -0400
Date: Tue, 11 May 2010 08:07:30 -0700
From: Greg KH <gregkh@suse.de>
To: Daniel Chen <seven.steps@gmail.com>
Cc: Nigel Cunningham <nigel@tuxonice.net>, linux-kernel@vger.kernel.org,
       stable@kernel.org, stable-review@kernel.org,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, Daniel T Chen <crimsun@ubuntu.com>,
       Takashi Iwai <tiwai@suse.de>
Subject: Re: [057/117] ALSA: hda: Use STAC_DELL_M6_BOTH quirk for Dell
 Studio 1558
Message-ID: <20100511150730.GD14895@suse.de>
References: <20100510223322.347254355@kvm.kroah.org>
 <4BE896FC.2050407@tuxonice.net>
 <AANLkTinUQ-ra-0lknwTAPIp996NU40o0LKjsq1sXc6Va@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTinUQ-ra-0lknwTAPIp996NU40o0LKjsq1sXc6Va@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 11, 2010 at 07:53:25AM +0200, Daniel Chen wrote:
> On 11/05/10 08:32, Greg KH wrote:
> >> 2.6.33-stable review patch.  If anyone has any objections, please let us
> >> know.
> ...
> >> commit 5c1bccf645d4ab65e4c7502acb42e8b9afdb5bdc upstream.
> >>
> >> BugLink: https://launchpad.net/bugs/568600
> >>
> >> The OR has verified that the dell-m6 model quirk is necessary for audio
> >> to be audible by default on the Dell Studio XPS 1645.
> ...
> >>  sound/pci/hda/patch_sigmatel.c |    2 ++
> >>  1 file changed, 2 insertions(+)
> >>
> >> --- a/sound/pci/hda/patch_sigmatel.c
> >> +++ b/sound/pci/hda/patch_sigmatel.c
> >> @@ -1604,6 +1604,8 @@ static struct snd_pci_quirk stac92hd73xx
> >>                                "Dell Studio 1557", STAC_DELL_M6_DMIC),
> >>        SND_PCI_QUIRK(PCI_VENDOR_ID_DELL, 0x02fe,
> >>                                "Dell Studio XPS 1645", STAC_DELL_M6_BOTH),
> >> +       SND_PCI_QUIRK(PCI_VENDOR_ID_DELL, 0x0413,
> >> +                               "Dell Studio 1558", STAC_DELL_M6_BOTH),
> >>        {} /* terminator */
> >>  };
> 
> 
> On Tue, May 11, 2010 at 1:30 AM, Nigel Cunningham <nigel@tuxonice.net> wrote:
> > Just that the commit comment doesn't match the code here.
> 
> Oops, simply brown paper bag copy-n'-paste error. I'm happy to respin
> for clarification if necessary.

As this mirrors what is in Linus's tree, I say we just leave it alone,
is that ok?

thanks,

greg k-h
