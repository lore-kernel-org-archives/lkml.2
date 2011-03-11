Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754996Ab1CKB3Z (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Mar 2011 20:29:25 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53977 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753269Ab1CKB3Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Mar 2011 20:29:24 -0500
MIME-Version: 1.0
In-Reply-To: <334e13a8513c5863dc9a5d278831777f.squirrel@webmail.greenhost.nl>
References: <AANLkTi=Mc8O8cNWYOKgD0cESQhfa2jiHor11DBuagJDF@mail.gmail.com>
 <20110216192658.GA7225@blimp.localdomain> <20110217221329.GA3332@x61.home>
 <3f792aaf90cf0b3d49be21baa2682d5d.squirrel@webmail.greenhost.nl>
 <AANLkTik20vCMhXqjxkoebZ1cWFb0zQLP5OZvVx4GWMPb@mail.gmail.com>
 <AANLkTik3ECs5z5td6GYuDExrc74_18mC-bk-hsq4e1+i@mail.gmail.com>
 <AANLkTik9XHcDUbPTPh6t--TwQompeQBY9TNuuBRk++-6@mail.gmail.com>
 <20110222130440.21a27714@jbarnes-desktop> <20110222223120.GA3567@x61.home>
 <AANLkTimLBo4REwrCJfy3U_z-SJ8uoOurO7c66D5RpZRh@mail.gmail.com>
 <3e6f092bd0aa54fd6b9eb524f6c87ecf.squirrel@webmail.greenhost.nl>
 <AANLkTimyQ30ELw9Sm57NXgetiXnzJMHby2BE3GsynJLs@mail.gmail.com>
 <1a06e2711df021a802d609ad1a75db17.squirrel@webmail.greenhost.nl>
 <s5h4o7btnxq.wl%tiwai@suse.de> <s5hy64ns7pq.wl%tiwai@suse.de>
 <a04bdafb8c7a97d92593e980b01b37fd.squirrel@webmail.greenhost.nl>
 <s5hr5afm8mj.wl%tiwai@suse.de> <334e13a8513c5863dc9a5d278831777f.squirrel@webmail.greenhost.nl>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Thu, 10 Mar 2011 17:28:25 -0800
Message-ID: <AANLkTinytN=7ktL6Kw3wOWK0HB8bGKSH+B6pWWgzx6Oz@mail.gmail.com>
Subject: Re: [PATCH] drm/i915: Revive combination mode for backlight control
To: Indan Zupancic <indan@nul.nu>
Cc: Takashi Iwai <tiwai@suse.de>, Alex Riesen <raa.lkml@gmail.com>,
        Jesse Barnes <jbarnes@virtuousgeek.org>,
        DRI mailing list <dri-devel@lists.freedesktop.org>,
        Chris Wilson <chris@chris-wilson.co.uk>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Tino Keitel <tino.keitel@tikei.de>, stable@kernel.org,
        Keith Packard <keithp@keithp.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 10, 2011 at 5:23 PM, Indan Zupancic <indan@nul.nu> wrote:
>
> After this patch, combined with my new patch
>
> "drm/i915: Fix DPMS and suspend interaction for intel_panel.c"
>
> all known backlight problems should be fixed.

Btw, can you repost that one as a new email (and cc keithp too)? I
think it got hidden in the other thread by different subject line.

Jesse, did you take a look at that one? It was in the thread with a
subject like "[PATCH] fix backlight brightness on intel LVDS panel
after reopening lid".

Search for

  When suspending intel_panel_disable_backlight() is never called,
  but intel_panel_enable_backlight() is called at resume. With the
  effect that if the brightness was ever changed after screen
  blanking, the wrong brightness gets restored at resume time.

in your mailbox.

                    Linus
