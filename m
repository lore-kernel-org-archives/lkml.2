Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758340Ab1DNROr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Apr 2011 13:14:47 -0400
Received: from [217.200.184.87] ([217.200.184.87]:58910 "EHLO
	fepna12-svc.tim.it" rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756906Ab1DNROp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Apr 2011 13:14:45 -0400
X-Greylist: delayed 907 seconds by postgrey-1.27 at vger.kernel.org; Thu, 14 Apr 2011 13:14:45 EDT
Subject: Re: [PATCH] snd_hda_codec_realtek: enable ALC271 for Acer laptops
From: Guido Trentalancia <guido@trentalancia.com>
To: Takashi Iwai <tiwai@suse.de>
Cc: linux-kernel@vger.kernel.org
Date: Thu, 14 Apr 2011 19:08:47 +0200
In-Reply-To: <s5haaftmaja.wl%tiwai@suse.de>
References: <201104071738.p37HcSFX019185@vivaldi20.register.it>
	 <s5haaftmaja.wl%tiwai@suse.de>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.0.0 
Content-Transfer-Encoding: 7bit
Message-ID: <1302800932.2766.42.camel@vortex>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello again Takashi.

On Thu, 2011-04-14 at 11:45 +0200, Takashi Iwai wrote:
> At Thu, 07 Apr 2011 19:38:27 +0200,
> Guido Trentalancia wrote:
> > 
> > This quick fix to the Realtek HD Audio driver enables configurable support for the ALC271 type commonly found on some Acer laptops (e.g. Aspire 5745G).
> > 
> > Normally, the driver would fall back to BIOS auto-probing. However, the "model=acer" parameter can be passed on the boot command line to enable such support. Otherwise, it is quite common that the internal microphone does not work.
> 
[cut]
> 
> Anyway, it's not such quite common that the machine doesn't work
> without the model quirk any longer :)  In most cases, we want to avoid
> the model quirk but fixing the pin configuration instead.

Actually I have to disagree on the "not quite common". Just use the
right keywords (including "microphone") along with a good web search
engine and you'll discover plenty of reports for this chipset including
formal bug reports on several distributions.

Regards,

Guido

