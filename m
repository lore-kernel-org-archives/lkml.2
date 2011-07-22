Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753859Ab1GVKRX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jul 2011 06:17:23 -0400
Received: from lucidpixels.com ([72.73.18.11]:45477 "EHLO lucidpixels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753662Ab1GVKRW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jul 2011 06:17:22 -0400
Date: Fri, 22 Jul 2011 06:17:21 -0400 (EDT)
From: Justin Piszcz <jpiszcz@lucidpixels.com>
To: Clemens Ladisch <clemens@ladisch.de>
cc: linux-kernel@vger.kernel.org
Subject: Re: 2.6.39.2: alsa question: usb sound/card shows up as
 mixer1/audio1?
In-Reply-To: <4E292F01.1040400@ladisch.de>
Message-ID: <alpine.DEB.2.02.1107220523110.2771@p34.internal.lan>
References: <alpine.DEB.2.02.1107141656480.10111@p34.internal.lan> <4E292F01.1040400@ladisch.de>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; format=flowed; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Fri, 22 Jul 2011, Clemens Ladisch wrote:

> Justin Piszcz wrote:
> > I bought two of these but they are actually different devices, on one host 
> > it works ok, on the other, I get this:
> > ...
> > $ cat /proc/asound/cards
> >   1 [Device         ]: USB-Audio - C-Media USB Audio Device
> >                        C-Media USB Audio Device at usb-0000:00:1d.7-2.4, full speed
> > 
> > On the working host:
> > $ cat /proc/asound/cards
> >   0 [Device         ]: USB-Audio - USB PnP Sound Device
> >                        C-Media Electronics Inc. USB PnP Sound Device at usb-0000:00:1d.7-2.4, full spe
> > 
> > Any clue why one is mapped to [1] and the other [0], where the one that is
> > [0] works properly and the [1] does not?
> 
> Some distributions configure USB devices to not load at index 0 to
> prevent conflicts with the primary PCI sound card.  Have a look into
> /etc/modprobe.d/.
> 
> 
> Regards,
> Clemens
>

Hi,

That was it, thanks.

Justin.

