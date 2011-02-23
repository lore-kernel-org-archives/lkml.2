Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755316Ab1BWBJu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Feb 2011 20:09:50 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55118 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754238Ab1BWBJt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Feb 2011 20:09:49 -0500
MIME-Version: 1.0
In-Reply-To: <20110222223120.GA3567@x61.home>
References: <AANLkTi=Mc8O8cNWYOKgD0cESQhfa2jiHor11DBuagJDF@mail.gmail.com>
 <20110216192658.GA7225@blimp.localdomain> <20110217221329.GA3332@x61.home>
 <3f792aaf90cf0b3d49be21baa2682d5d.squirrel@webmail.greenhost.nl>
 <AANLkTik20vCMhXqjxkoebZ1cWFb0zQLP5OZvVx4GWMPb@mail.gmail.com>
 <AANLkTik3ECs5z5td6GYuDExrc74_18mC-bk-hsq4e1+i@mail.gmail.com>
 <AANLkTik9XHcDUbPTPh6t--TwQompeQBY9TNuuBRk++-6@mail.gmail.com>
 <20110222130440.21a27714@jbarnes-desktop> <20110222223120.GA3567@x61.home>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Tue, 22 Feb 2011 17:09:00 -0800
Message-ID: <AANLkTimLBo4REwrCJfy3U_z-SJ8uoOurO7c66D5RpZRh@mail.gmail.com>
Subject: Re: [PATCH] fix backlight brightness on intel LVDS panel after
 reopening lid
To: Jesse Barnes <jbarnes@virtuousgeek.org>, Alex Riesen <raa.lkml@gmail.com>,
        Indan Zupancic <indan@nul.nu>,
        DRI mailing list <dri-devel@lists.freedesktop.org>,
        Chris Wilson <chris@chris-wilson.co.uk>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: Tino Keitel <tino.keitel@tikei.de>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 22, 2011 at 2:31 PM, Tino Keitel <tino.keitel@tikei.de> wrote:
>
> I just tried 2.6.38-rc6 on my ThinkPad X61s without any other DRM
> related patches, and my backlight issue is gone.

I applied Indan's fix in -rc6 (commit 951f3512dba5), since it had
several testers and seemed to simplify the code nicely too.

                    Linus
