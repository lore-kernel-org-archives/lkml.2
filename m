Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756720Ab0GDH1J (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Jul 2010 03:27:09 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:61731 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755070Ab0GDH1G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Jul 2010 03:27:06 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=S9QqjJeOYAOcFo/8IFyW6UvenwRlsZZm7jpeDg3eEnX9FbWVizQ9IoRF51xReBcw4U
         42VoMOG4BMvCboYQSbbNQql8J7hYbLZsxdeNr2ibP8KZ5yfaei9tp4mlHeZw4NUzgieE
         4uSr/n/Jutz4H+IWfOaquuy7QPcFGX/QmYeCs=
MIME-Version: 1.0
In-Reply-To: <AANLkTinZXHi_mbmsX1HTzbMNjQx7j0rbEfTKSoz-02CF@mail.gmail.com>
References: <AANLkTikfYwkxF5CXgt-fGMIYTlcmt99lOz_VyA3Kr-4R@mail.gmail.com>
	<20100702095815.GA6802@skynet.be>
	<AANLkTimNgjtvDYY42dm-6akRjQfkHayagQWwHSS3AQs7@mail.gmail.com>
	<20100702111029.GB6802@skynet.be>
	<AANLkTikomWNbwHT-kQOm8UsUS1xkMW69cZ-mC6d8Dj56@mail.gmail.com>
	<AANLkTinZXHi_mbmsX1HTzbMNjQx7j0rbEfTKSoz-02CF@mail.gmail.com>
Date: Sun, 4 Jul 2010 17:27:05 +1000
Message-ID: <AANLkTim9Y7m3gU-w6kHvQeXT92h11kIpM8dAVaDO12uZ@mail.gmail.com>
Subject: Re: Closed source userspace graphics drivers with an open source 
	kernel component
From: Dave Airlie <airlied@gmail.com>
To: Magnus Wendt <magnus.wendt@gmail.com>
Cc: Luc Verhaegen <libv@skynet.be>, LKML <linux-kernel@vger.kernel.org>,
       dri-devel <dri-devel@lists.freedesktop.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jul 4, 2010 at 5:06 PM, Magnus Wendt <magnus.wendt@gmail.com> wrote:
>
>
> 2010/7/2 Dave Airlie <airlied@gmail.com>
>>
>> ARM Mali - not sure what is going on there, I;m going to go with no
>> hope but would be nice to be proved wrong
>
> So far no user space but at least kernel space is available under GPLv2
>
> http://www.malideveloper.com/drivers.php
>

So its as crap as the others since the kernel space is uninteresting
and doesn't give you any idea how to actually use the GPU, its just a
slightly intelligent shim which transfers command streams and
interrupt to/from gpu/userspace.

Its like having an ELF loader but no source to the compiler or linker,
and saying the CPU is open.

Dave.
