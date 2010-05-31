Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755322Ab0EaBaG (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 May 2010 21:30:06 -0400
Received: from alerce.vps.bitfolk.com ([212.13.194.134]:3798 "EHLO
	alerce.vps.bitfolk.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755248Ab0EaBaE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 May 2010 21:30:04 -0400
X-Greylist: delayed 2703 seconds by postgrey-1.27 at vger.kernel.org; Sun, 30 May 2010 21:30:04 EDT
Date: Sun, 30 May 2010 21:44:50 -0300
From: Leandro Lucarella <llucax@gmail.com>
To: linux-kernel@vger.kernel.org, dri-devel@lists.sourceforge.net
Subject: Re: intel graphic card hanging (Hangcheck timer elapsed... GPU
 hung)
Message-ID: <20100531004450.GU17817@burns.springfield.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Paranoid: Just because you're paranoid, don't mean they're not after you.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Dear all,
> (please Cc)
> 
> I am running 2.6.34-rc2 + git 01e7770 commit (yesterday) with KMS on
> Debian/sid:
> xserver-xorg: 7.5+5
> video-intel: 2.9.1-3
> 
> Running D2X-xl (self compiled) (descent2 open source code) X suddenly
> died,
> and after that gdm could not be restarted because after a few secs
> it went dead again.
> 
> In the logs I see:
> kernel: [ 2486.341227] [drm:i915_hangcheck_elapsed] *ERROR* Hangcheck
> timer elapsed... GPU hung
> kernel: [ 2486.341240] render error detected, EIR: 0x00000000
> kernel: [ 2486.341278] [drm:i915_do_wait_request] *ERROR*
> i915_do_wait_request returns -5 (awaiting 113671 at 113604)
> kernel: [ 2486.669008] [drm:i915_hangcheck_elapsed] *ERROR* Hangcheck
> timer elapsed... GPU hung
> kernel: [ 2486.669012] render error detected, EIR: 0x00000000
> kernel: [ 2486.669522] [drm:i915_do_wait_request] *ERROR*
> i915_do_wait_request returns -5 (awaiting 113672 at 113604)
> kernel: [ 2487.524230] [drm:i915_hangcheck_elapsed] *ERROR* Hangcheck
> timer elapsed... GPU hung
> kernel: [ 2487.524243] render error detected, EIR: 0x00000000
> kernel: [ 2487.524284] [drm:i915_do_wait_request] *ERROR*
> i915_do_wait_request returns -5 (awaiting 113673 at 113604)
> kernel: [ 2487.912237] [drm:i915_hangcheck_elapsed] *ERROR* Hangcheck
> timer elapsed... GPU hung
> kernel: [ 2487.916175] render error detected, EIR: 0x00000000
> kernel: [ 2487.920137] [drm:i915_do_wait_request] *ERROR*
> i915_do_wait_request returns -5 (awaiting 113674 at 113604)
> Stopping gdm and restarting didn't help to get the graphics card back to
> normal.
> 
> If you have any ideas how to fix/track/debug that please let me know,
> same if you need more information.

Hi. I just wanted to say that I was hitting this bug too. It seems to be
a problem associated with xscreensaver and/or OpenGL. Looking for
information on the web I found some bug report that said something about
OpenGL (I can't find it now) so I tried deactivating xscreensaver and
the system is working very stable, no GPU hungs in 10 days of uptime.
When I had xscreensaver active the X server crashed in a couple of days
and sometime I got the GPU hung error in dmesg but X didn't crashed.

Thanks.

(please Cc)

-- 
Leandro Lucarella (AKA luca)                     http://llucax.com.ar/
----------------------------------------------------------------------
GPG Key: 5F5A8D05 (F8CD F9A7 BF00 5431 4145  104C 949E BFB6 5F5A 8D05)
----------------------------------------------------------------------
This homeless guy asked me for some money the other day.
And I was gonna give it to him but then I thought you're
just gonna use it on drugs or alcohol.
And then I thought, that's what I'm gonna use it on.
Why am I judging this poor bastard.
