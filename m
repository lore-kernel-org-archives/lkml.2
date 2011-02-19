Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753295Ab1BSM0r (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Feb 2011 07:26:47 -0500
Received: from mail-yx0-f174.google.com ([209.85.213.174]:44372 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750908Ab1BSM0o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Feb 2011 07:26:44 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=a/iaj5VJII4eyJBM7MLb5JeNV1PGnW13ZqMNWcZRLblLA49E2kQNGIicbF0ZOdjXk7
         PqemMfJsFg17ieVQrtYQxnXZoRmBDftcJuKCaYWeDzjkINRce4Xuki9000TxmNXwUzDj
         A4aQBTuS6f7gPxFny8v293pHWCihEbTkFBTu0=
MIME-Version: 1.0
In-Reply-To: <AANLkTik20vCMhXqjxkoebZ1cWFb0zQLP5OZvVx4GWMPb@mail.gmail.com>
References: <AANLkTi=Mc8O8cNWYOKgD0cESQhfa2jiHor11DBuagJDF@mail.gmail.com>
	<20110216192658.GA7225@blimp.localdomain>
	<20110217221329.GA3332@x61.home>
	<3f792aaf90cf0b3d49be21baa2682d5d.squirrel@webmail.greenhost.nl>
	<AANLkTik20vCMhXqjxkoebZ1cWFb0zQLP5OZvVx4GWMPb@mail.gmail.com>
Date: Sat, 19 Feb 2011 13:26:43 +0100
Message-ID: <AANLkTik3ECs5z5td6GYuDExrc74_18mC-bk-hsq4e1+i@mail.gmail.com>
Subject: Re: [PATCH] fix backlight brightness on intel LVDS panel after
 reopening lid
From: Alex Riesen <raa.lkml@gmail.com>
To: Indan Zupancic <indan@nul.nu>
Cc: DRI mailing list <dri-devel@lists.freedesktop.org>,
        Chris Wilson <chris@chris-wilson.co.uk>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Feb 19, 2011 at 13:11, Alex Riesen <raa.lkml@gmail.com> wrote:
>> Lastly, could you verify that my patch at https://lkml.org/lkml/2011/2/16/447 fixes
>> it for you too? (Make sure you're at max brightness before rebooting.)
>
> I'll try it now.
>

I can confirm that it does fix backlight in my case (Dell XPS 1330,
LVDS panel, GM965/GL960).

Tested-by: Alex Riesen <raa.lkml@gmail.com>
