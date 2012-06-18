Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752118Ab2FRH3h (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jun 2012 03:29:37 -0400
Received: from mail.aixigo.de ([80.149.209.52]:61641 "EHLO mail.aixigo.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751378Ab2FRH3g (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jun 2012 03:29:36 -0400
X-Greylist: delayed 1777 seconds by postgrey-1.27 at vger.kernel.org; Mon, 18 Jun 2012 03:29:35 EDT
Message-ID: <4FDED1E7.6020001@aixigo.de>
Date: Mon, 18 Jun 2012 08:59:51 +0200
From: Harald Dunkel <harald.dunkel@aixigo.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120617 Thunderbird/13.0.1
MIME-Version: 1.0
To: richard -rw- weinberger <richard.weinberger@gmail.com>
CC: Harald Dunkel <harri@afaics.de>,
        Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-console@vger.kernel.org
Subject: Re: wishlist: vnc framebuffer device?
References: <4FDC6874.4070106@afaics.de> <CAFLxGvxpXBgOH=rhNUdE2FN=mm90sX4-Atwc4k-VrSxoAVZh9A@mail.gmail.com>
In-Reply-To: <CAFLxGvxpXBgOH=rhNUdE2FN=mm90sX4-Atwc4k-VrSxoAVZh9A@mail.gmail.com>
X-Enigmail-Version: 1.4.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Richard,

On 06/17/12 12:13, richard -rw- weinberger wrote:
> 
> What about a VNC server which exports a framebuffer device?
> Like: http://code.google.com/p/android-vnc
> 
> No need to implement VNC in kernel space.
> 

If it can run in user space, then thats fine with me. But I
would guess the pseudo framebuffer device itself (without the
networking, authentication and encryption stuff) has to
reside in the kernel.

It is very important to me to get access to the VNC console
very early in the boot procedure, e.g. if there is a fsck
asking for help, or if a badly configured root device drops
me on busybox.

For qemu/kvm hosts (and others) it is very convenient to
access the console via VNC. For "real" hosts I am restricted
to SOL or some remote management hardware module providing
a web interface.

It would be very nice to get an improvement here.


Regards

Harri
