Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753943Ab1FIJGL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jun 2011 05:06:11 -0400
Received: from cantor.suse.de ([195.135.220.2]:36956 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753217Ab1FIJGJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jun 2011 05:06:09 -0400
Date: Thu, 9 Jun 2011 11:06:07 +0200
From: Michal Hocko <mhocko@suse.cz>
To: Takashi Iwai <tiwai@suse.de>
Cc: LKML <linux-kernel@vger.kernel.org>, alsa-devel@alsa-project.org
Subject: Re: [alsa-devel] Headphone output doesn't work with 3.0.0-rc* anymore
Message-ID: <20110609090607.GB4207@tiehlicka.suse.cz>
References: <20110607180522.GA4004@tiehlicka.suse.cz>
 <s5hy61cxqcz.wl%tiwai@suse.de>
 <20110608174855.GA4138@tiehlicka.suse.cz>
 <s5hr573y1rl.wl%tiwai@suse.de>
 <20110609085616.GA4207@tiehlicka.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110609085616.GA4207@tiehlicka.suse.cz>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu 09-06-11 10:56:16, Michal Hocko wrote:
> On Thu 09-06-11 08:09:18, Takashi Iwai wrote:
> > At Wed, 8 Jun 2011 19:48:55 +0200,
[...]
> > Thanks, that's helpful.
> > As a quirk solution, could you try to pass model=auto option to
> > snd-hda-intel module?
> 
> Headphones work now but speakers are quite... I have tried to play
> with Headphone and Speaker controls in alsamixer but no changes.
> 
> Here is what I get in logs when the module is loaded:
> [ 5320.360277] HDA Intel 0000:00:1b.0: PCI INT A disabled
> [ 5326.920247] HDA Intel 0000:00:1b.0: power state changed by ACPI to D0
> [ 5326.920262] HDA Intel 0000:00:1b.0: power state changed by ACPI to D0
> [ 5326.920279] HDA Intel 0000:00:1b.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
> [ 5326.920375] HDA Intel 0000:00:1b.0: irq 42 for MSI/MSI-X
> [ 5326.920405] HDA Intel 0000:00:1b.0: setting latency timer to 64
> [ 5326.981085] input: HDA Intel Mic as /devices/pci0000:00/0000:00:1b.0/sound/card0/input18
> [ 5326.981262] input: HDA Intel Mic as /devices/pci0000:00/0000:00:1b.0/sound/card0/input19
> [ 5326.987934] input: HDA Intel Headphone as /devices/pci0000:00/0000:00:1b.0/sound/card0/input20
> 
> [maybe not important but input numbers are increasing for every new load]
> 
> There is another strange thing. After I stop mplayer and wait for some
> time (~1min) I can hear a "click" sound and then there is no sound at
> all... If I start mplayer in the meantime it just works...
> If I try to remove the module and load it again then things work and stop
> working after first playback again.

And I have just found out that I do not have to start any playback to
see this. It is sufficient to load the module and wait a minute and
there is no sound at all (both from speakers or headphones).
-- 
Michal Hocko
SUSE Labs
SUSE LINUX s.r.o.
Lihovarska 1060/12
190 00 Praha 9    
Czech Republic
