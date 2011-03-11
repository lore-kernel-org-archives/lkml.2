Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753413Ab1CKJI0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Mar 2011 04:08:26 -0500
Received: from smarthost1.greenhost.nl ([195.190.28.78]:55801 "EHLO
	smarthost1.greenhost.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752581Ab1CKJIX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Mar 2011 04:08:23 -0500
Message-ID: <6137e754bd8453a60f892b0f03663352.squirrel@webmail.greenhost.nl>
In-Reply-To: <s5hd3lyrubr.wl%tiwai@suse.de>
References: <AANLkTi=Mc8O8cNWYOKgD0cESQhfa2jiHor11DBuagJDF@mail.gmail.com>
    <20110216192658.GA7225@blimp.localdomain>
    <20110217221329.GA3332@x61.home>
    <3f792aaf90cf0b3d49be21baa2682d5d.squirrel@webmail.greenhost.nl>
    <AANLkTik20vCMhXqjxkoebZ1cWFb0zQLP5OZvVx4GWMPb@mail.gmail.com>
    <AANLkTik3ECs5z5td6GYuDExrc74_18mC-bk-hsq4e1+i@mail.gmail.com>
    <AANLkTik9XHcDUbPTPh6t--TwQompeQBY9TNuuBRk++-6@mail.gmail.com>
    <20110222130440.21a27714@jbarnes-desktop>
    <20110222223120.GA3567@x61.home>
    <AANLkTimLBo4REwrCJfy3U_z-SJ8uoOurO7c66D5RpZRh@mail.gmail.com>
    <3e6f092bd0aa54fd6b9eb524f6c87ecf.squirrel@webmail.greenhost.nl>
    <AANLkTimyQ30ELw9Sm57NXgetiXnzJMHby2BE3GsynJLs@mail.gmail.com>
    <1a06e2711df021a802d609ad1a75db17.squirrel@webmail.greenhost.nl>
    <s5h4o7btnxq.wl%tiwai@suse.de> <s5hy64ns7pq.wl%tiwai@suse.de>
    <a04bdafb8c7a97d92593e980b01b37fd.squirrel@webmail.greenhost.nl>
    <s5hr5afm8mj.wl%tiwai@suse.de>
    <334e13a8513c5863dc9a5d278831777f.squirrel@webmail.greenhost.nl>
    <s5hd3lyrubr.wl%tiwai@suse.de>
Date: Fri, 11 Mar 2011 10:08:21 +0100 (CET)
Subject: Re: [PATCH] drm/i915: Revive combination mode for backlight control
From: "Indan Zupancic" <indan@nul.nu>
To: "Takashi Iwai" <tiwai@suse.de>
Cc: "Linus Torvalds" <torvalds@linux-foundation.org>,
        "Alex Riesen" <raa.lkml@gmail.com>,
        "Jesse Barnes" <jbarnes@virtuousgeek.org>,
        "DRI mailing list" <dri-devel@lists.freedesktop.org>,
        "Chris Wilson" <chris@chris-wilson.co.uk>,
        "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
        "Tino Keitel" <tino.keitel@tikei.de>, stable@kernel.org
User-Agent: SquirrelMail/1.4.17
MIME-Version: 1.0
Content-Type: text/plain;charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Priority: 3 (Normal)
Importance: Normal
X-Spam-Score: 0.1
X-Scan-Signature: 71684ae416b12bc74806129cb02de027
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, March 11, 2011 08:26, Takashi Iwai wrote:
> At Fri, 11 Mar 2011 02:23:08 +0100 (CET),
> Indan Zupancic wrote:
>>
>> Hi,
>>
>> Some nitpicks below. I know you're just restoring the original code,
>> but if we improve it we can as well do it now.
>
> Well, Linus already merged my patch quickly.  So, we can improve the
> readability as an additional patch, but I think it's likely a 2.6.39
> material.
>
> All you comments below look reasonable.  Could you send a new patch?

Well, my main concern was the slightly incorrect commit message,
but oh well, too late for that now. I'll probably send a patch
after 2.6.38 is released.

Greetings,

Indan


