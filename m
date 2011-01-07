Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754677Ab1AGWZj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Jan 2011 17:25:39 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36938 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753264Ab1AGWZh convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Jan 2011 17:25:37 -0500
MIME-Version: 1.0
In-Reply-To: <20110107222845.1cd02e26@varda>
References: <20110106.122003.233698077.davem@davemloft.net>
 <AANLkTi=7=_FyVsjA3vKEpg8RwfC=m-8QGfqa6ctxQday@mail.gmail.com>
 <20110107190656.GQ3702@decadent.org.uk> <AANLkTikwrHoOY4wvUp1qn-OT=EjZesSNR29US1ERc0o2@mail.gmail.com>
 <20110107222845.1cd02e26@varda>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Fri, 7 Jan 2011 14:25:16 -0800
Message-ID: <AANLkTikrynvdOP7qtiHqgmEzuAFTjB=rcN90cBv-VuVG@mail.gmail.com>
Subject: Re: [GIT] Networking
To: =?ISO-8859-1?Q?Alejandro_Riveira_Fern=E1ndez?= <ariveira@gmail.com>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2011/1/7 Alejandro Riveira Fernández <ariveira@gmail.com>:
>> [ Apart from the annoyance of also having to manually copying the
>> firmware files: why the heck doesn't that firmware tree even have a
>> "make firmware-install" makefile or something? The kernel has a "make
>> firmware-install" thing, why doesn't the firmware tree itself have
>> that? Gaah, this is almost as idiotic as trying to install a
>> self-built kernel under Ubuntu ]
>
>  Maybe i am just making myself a fool but i'll bite:
>  this has allways worked for me
>
>  make && sudo make install && sudo make modules_install
>  sudo mkintramfs -o /boot/initrd-$kernel_version  $kernel_version
>  sudo update-grub

Whee. That's not what any of the docs say. And while it is simpler
than what is apparently the "official" method (which involves packages
etc) why doesn't just

  make modules_install ; make install

work? That's all I need to do on systems that are friendlier to kernel
developers.

The kernel install scripts run "/sbin/installkernel" exactly so that a
distribution can just make it all work for them. But at least when I
tried it last, it didn't.

Some people claim Ubuntu has no kernel developers. Sometimes I do wonder..

                   Linus
