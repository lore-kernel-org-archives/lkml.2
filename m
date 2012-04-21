Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752273Ab2DUJHt (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Apr 2012 05:07:49 -0400
Received: from mail.linux-iscsi.org ([67.23.28.174]:33817 "EHLO
	linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751145Ab2DUJHr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Apr 2012 05:07:47 -0400
Subject: Re: linux-next: Tree for Apr 20 (usb & target)
From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
To: Randy Dunlap <rdunlap@xenotime.net>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>, linux-usb@vger.kernel.org,
        target-devel@vger.kernel.org,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Greg KH <gregkh@linuxfoundation.org>
In-Reply-To: <4F91D9D9.6020609@xenotime.net>
References: <20120420155151.3fcac4c2d1002ade5ccf44ac@canb.auug.org.au>
	 <4F91D9D9.6020609@xenotime.net>
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 21 Apr 2012 02:07:43 -0700
Message-ID: <1334999263.30707.129.camel@haakon2.linux-iscsi.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-04-20 at 14:49 -0700, Randy Dunlap wrote:
> On 04/19/2012 10:51 PM, Stephen Rothwell wrote:
> 
> > Hi all,
> > 
> > Changes since 20120419:
> 
> 

Hi Randy,

> CONFIG_MODULES is not enabled.
> CONFIG_TCM_USB_GADGET=y
> CONFIG_USB_GADGET=y
>
> drivers/usb/built-in.o: In function `usb_descriptor_fillbuf':
> (.text+0x53bb): multiple definition of `usb_descriptor_fillbuf'
> drivers/target/built-in.o:(.text+0x1e605): first defined here
> drivers/usb/built-in.o: In function `usb_string_ids_n':
> (.text+0x4f1a): multiple definition of `usb_string_ids_n'
> drivers/target/built-in.o:(.text+0x1f1ed): first defined here
> drivers/usb/built-in.o: In function `usb_interface_id':
> (.text+0x4ea8): multiple definition of `usb_interface_id'
> drivers/target/built-in.o:(.text+0x1f0bc): first defined here
> drivers/usb/built-in.o: In function `usb_string_id':
> (.text+0x4ecc): multiple definition of `usb_string_id'
> drivers/target/built-in.o:(.text+0x1f19f): first defined here
> drivers/usb/built-in.o: In function `usb_string_ids_tab':
> (.text+0x4ee8): multiple definition of `usb_string_ids_tab'
> drivers/target/built-in.o:(.text+0x1f1bb): first defined here
> drivers/usb/built-in.o: In function `usb_copy_descriptors':
> (.text+0x5a01): multiple definition of `usb_copy_descriptors'
> drivers/target/built-in.o:(.text+0x1ec48): first defined here
> drivers/usb/built-in.o: In function `usb_composite_unregister':
> (.text+0x4fe2): multiple definition of `usb_composite_unregister'
> drivers/target/built-in.o:(.text+0x1f2b5): first defined here
> drivers/usb/built-in.o: In function `config_ep_by_speed':
> (.text+0x4bd7): multiple definition of `config_ep_by_speed'
> drivers/target/built-in.o:(.text+0x1ecca): first defined here
> drivers/usb/built-in.o: In function `usb_gadget_get_string':
> (.text+0x5094): multiple definition of `usb_gadget_get_string'
> drivers/target/built-in.o:(.text+0x1dd85): first defined here
> drivers/usb/built-in.o: In function `usb_add_function':
> (.text+0x4cfc): multiple definition of `usb_add_function'
> drivers/target/built-in.o:(.text+0x1ee6c): first defined here
> drivers/usb/built-in.o: In function `usb_composite_probe':
> (.text+0x4f4a): multiple definition of `usb_composite_probe'
> drivers/target/built-in.o:(.text+0x1f21d): first defined here
> drivers/usb/built-in.o: In function `usb_composite_setup_continue':
> (.text+0x4ffd): multiple definition of `usb_composite_setup_continue'
> drivers/target/built-in.o:(.text+0x1f369): first defined here
> drivers/usb/built-in.o: In function `usb_gadget_config_buf':
> (.text+0x59ad): multiple definition of `usb_gadget_config_buf'
> drivers/target/built-in.o:(.text+0x1ebf4): first defined here
> drivers/usb/built-in.o: In function `usb_ep_autoconfig':
> (.text+0x5bba): multiple definition of `usb_ep_autoconfig'
> drivers/target/built-in.o:(.text+0x1e358): first defined here
> drivers/usb/built-in.o: In function `usb_function_activate':
> (.text+0x4e29): multiple definition of `usb_function_activate'
> drivers/target/built-in.o:(.text+0x1f03b): first defined here
> drivers/usb/built-in.o: In function `usb_ep_autoconfig_reset':
> (.text+0x5bc7): multiple definition of `usb_ep_autoconfig_reset'
> drivers/target/built-in.o:(.text+0x1e365): first defined here
> drivers/usb/built-in.o: In function `usb_add_config':
> (.text+0x5e6a): multiple definition of `usb_add_config'
> drivers/target/built-in.o:(.text+0x1f0e0): first defined here
> drivers/usb/built-in.o: In function `usb_ep_autoconfig_ss':
> (.text+0x5a83): multiple definition of `usb_ep_autoconfig_ss'
> drivers/target/built-in.o:(.text+0x1e0ab): first defined here
> drivers/usb/built-in.o: In function `usb_function_deactivate':
> (.text+0x4dc2): multiple definition of `usb_function_deactivate'
> drivers/target/built-in.o:(.text+0x1efd4): first defined here
> 
> 

Mmmm, It looks like the source file include usage in target/usb-gadget.c
might be causing some problems here:

#include "usbstring.c"
#include "epautoconf.c"
#include "config.c"
#include "composite.c"

Sebastian + Greg-KH (Cc'ed), any ideas why this is the case here..?

Thanks,

--nab

