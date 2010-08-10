Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757966Ab0HJUhh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Aug 2010 16:37:37 -0400
Received: from cantor.suse.de ([195.135.220.2]:39361 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757843Ab0HJUhf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Aug 2010 16:37:35 -0400
Date: Tue, 10 Aug 2010 13:34:59 -0700
From: Greg KH <gregkh@suse.de>
To: Dhaval Giani <dhaval.giani@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: Re: USB device getting different product ids
Message-ID: <20100810203458.GA24808@suse.de>
References: <AANLkTimGrTFF_PnUwEkb4_Tg0Ag0ocHuKSVGswYK1dzJ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTimGrTFF_PnUwEkb4_Tg0Ag0ocHuKSVGswYK1dzJ@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 10, 2010 at 05:08:00PM +0200, Dhaval Giani wrote:
> Heya,
> 
> Admittedly I am using an older kernel, but I was wondering if a USB
> device can get different product ids on being plugged in at different
> times. I have one of these nice USB modems to connect to the internet
> . It is one of these huawei devices. Now, most of the times, it gets
> detected with vendor id 0x12d1 and product id 0x1446. In this mode, on
> loading the usbserial module, I see only ttyUSB0 come up, which for
> whatever reason, I am unable to use to connect to the internet.
> However when it is detected as the product id 0x140b, I get
> ttyUSB[0-2] which then connects very nicely via both wvdial and
> networkmanager to the internet. Now obviously, I would like for the
> device to get detected as 0x140b each time, as opposed to me pulling
> it out and inserting it back in till does get detected as 0x140b :-).
> 
> So my question is,
> 
> 1. Is it possible for the same device to get different product ids at
> different times

Yes, it's quite common for some devices to do this.

> 2. If so, how do I possibly get it to detect the id I want, as opposed
> to playing a game of chance.

Look at the usb-modeswitch program, it's what you want to control this.

> (I would copy linux-usb if I knew the mailing list id, but as I am on
> a slow GPRS connection, which is quite flaky right now, I would like
> to send this out right now. Please copy that list if it would help!)

In the future, it's the linux-usb@vger.kernel.org list, also available in
the MAINTAINERS file.

thanks,

greg k-h
