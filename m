Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755285Ab0G1PX6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jul 2010 11:23:58 -0400
Received: from kroah.org ([198.145.64.141]:44320 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754553Ab0G1PX4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jul 2010 11:23:56 -0400
Date: Wed, 28 Jul 2010 08:19:08 -0700
From: Greg KH <greg@kroah.com>
To: Takashi Iwai <tiwai@suse.de>
Cc: Randy Dunlap <randy.dunlap@oracle.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>,
        Markus Grabner <grabner@icg.tugraz.at>, gregkh@suse.de,
        devel@driverdev.osuosl.org
Subject: Re: [PATCH -next] staging/line6: needs to select SND_PCM
Message-ID: <20100728151908.GA20600@kroah.com>
References: <20100727160708.722c39c1.sfr@canb.auug.org.au>
 <4C4F31AF.2090701@oracle.com>
 <s5hhbjjvh9l.wl%tiwai@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <s5hhbjjvh9l.wl%tiwai@suse.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 28, 2010 at 03:59:50PM +0200, Takashi Iwai wrote:
> At Tue, 27 Jul 2010 12:21:19 -0700,
> Randy Dunlap wrote:
> > 
> > From: Randy Dunlap <randy.dunlap@oracle.com>
> > 
> > line6 uses snd_pcm*() functions, so it should select SND_PCM.
> > 
> > ERROR: "snd_pcm_period_elapsed" [drivers/staging/line6/line6usb.ko] undefined!
> > ERROR: "snd_pcm_set_ops" [drivers/staging/line6/line6usb.ko] undefined!
> > ERROR: "snd_pcm_lib_free_pages" [drivers/staging/line6/line6usb.ko] undefined!
> > ERROR: "snd_pcm_lib_ioctl" [drivers/staging/line6/line6usb.ko] undefined!
> > ERROR: "snd_pcm_lib_malloc_pages" [drivers/staging/line6/line6usb.ko] undefined!
> > ERROR: "snd_pcm_hw_constraint_ratdens" [drivers/staging/line6/line6usb.ko] undefined!
> > ERROR: "snd_pcm_format_physical_width" [drivers/staging/line6/line6usb.ko] undefined!
> > ERROR: "snd_pcm_lib_preallocate_pages_for_all" [drivers/staging/line6/line6usb.ko] undefined!
> > ERROR: "snd_pcm_new" [drivers/staging/line6/line6usb.ko] undefined!
> > 
> > Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
> > Cc: Markus Grabner <grabner@icg.tugraz.at>
> > ---
> >  drivers/staging/line6/Kconfig |    1 +
> >  1 file changed, 1 insertion(+)
> > 
> > Third patch to staging/line6/Kconfig.  :(
> > Developers should know what kernel services their code needs
> > and how to configure for those needs.
> 
> I think this should be applied rather to 2.6.35 tree.

I'll queue this up for stable to get it into the .35 tree eventually :)

thanks,

greg k-h
