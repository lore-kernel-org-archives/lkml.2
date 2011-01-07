Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755894Ab1AGXCn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Jan 2011 18:02:43 -0500
Received: from mail-wy0-f174.google.com ([74.125.82.174]:65129 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755338Ab1AGXCl convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Jan 2011 18:02:41 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:in-reply-to:references:x-mailer
         :mime-version:content-type:content-transfer-encoding;
        b=BTOi1M6owVNgd96E7vhWMbfQ729lMOs03rCoXh6Yc2uTqJJMZvbSpVSKgKt90edBsn
         0jKB2pMX2rzPSr7Ue1GrPo6Wl9cwhaWY2MfxV9H3+63sHmlrYG6omhhsVtREFD1hu+D+
         lrwY2TmYnpFXcvXMje8lGyBN1WOmio7WCm1WU=
Date: Sat, 8 Jan 2011 00:02:30 +0100
From: Alejandro Riveira =?UTF-8?B?RmVybsOhbmRleg==?= 
	<ariveira@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [GIT] Networking
Message-ID: <20110108000230.17a03bb4@varda>
In-Reply-To: <AANLkTikrynvdOP7qtiHqgmEzuAFTjB=rcN90cBv-VuVG@mail.gmail.com>
References: <20110106.122003.233698077.davem@davemloft.net>
	<AANLkTi=7=_FyVsjA3vKEpg8RwfC=m-8QGfqa6ctxQday@mail.gmail.com>
	<20110107190656.GQ3702@decadent.org.uk>
	<AANLkTikwrHoOY4wvUp1qn-OT=EjZesSNR29US1ERc0o2@mail.gmail.com>
	<20110107222845.1cd02e26@varda>
	<AANLkTikrynvdOP7qtiHqgmEzuAFTjB=rcN90cBv-VuVG@mail.gmail.com>
X-Mailer: Claws Mail 3.7.8 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

El Fri, 7 Jan 2011 14:25:16 -0800
Linus Torvalds <torvalds@linux-foundation.org> escribió:

> 2011/1/7 Alejandro Riveira Fernández <ariveira@gmail.com>:
> >> [ Apart from the annoyance of also having to manually copying the
> >> firmware files: why the heck doesn't that firmware tree even have a
> >> "make firmware-install" makefile or something? The kernel has a "make
> >> firmware-install" thing, why doesn't the firmware tree itself have
> >> that? Gaah, this is almost as idiotic as trying to install a
> >> self-built kernel under Ubuntu ]
> >
> >  Maybe i am just making myself a fool but i'll bite:
> >  this has allways worked for me
> >
> >  make && sudo make install && sudo make modules_install
> >  sudo mkintramfs -o /boot/initrd-$kernel_version  $kernel_version
> >  sudo update-grub
> 
> Whee. That's not what any of the docs say. And while it is simpler
> than what is apparently the "official" method (which involves packages
> etc) why doesn't just
> 
>   make modules_install ; make install

 Well that's the recipe I come up on "my own" because I allways
 avoided the mk-dpkg fakeroot etc dance. 
 
> 
> work? That's all I need to do on systems that are friendlier to kernel
> developers.
> 
> The kernel install scripts run "/sbin/installkernel" exactly so that a
> distribution can just make it all work for them. But at least when I
> tried it last, it didn't.

 Well I did not know about this command, I have it installed and yes,
 it does not work :/


> 
> Some people claim Ubuntu has no kernel developers. Sometimes I do wonder..
> 
>                    Linus
