Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753935Ab0EaMKP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 May 2010 08:10:15 -0400
Received: from alerce.vps.bitfolk.com ([212.13.194.134]:4517 "EHLO
	alerce.vps.bitfolk.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753383Ab0EaMKN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 May 2010 08:10:13 -0400
Date: Mon, 31 May 2010 09:10:07 -0300
From: Leandro Lucarella <llucax@gmail.com>
To: Takashi Iwai <tiwai@suse.de>
Cc: linux-kernel@vger.kernel.org, dri-devel@lists.sourceforge.net
Subject: Re: intel graphic card hanging (Hangcheck timer elapsed... GPU
 hung)
Message-ID: <20100531121007.GX17817@burns.springfield.home>
References: <20100531004450.GU17817@burns.springfield.home>
 <s5hhblo602c.wl%tiwai@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <s5hhblo602c.wl%tiwai@suse.de>
X-Paranoid: Just because you're paranoid, don't mean they're not after you.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Takashi Iwai, el 31 de mayo a las 08:46 me escribiste:
> > > In the logs I see:
> > > kernel: [ 2486.341227] [drm:i915_hangcheck_elapsed] *ERROR* Hangcheck
> > > timer elapsed... GPU hung
> > > kernel: [ 2486.341240] render error detected, EIR: 0x00000000
> > > kernel: [ 2486.341278] [drm:i915_do_wait_request] *ERROR*
> > > i915_do_wait_request returns -5 (awaiting 113671 at 113604)
> > > kernel: [ 2486.669008] [drm:i915_hangcheck_elapsed] *ERROR* Hangcheck
> > > timer elapsed... GPU hung
> > > kernel: [ 2486.669012] render error detected, EIR: 0x00000000
> > > 
> > > If you have any ideas how to fix/track/debug that please let me know,
> > > same if you need more information.
> > 
> > Hi. I just wanted to say that I was hitting this bug too. It seems to be
> > a problem associated with xscreensaver and/or OpenGL. Looking for
> > information on the web I found some bug report that said something about
> > OpenGL (I can't find it now) so I tried deactivating xscreensaver and
> > the system is working very stable, no GPU hungs in 10 days of uptime.
> > When I had xscreensaver active the X server crashed in a couple of days
> > and sometime I got the GPU hung error in dmesg but X didn't crashed.
> 
> We've seen a similar hang with PineView when GLknots screensaver mode
> is running.  Run /usr/lib/xscreensaver/glknots, and the screen gets
> frozen immediately (mouse works, so the rendering simply doesn't
> work), and no way to recover until reboot.
> 
> Reported at:
> 	https://bugs.freedesktop.org/show_bug.cgi?id=28274

GLknots works fine (I tried a couple of times and I never got the GPU
hung message in dmesg). BTW, X crashes when I have the error (or
sometimes it gets rendering corruption, but continue working besides
that).


-- 
Leandro Lucarella (AKA luca)                     http://llucax.com.ar/
----------------------------------------------------------------------
GPG Key: 5F5A8D05 (F8CD F9A7 BF00 5431 4145  104C 949E BFB6 5F5A 8D05)
----------------------------------------------------------------------
All evidence has been buried
All tapes have been erased
But your footsteps give you away
So you're backtracking
