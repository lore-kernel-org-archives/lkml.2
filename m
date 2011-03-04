Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759954Ab1CDSra (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Mar 2011 13:47:30 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51917 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752121Ab1CDSr3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Mar 2011 13:47:29 -0500
MIME-Version: 1.0
In-Reply-To: <3e6f092bd0aa54fd6b9eb524f6c87ecf.squirrel@webmail.greenhost.nl>
References: <AANLkTi=Mc8O8cNWYOKgD0cESQhfa2jiHor11DBuagJDF@mail.gmail.com>
 <20110216192658.GA7225@blimp.localdomain> <20110217221329.GA3332@x61.home>
 <3f792aaf90cf0b3d49be21baa2682d5d.squirrel@webmail.greenhost.nl>
 <AANLkTik20vCMhXqjxkoebZ1cWFb0zQLP5OZvVx4GWMPb@mail.gmail.com>
 <AANLkTik3ECs5z5td6GYuDExrc74_18mC-bk-hsq4e1+i@mail.gmail.com>
 <AANLkTik9XHcDUbPTPh6t--TwQompeQBY9TNuuBRk++-6@mail.gmail.com>
 <20110222130440.21a27714@jbarnes-desktop> <20110222223120.GA3567@x61.home>
 <AANLkTimLBo4REwrCJfy3U_z-SJ8uoOurO7c66D5RpZRh@mail.gmail.com> <3e6f092bd0aa54fd6b9eb524f6c87ecf.squirrel@webmail.greenhost.nl>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Fri, 4 Mar 2011 10:47:06 -0800
Message-ID: <AANLkTimyQ30ELw9Sm57NXgetiXnzJMHby2BE3GsynJLs@mail.gmail.com>
Subject: Re: [PATCH] fix backlight brightness on intel LVDS panel after
 reopening lid
To: Indan Zupancic <indan@nul.nu>, Alex Riesen <raa.lkml@gmail.com>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>,
        DRI mailing list <dri-devel@lists.freedesktop.org>,
        Chris Wilson <chris@chris-wilson.co.uk>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Tino Keitel <tino.keitel@tikei.de>, stable@kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alex, can you confirm that the revert of 951f3512dba5 plus the
one-liner patch from Takashi that Indan quoted also works for you?

              Linus

On Thu, Mar 3, 2011 at 10:53 PM, Indan Zupancic <indan@nul.nu> wrote:
>
> So please revert my patch and apply Takashi Iwai's, which fixes the
> most immediate bug without changing anything else. This should go
> in stable too.
