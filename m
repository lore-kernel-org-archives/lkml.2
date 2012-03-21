Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030874Ab2CULKy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Mar 2012 07:10:54 -0400
Received: from mail.karo-electronics.de ([81.173.242.67]:58340 "EHLO
	mail.karo-electronics.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751801Ab2CULKw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Mar 2012 07:10:52 -0400
Message-ID: <20329.46902.300917.811262@ipc1.ka-ro>
Date: Wed, 21 Mar 2012 12:10:46 +0100
From: =?utf-8?Q?Lothar_Wa=C3=9Fmann?= <LW@KARO-electronics.de>
To: balbi@ti.com
Cc: linux-usb@vger.kernel.org, Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] usb gadget: fix a section mismatch when compiling g_ffs
 with CONFIG_USB_FUNCTIONFS_ETH
In-Reply-To: <20120321100402.GL3092@arwen.pp.htv.fi>
References: <1331472670-28589-1-git-send-email-LW@KARO-electronics.de>
	<1331474926-9237-1-git-send-email-LW@KARO-electronics.de>
	<20120321100402.GL3092@arwen.pp.htv.fi>
X-Mailer: VM 8.1.0 under 23.2.1 (i486-pc-linux-gnu)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Felipe Balbi writes:
> Hi,
> 
> On Sun, Mar 11, 2012 at 03:08:46PM +0100, Lothar Waßmann wrote:
> > Hi,
> > 
> > please ignore the previous message. I sent the patch out too early.
> > Here is a revised version.
> > 
> >  commit 28824b18ac4705e876a282a15ea0de8fc957551f:
> >  |Author: Michal Nazarewicz <m.nazarewicz@samsung.com>
> >  |Date:   Wed May 5 12:53:13 2010 +0200
> >  |
> >  |    USB: gadget: __init and __exit tags removed
> >  |
> >  |    __init, __initdata and __exit tags have have been removed from
> >  |    various files to make it possible for gadgets that do not use
> >  |    the __init/__exit tags to use those.
> >  obviously missed (at least) this case leading to a section mismatch in
> >  g_ffs.c when compiling with CONFIG_USB_FUNCTIONFS_ETH enabled.
> > 
> > Signed-off-by: Lothar Waßmann <LW@KARO-electronics.de>
> 
> please send in proper patch format and while at that include any Acks
> you already got.
> 
What's wrong with the format?
I used git-format-patch to create it, which should produce a properly
formatted patch AFAIK.


Lothar Waßmann
-- 
___________________________________________________________

Ka-Ro electronics GmbH | Pascalstraße 22 | D - 52076 Aachen
Phone: +49 2408 1402-0 | Fax: +49 2408 1402-10
Geschäftsführer: Matthias Kaussen
Handelsregistereintrag: Amtsgericht Aachen, HRB 4996

www.karo-electronics.de | info@karo-electronics.de
___________________________________________________________
