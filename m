Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753752Ab1HCRb1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Aug 2011 13:31:27 -0400
Received: from lucidpixels.com ([72.73.18.11]:35761 "EHLO lucidpixels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752654Ab1HCRbU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Aug 2011 13:31:20 -0400
Date: Wed, 3 Aug 2011 13:31:19 -0400 (EDT)
From: Justin Piszcz <jpiszcz@lucidpixels.com>
To: Stanislaw Gruszka <sgruszka@redhat.com>
cc: Andreas Hartmann <andihartmann@01019freenet.de>,
        Larry Finger <Larry.Finger@lwfinger.net>,
        Ivo van Doorn <IvDoorn@gmail.com>, linux-kernel@vger.kernel.org,
        linux-wireless@vger.kernel.org, Alan Piszcz <ap@solarrain.com>,
        "users@rt2x00.serialmonkey.com" <users@rt2x00.serialmonkey.com>
Subject: Re: [PATCH] rt2x00: rt2800: fix zeroing skb structure
In-Reply-To: <20110803160050.GA18882@redhat.com>
Message-ID: <alpine.DEB.2.02.1108031328030.9421@p34.internal.lan>
References: <alpine.DEB.2.02.1107271851410.25432@p34.internal.lan> <4E318BD0.40202@lwfinger.net> <20110730113009.GA2847@redhat.com> <20110730113255.GB2847@redhat.com> <alpine.DEB.2.02.1107300736010.4925@p34.internal.lan> <alpine.DEB.2.02.1107301015340.4925@p34.internal.lan>
 <alpine.DEB.2.02.1107301031560.4925@p34.internal.lan> <4E341DC4.9010107@01019freenet.de> <alpine.DEB.2.02.1107301305590.4925@p34.internal.lan> <20110803160050.GA18882@redhat.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 3 Aug 2011, Stanislaw Gruszka wrote:

> On Sat, Jul 30, 2011 at 01:07:11PM -0400, Justin Piszcz wrote:
>> Here you go, crash 2:
>> http://home.comcast.net/~jpiszcz/20110730/2630-rt2800usb-crash2p1.jpg
>> http://home.comcast.net/~jpiszcz/20110730/2630-rt2800usb-crash2p2.jpg
>
> Here is next (draw) patch to test:

Thanks,

# patch -p1 < ../patch4
patching file drivers/net/wireless/rt2x00/rt2800lib.c
patching file drivers/net/wireless/rt2x00/rt2800lib.h
patching file drivers/net/wireless/rt2x00/rt2800usb.c
patching file drivers/net/wireless/rt2x00/rt2x00queue.c
patching file drivers/net/wireless/rt2x00/rt2x00usb.c
#

I'll give this driver one more chance (quickly) and let you know if it crashes
afterwards (usually crashes in 5-10 minutes), but most likely I am going to
move over to some other wireless usb sticks, got a couple think penguin usb
wifi sticks that use the carl driver, 'open source' wireless usb sticks, 
going to give them a try next.

Also got some other ones as well, hopefully one of them will work without
900ms of lag.  The rt2870sta was the best driver in 2.6.38.x series that I
have ever used for wireless USB sticks.

Justin.

