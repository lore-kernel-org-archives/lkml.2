Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752045Ab1AHMXE (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Jan 2011 07:23:04 -0500
Received: from ksp.mff.cuni.cz ([195.113.26.206]:56598 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751455Ab1AHMXC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Jan 2011 07:23:02 -0500
Date: Sat, 1 Jan 2000 01:13:01 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Dave Airlie <airlied@gmail.com>
Cc: Chris Wilson <chris@chris-wilson.co.uk>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 2.6.37-rc8
Message-ID: <20000101001300.GA1627@ucw.cz>
References: <AANLkTi=-dNeeDjcSoznKtwcaNyw1mMXSqepFY89R2i+2@mail.gmail.com>
 <20110104142604.GA6591@ucw.cz>
 <849307$b0n4jp@azsmga001.ch.intel.com>
 <20110104210408.GA2008@elf.ucw.cz>
 <AANLkTim2PC5tgLfuz4+jO4L_xSX9bPuLhy+gtE2mgcJH@mail.gmail.com>
 <20110105220533.GA2700@elf.ucw.cz>
 <AANLkTikq9QHDk2zN+b8LFjrfqmHgtHWS8nT42hfiSwrz@mail.gmail.com>
 <20110106202712.GA1967@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110106202712.GA1967@elf.ucw.cz>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> Ok, I guess someone should write Doc*/fb/inteldrmfb.txt...
...
> But I still can't get accelerated X to work. I tried updating xserver:

> 
> Setting up xserver-xorg-video-intel (2:2.13.0-2) ...
> 
> Section "Device"
>         Identifier      "Generic Video Card"
> 	Driver          "intel"

I did not have  right /dev nodes created, it seems to work now. I
guess I should write some docs now.

One more question: what kind of 3D performance should I expect?
glxgears get < 100 fps in 1024x768 mode, and flightgear is unusable.

Is there normal or ...?

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
