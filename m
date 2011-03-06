Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753553Ab1CFRkS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Mar 2011 12:40:18 -0500
Received: from mail-gy0-f174.google.com ([209.85.160.174]:56131 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753319Ab1CFRkO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Mar 2011 12:40:14 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=fN4onNe1JdpSXLnsRhjfiCRdM+dwHzTpifvsGQBheVt5ma2sUW4wd2uraYZifIfZlc
         kWeW6ue5GJ1WaGQZ3nerhhNJu5ILDuOOAHzsjFY94dWVEuuvVFVqt9/HEP4YsBK/n02Q
         7lg3P1NWwxj7rSSl+MyEeUcFzmcsVAwOEkepY=
MIME-Version: 1.0
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
Date: Sun, 6 Mar 2011 18:40:13 +0100
Message-ID: <AANLkTimw8HGmUFfC9dk4=she4CrjG5zXsmvJxRtTSB=d@mail.gmail.com>
Subject: Re: [PATCH] fix backlight brightness on intel LVDS panel after
 reopening lid
From: Alex Riesen <raa.lkml@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Indan Zupancic <indan@nul.nu>, Jesse Barnes <jbarnes@virtuousgeek.org>,
        DRI mailing list <dri-devel@lists.freedesktop.org>,
        Chris Wilson <chris@chris-wilson.co.uk>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Tino Keitel <tino.keitel@tikei.de>, stable@kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 4, 2011 at 19:47, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
> Alex, can you confirm that the revert of 951f3512dba5 plus the
> one-liner patch from Takashi that Indan quoted also works for you?

I afraid mine is a different case, because backlight in this system
works properly even with Indan's patch reverted.

Sorry for the late reply...

> On Thu, Mar 3, 2011 at 10:53 PM, Indan Zupancic <indan@nul.nu> wrote:
>>
>> So please revert my patch and apply Takashi Iwai's, which fixes the
>> most immediate bug without changing anything else. This should go
>> in stable too.
>
>
>              Linus
>
