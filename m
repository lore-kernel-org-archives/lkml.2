Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755063Ab0EZNSZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 May 2010 09:18:25 -0400
Received: from mail.aixigo.de ([195.14.232.227]:25719 "EHLO mail.aixigo.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752691Ab0EZNSX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 May 2010 09:18:23 -0400
Message-ID: <4BFD1F93.7080000@aixigo.de>
Date: Wed, 26 May 2010 15:18:11 +0200
From: Harald Dunkel <harald.dunkel@aixigo.de>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100412 Lightning/1.0b2pre Thunderbird/3.0.4
MIME-Version: 1.0
To: Kay Sievers <kay.sievers@vrfy.org>
CC: Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Greg KH <greg@kroah.com>
Subject: Re: 2.6.34 on Samsung P460: reset after "Waiting for /dev to be fully
 	populated"
References: <4BFB947E.9080509@aixigo.de> <20100525184621.89487735.akpm@linux-foundation.org> <AANLkTil_-pV3jBkdBrWlz6iKr_lo2b3ZUFUvP8MFoByg@mail.gmail.com>
In-Reply-To: <AANLkTil_-pV3jBkdBrWlz6iKr_lo2b3ZUFUvP8MFoByg@mail.gmail.com>
X-Enigmail-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/26/10 10:50, Kay Sievers wrote:
> 
> A behavior like this is usually a kernel module that gets loaded which
> hangs the box. The message comes from distro specific stuff, and not
> from udev itself, so we can't know what exactly it is doing.
> 
> Did you wait for 3 minutes at least to let the boot processes run into
> their timeouts?
> 

I waited for 10 minutes, but there was no additional action.
Its stuck.

> Are you using an initramfs? If not, does init=/bin/sh work?
> 

I am using an initrd. init=/bin/sh did not work; it complained
about a missing boot disk.

To get rid of some autodetected devices I also disabled USB
support in the BIOS, as far as possible. No luck.

> For current -git kernels it could be the FIONREAD bug, which breaks
> all sorts of services using inotify. They all hang in a loop, it's not
> only udevd:
>   http://lkml.org/lkml/2010/5/23/100
> 

The most recent kernel I tried is 2.6.34. I built it and
installed it on USB. The same USB stick boots fine in other
PCs (e.g. a Dell XPS M1300).

Of course I will keep on trying.


Regards

Harri
