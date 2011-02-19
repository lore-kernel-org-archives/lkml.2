Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754141Ab1BSXIk (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Feb 2011 18:08:40 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37866 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752973Ab1BSXIk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Feb 2011 18:08:40 -0500
MIME-Version: 1.0
In-Reply-To: <AANLkTik3ECs5z5td6GYuDExrc74_18mC-bk-hsq4e1+i@mail.gmail.com>
References: <AANLkTi=Mc8O8cNWYOKgD0cESQhfa2jiHor11DBuagJDF@mail.gmail.com>
 <20110216192658.GA7225@blimp.localdomain> <20110217221329.GA3332@x61.home>
 <3f792aaf90cf0b3d49be21baa2682d5d.squirrel@webmail.greenhost.nl>
 <AANLkTik20vCMhXqjxkoebZ1cWFb0zQLP5OZvVx4GWMPb@mail.gmail.com> <AANLkTik3ECs5z5td6GYuDExrc74_18mC-bk-hsq4e1+i@mail.gmail.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Sat, 19 Feb 2011 15:07:49 -0800
Message-ID: <AANLkTik9XHcDUbPTPh6t--TwQompeQBY9TNuuBRk++-6@mail.gmail.com>
Subject: Re: [PATCH] fix backlight brightness on intel LVDS panel after
 reopening lid
To: Alex Riesen <raa.lkml@gmail.com>
Cc: Indan Zupancic <indan@nul.nu>,
        DRI mailing list <dri-devel@lists.freedesktop.org>,
        Chris Wilson <chris@chris-wilson.co.uk>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Feb 19, 2011 at 4:26 AM, Alex Riesen <raa.lkml@gmail.com> wrote:
> On Sat, Feb 19, 2011 at 13:11, Alex Riesen <raa.lkml@gmail.com> wrote:
>>> Lastly, could you verify that my patch at https://lkml.org/lkml/2011/2/16/447 fixes
>>> it for you too? (Make sure you're at max brightness before rebooting.)
>>
>> I'll try it now.
>>
>
> I can confirm that it does fix backlight in my case (Dell XPS 1330,
> LVDS panel, GM965/GL960).
>
> Tested-by: Alex Riesen <raa.lkml@gmail.com>

Guys, should I apply this, or will I get it through somebody's pull?

                          Linus
