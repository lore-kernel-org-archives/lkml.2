Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760271Ab1CDXcs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Mar 2011 18:32:48 -0500
Received: from smarthost1.greenhost.nl ([195.190.28.78]:56821 "EHLO
	smarthost1.greenhost.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752095Ab1CDXcq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Mar 2011 18:32:46 -0500
Message-ID: <ff853da86f39892de9016bdf6288ff64.squirrel@webmail.greenhost.nl>
In-Reply-To: <AANLkTimyQ30ELw9Sm57NXgetiXnzJMHby2BE3GsynJLs@mail.gmail.com>
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
Date: Sat, 5 Mar 2011 00:32:40 +0100 (CET)
Subject: Re: [PATCH] fix backlight brightness on intel LVDS panel after 
     reopening lid
From: "Indan Zupancic" <indan@nul.nu>
To: "Linus Torvalds" <torvalds@linux-foundation.org>
Cc: "Alex Riesen" <raa.lkml@gmail.com>,
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
X-Scan-Signature: 919fae14bc17c74543a025539baad412
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, March 4, 2011 19:47, Linus Torvalds wrote:
> Alex, can you confirm that the revert of 951f3512dba5 plus the
> one-liner patch from Takashi that Indan quoted also works for you?
>
>               Linus
>
> On Thu, Mar 3, 2011 at 10:53 PM, Indan Zupancic <indan@nul.nu> wrote:
>>
>> So please revert my patch and apply Takashi Iwai's, which fixes the
>> most immediate bug without changing anything else. This should go
>> in stable too.
>

For what it's worth, doing the above does prevent the regression for the
ASLE case, but for me with gen 2 hardware the brightness isn't quite
right after suspend/resume, while it is with my patch applied. So
assuming that there are no gen 2 systems with ASLE out there, the best
solution may be the remove the combination mode check for gen 2 hardware
and leave it for gen >=4. Would be nice if Jesse or Chris could confirm
that there are no gen 2 ASLE systems out there though.

I'm going camping, I'll send a patch next week.

Greetings,

Indan



