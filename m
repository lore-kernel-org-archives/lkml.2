Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756152Ab1HXC1B (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Aug 2011 22:27:01 -0400
Received: from mail-gx0-f174.google.com ([209.85.161.174]:35854 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755707Ab1HXC0y convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Aug 2011 22:26:54 -0400
MIME-Version: 1.0
In-Reply-To: <8289497114d3da8366ea7ed8397b4d3f16afb946.1314028707.git.mina86@mina86.com>
References: <cover.1314028707.git.mina86@mina86.com>
	<8289497114d3da8366ea7ed8397b4d3f16afb946.1314028707.git.mina86@mina86.com>
Date: Wed, 24 Aug 2011 10:26:53 +0800
Message-ID: <CABqxG0c=y=hH83CqHewnvrx+OHTLssymzu0Hai+kJzN6LTvYHw@mail.gmail.com>
Subject: Re: [PATCHv4 3/4] usb: gadget: rename usb_gadget_driver::speed to max_speed
From: Dave Young <hidave.darkstar@gmail.com>
To: Michal Nazarewicz <mnazarewicz@google.com>
Cc: Alan Stern <stern@rowland.harvard.edu>, Felipe Balbi <balbi@ti.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Yang Rui Rui <ruirui.r.yang@tieto.com>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 23, 2011 at 12:04 AM, Michal Nazarewicz
<mnazarewicz@google.com> wrote:
> From: Michal Nazarewicz <mina86@mina86.com>
>
> This commit renames the “speed” field of the usb_gadget_driver
> structure to “max_speed”.  This is so that to make it more
> apparent that the field represents the maximum speed gadget
> driver can support.
>
> This also make the field look more like fields with the same
> name in usb_gadget and usb_composite_driver structures.  All
> of those represent the *maximal* speed given entity supports.
>
> After this commit, there are the following fields in various
> structures:
> * usb_gadget::speed - the current connection speed,
> * usb_gadget::max_speed - maximal speed UDC supports,
> * usb_gadget_driver::max_speed - maximal speed gadget driver
>  supports, and
> * usb_composite_driver::max_speed - maximal speed composite
>  gadget supports.
>
> Signed-off-by: Michal Nazarewicz <mina86@mina86.com>
> ---
>  drivers/usb/gadget/amd5536udc.c   |    2 +-
>  drivers/usb/gadget/ci13xxx_udc.c  |    2 +-
>  drivers/usb/gadget/composite.c    |    8 ++++----
>  drivers/usb/gadget/dbgp.c         |    2 +-
>  drivers/usb/gadget/dummy_hcd.c    |   13 ++++++-------
>  drivers/usb/gadget/file_storage.c |    4 ++--
>  drivers/usb/gadget/gmidi.c        |    2 +-
>  drivers/usb/gadget/goku_udc.c     |    2 +-
>  drivers/usb/gadget/inode.c        |    6 +++---
>  drivers/usb/gadget/m66592-udc.c   |    2 +-
>  drivers/usb/gadget/net2272.c      |    2 +-
>  drivers/usb/gadget/net2280.c      |    2 +-
>  drivers/usb/gadget/pch_udc.c      |    2 +-
>  drivers/usb/gadget/printer.c      |    2 +-
>  drivers/usb/gadget/r8a66597-udc.c |    2 +-
>  include/linux/usb/gadget.h        |    4 ++--
>  16 files changed, 28 insertions(+), 29 deletions(-)
>

Still missing drivers/usb/musb/musb_gadget for the speed check


-- 
Regards
Yang RuiRui
