Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753337Ab0DZJs2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Apr 2010 05:48:28 -0400
Received: from cantor2.suse.de ([195.135.220.15]:35974 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753240Ab0DZJs0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Apr 2010 05:48:26 -0400
Date: Mon, 26 Apr 2010 11:48:24 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Wayne Thomas <waynethomas69@gmail.com>
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: HID: expand hid-topseed driver to support BTC "Emprex 3009URF
 III  Vista MCE Remote"
In-Reply-To: <t2g3711715e1004240718m8aacffc5o68fc9ccd1e66f212@mail.gmail.com>
Message-ID: <alpine.LNX.2.00.1004261146430.7579@pobox.suse.cz>
References: <t2g3711715e1004240718m8aacffc5o68fc9ccd1e66f212@mail.gmail.com>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 24 Apr 2010, Wayne Thomas wrote:

> +config HID_BTC
> +	tristate "BTC Emprex remote control support" if EMBEDDED
> +	depends on USB_HID
> +	default y
> +	---help---
> +	Say Y if you have a BTC Emprex remote control.
> +
>  config HID_CHERRY
>  	tristate "Cherry" if EMBEDDED
>  	depends on USB_HID
> diff -uprN linux-2.6.33-clean/drivers/hid/Makefile linux/drivers/hid/Makefile
> --- linux-2.6.33-clean/drivers/hid/Makefile	2010-04-22 20:48:43.000000000 +0200
> +++ linux/drivers/hid/Makefile	2010-04-22 21:29:20.000000000 +0200
> @@ -22,6 +22,7 @@ endif
>  obj-$(CONFIG_HID_A4TECH)	+= hid-a4tech.o
>  obj-$(CONFIG_HID_APPLE)		+= hid-apple.o
>  obj-$(CONFIG_HID_BELKIN)	+= hid-belkin.o
> +obj-$(CONFIG_HID_BTC)		+= hid-topseed.o
>  obj-$(CONFIG_HID_CHERRY)	+= hid-cherry.o
>  obj-$(CONFIG_HID_CHICONY)	+= hid-chicony.o
>  obj-$(CONFIG_HID_CYPRESS)	+= hid-cypress.o

The separate config option for this is just overhead, I think. I'd suggest 
just to update the Kconfig help text for CONFIG_TOPSPEED to mention that 
it supports also this particular device.

Thanks,

-- 
Jiri Kosina
SUSE Labs, Novell Inc.
