Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751893Ab2AUJYX (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Jan 2012 04:24:23 -0500
Received: from pasky.or.cz ([84.242.80.195]:54164 "EHLO machine.or.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751263Ab2AUJYN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Jan 2012 04:24:13 -0500
X-Greylist: delayed 486 seconds by postgrey-1.27 at vger.kernel.org; Sat, 21 Jan 2012 04:24:12 EST
Date: Sat, 21 Jan 2012 10:16:02 +0100
From: Petr Baudis <pasky@ucw.cz>
To: Jonathan Nieder <jrnieder@gmail.com>
Cc: alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org,
        Takashi Iwai <tiwai@suse.de>
Subject: Re: hda-intel: azx_get_response timeout, switching to polling mode:
 last cmd=0x01db0000
Message-ID: <20120121091602.GF30898@machine.or.cz>
References: <20111229025953.15211.24880.reportbug@machine.or.cz>
 <20111229062105.GB28780@elie.Belkin>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111229062105.GB28780@elie.Belkin>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  Hi!

On Thu, Dec 29, 2011 at 12:21:05AM -0600, Jonathan Nieder wrote:
> Petr Baudis wrote[1]:
> 
> > Version: 3.1.5-1
> [...]
> > this bug is twofold - I'm not sure which of the two problems is the real
> > culprit of the issue I'm seeing, and if it's worth fixing both or just
> > either one. It boils down to sometimes choppy playback and mainly
> > applications getting stuck on some audio operations.
> [...]
> > This did not use to happen at least back around 2.6.32.
> [...]
> > I'd be willing to do some bisecting if people believe it would make
> > sense.
> 
> I don't see any relevant newer fixes, but could you test the for-next
> branch from [2] anyway?  Output from the alsa-info.sh script[3] would
> also be useful.

I'm really sorry for taking so long - this is still an issue for me, but
contrary to my expectations, I was not able to reboot this machine yet
and it might take some more time (weeks...) before that's convenient.
I will try the then-current kernel and for-next branch then.

The output from the alsa-info.sh script is at:

	http://www.alsa-project.org/db/?f=184928832b33b23c68d17460604b9a37af0fac4b

-- 
				Petr "Pasky" Baudis
	The goal of Computer Science is to build something that will
	last at least until we've finished building it.
