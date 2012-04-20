Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757245Ab2DTQT7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Apr 2012 12:19:59 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:47187 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754815Ab2DTQT5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Apr 2012 12:19:57 -0400
X-Sasl-enc: t7CW54Civ1z6p2HTsl1IV1tRzjrhaSN4c6wfCDhcOmf3 1334938796
Date: Fri, 20 Apr 2012 09:19:55 -0700
From: Greg KH <greg@kroah.com>
To: Anil Nair <anilcoll90@gmail.com>
Cc: Wang YanQing <Udknight@gmail.com>, lkml <linux-kernel@vger.kernel.org>,
        linux-usb@vger.kernel.org
Subject: Re: [RFC]Is usb port number fixed?
Message-ID: <20120420161955.GA7090@kroah.com>
References: <20120420092525.GA12660@udknight>
 <20120420093738.GA12755@udknight>
 <20120420153727.GA29331@kroah.com>
 <CAHkwNT=VW8qF-7QRxpiaWkmQm0UFdsbahFLhT-PCc4OMnVs1Gg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAHkwNT=VW8qF-7QRxpiaWkmQm0UFdsbahFLhT-PCc4OMnVs1Gg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

<Please don't post HTML email, the mailing lists reject your messages
that way>

On Fri, Apr 20, 2012 at 09:39:37PM +0530, Anil Nair wrote:
> 
> 
>     >USB ports on a hub are all enumerated the same, but the root hubs
>     >aren't, and sometimes hubs on the same bus are not as well.
> 
>  
>   Does every device assigned a port number serially, that is in increasing
> order?

Yes.

>   If a USB port number is assigned to a USB device then are other USB devices
> able to use it,
>   if connected USB device is Disconnected?

It can, why?  USB devices don't care about their device number.

>     >But usually, things do come up in the same way all the time, so
>     >depending on your use case, you can rely on this, but it is recommended
>     >that you look for something else a bit more unique, like a serial number
>     >on a device (if it is present), if you wish to uniquely identify a
>     >device all the time.
> 
> 
>   Does the Linux Kernel keeps the history of connected devices? So that next
> time,   the same USB device get assigned the same USB port number.

No.  I think you are confusing port number with the USB device number,
both of which mean nothing to a USB device at all, and they shouldn't to
anyone else.

greg k-h
