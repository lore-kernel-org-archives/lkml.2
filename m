Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757011Ab0JUKzY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Oct 2010 06:55:24 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:50482 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756735Ab0JUKzW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Oct 2010 06:55:22 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=uZpRy31UuxR982JPqNzXuXlVQTt/dUwNJaAioVUsUcjVfh398ZjSm+zfwCuwL2MHcu
         JrC8Z6WN/0qbBgrQhSTPBWzdyfSq7oBdsSepWKzim+6162zHyinAiyb4qy8zaMjM243w
         6WN7bQPxR65ZOhw+Sn5MiVhvb83+zA4ikNU1A=
MIME-Version: 1.0
In-Reply-To: <20101021102433.GG3958@legolas.emea.dhcp.ti.com>
References: <4CBE9E69.6060803@nokia.com>
	<AANLkTinOYDBMVZ3ibG3Md7jdOuOC6NkGWaugvHwT6uqF@mail.gmail.com>
	<4CBEB312.7060400@nokia.com>
	<AANLkTikom=eRFqCJmYE+k1zn5K2MR9s8HhNXtjOvUqvr@mail.gmail.com>
	<20101020125407.GE2433@legolas.emea.dhcp.ti.com>
	<AANLkTi=+6bC=JALdCDKW_BS-jnNk3zFPuWuBT+aY=Utx@mail.gmail.com>
	<20101020151527.GF2883@legolas.emea.dhcp.ti.com>
	<AANLkTim-QeP0hfSVGUd-tHWso9HQv25TwapBBZ1KPD3=@mail.gmail.com>
	<20101020175420.GC3431@legolas.emea.dhcp.ti.com>
	<AANLkTin31dmD5OfR3-nvZSg82i3H=_xgH_isJc+Epttq@mail.gmail.com>
	<20101021102433.GG3958@legolas.emea.dhcp.ti.com>
Date: Thu, 21 Oct 2010 13:55:20 +0300
Message-ID: <AANLkTimUw1F9KJTjmsuahBUYLGRHGROsW7+nE3sj7Ywv@mail.gmail.com>
Subject: Re: [PATCH v2 3/3] drivers: cleanup Kconfig stuff
From: Felipe Contreras <felipe.contreras@gmail.com>
To: balbi@ti.com
Cc: Roger Quadros <roger.quadros@nokia.com>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        linux-omap <linux-omap@vger.kernel.org>,
        linux-main <linux-kernel@vger.kernel.org>, Greg KH <greg@kroah.com>,
        Tony Lindgren <tony@atomide.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Thu, Oct 21, 2010 at 1:24 PM, Felipe Balbi <balbi@ti.com> wrote:
> On Thu, Oct 21, 2010 at 04:04:27AM -0500, Felipe Contreras wrote:
>>>
>>> wouldn't a user expect USB to be enabled if the board _has_ a USB
>>> connector ?
>>
>> Not if it's not going to be used.
>
> and how would you know before hand if it's going to be used or not ?

You don't, that's what Kconfig is for: so the user can dynamically
select what he wants or not on the kernel. And in order for it to be
useful, dependencies have to be correct.

>>>> 1) Do you think all the OMAP3 boards should add that?
>>>
>>> why not ?
>>
>> You prefer a patch that adds one line per board rather than a patch
>> that adds one line in total... That is exactly the opposite of Linus's
>> complaint regarding big ARM changesets.
>
> The thing is that what you are proposing will not scale when we have too
> many boards with different transceivers. Then we will end up with things
> like:
>
> config USB_ARCH_HAS_OHCI

[...]

We are not talking about USB_ARCH_HAS_OHCI, we are talking about
TWL4030_USB, there's nothing to scale there.

-- 
Felipe Contreras
