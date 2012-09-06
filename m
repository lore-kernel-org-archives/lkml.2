Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752351Ab2IFGpJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Sep 2012 02:45:09 -0400
Received: from ud10.udmedia.de ([194.117.254.50]:45384 "EHLO
	mail.ud10.udmedia.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751004Ab2IFGpH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Sep 2012 02:45:07 -0400
Date: Thu, 6 Sep 2012 08:45:03 +0200
From: Markus Trippelsdorf <markus@trippelsdorf.de>
To: Daniel Mack <zonque@gmail.com>
Cc: Takashi Iwai <tiwai@suse.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org, alsa-devel@alsa-project.org,
        Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
Subject: Re:
Message-ID: <20120906064503.GA257@x4>
References: <s5hmx1526mg.wl%tiwai@suse.de>
 <20120906060220.GA252@x4>
 <504843BA.2040808@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <504843BA.2040808@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2012.09.06 at 08:33 +0200, Daniel Mack wrote:
> On 06.09.2012 08:02, Markus Trippelsdorf wrote:
> > On 2012.09.04 at 16:40 +0200, Takashi Iwai wrote:
> >> ----------------------------------------------------------------
> >> Sound fixes for 3.6-rc5
> >>
> >> There are nothing scaring, contains only small fixes for HD-audio and
> >> USB-audio:
> >> - EPSS regression fix and GPIO fix for HD-audio IDT codecs
> >> - A series of USB-audio regression fixes that are found since 3.5 kernel
> >>
> >> ----------------------------------------------------------------
> >> Daniel Mack (4):
> >>       ALSA: snd-usb: Fix URB cancellation at stream start
> >>       ALSA: snd-usb: restore delay information
> >         ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ 
> > The commit fbcfbf5f above causes the following lines to be printed
> > whenever I start a new song:
> 
> Copied Pierre-Louis Bossart - he wrote the code in 294c4fb8 which this
> patch (fbcfbf5f) brings back now.
> 
> > delay: estimated 0, actual 352
> > delay: estimated 353, actual 705
> > 
> > (44.1 * 8 = 352.8)
> > 
> > This happens with an USB-DAC that identifies itself as "C-Media USB
> > Headphone Set".
> 
> And you didn't you see these lines with 3.4?

No.

-- 
Markus
