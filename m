Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757739Ab2DXVLG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Apr 2012 17:11:06 -0400
Received: from mail160.messagelabs.com ([216.82.253.99]:6576 "EHLO
	mail160.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757697Ab2DXVLF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Apr 2012 17:11:05 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-15.tower-160.messagelabs.com!1335301849!4683276!30
X-Originating-IP: [216.166.12.180]
X-StarScan-Version: 6.5.7; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: linux-next: allyesconfig build failure in drivers/usb/gadget
Date: Tue, 24 Apr 2012 14:10:36 -0700
User-Agent: KMail/1.9.9
CC: <linux-usb@vger.kernel.org>, <balbi@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-ID: <201204241410.37561.hartleys@visionengravers.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello all,

I'm not sure if this is a known issue or not...

I was trying an allyesconfig build of linux-next (next-20120224) and got this:

drivers/usb/built-in.o: In function `usb_descriptor_fillbuf':
/home/bigguiness/src/git/linux-next/drivers/usb/gadget/config.c:38: multiple definition of `usb_descriptor_fillbuf'
drivers/target/built-in.o:/home/bigguiness/src/git/linux-next/drivers/usb/gadget/config.c:38: first defined here
drivers/usb/built-in.o: In function `usb_string_ids_n':
/home/bigguiness/src/git/linux-next/drivers/usb/gadget/composite.c:994: multiple definition of `usb_string_ids_n'
drivers/target/built-in.o:/home/bigguiness/src/git/linux-next/drivers/usb/gadget/composite.c:994: first defined here
drivers/usb/built-in.o: In function `usb_interface_id':
/home/bigguiness/src/git/linux-next/drivers/usb/gadget/composite.c:341: multiple definition of `usb_interface_id'
drivers/target/built-in.o:/home/bigguiness/src/git/linux-next/drivers/usb/gadget/composite.c:341: first defined here
drivers/usb/built-in.o: In function `usb_string_id':
/home/bigguiness/src/git/linux-next/drivers/usb/gadget/composite.c:932: multiple definition of `usb_string_id'
drivers/target/built-in.o:/home/bigguiness/src/git/linux-next/drivers/usb/gadget/composite.c:932: first defined here
drivers/usb/built-in.o: In function `usb_string_ids_tab':
/home/bigguiness/src/git/linux-next/drivers/usb/gadget/composite.c:960: multiple definition of `usb_string_ids_tab'
drivers/target/built-in.o:/home/bigguiness/src/git/linux-next/drivers/usb/gadget/composite.c:960: first defined here
drivers/usb/built-in.o: In function `usb_copy_descriptors':
/home/bigguiness/src/git/linux-next/drivers/usb/gadget/config.c:124: multiple definition of `usb_copy_descriptors'
drivers/target/built-in.o:/home/bigguiness/src/git/linux-next/drivers/usb/gadget/config.c:124: first defined here
drivers/usb/built-in.o: In function `usb_composite_unregister':
/home/bigguiness/src/git/linux-next/drivers/usb/gadget/composite.c:1602: multiple definition of `usb_composite_unregister'
drivers/target/built-in.o:/home/bigguiness/src/git/linux-next/drivers/usb/gadget/composite.c:1602: first defined here
drivers/usb/built-in.o: In function `config_ep_by_speed':
/home/bigguiness/src/git/linux-next/drivers/usb/gadget/composite.c:119: multiple definition of `config_ep_by_speed'
drivers/target/built-in.o:/home/bigguiness/src/git/linux-next/drivers/usb/gadget/composite.c:119: first defined here
drivers/usb/built-in.o: In function `usb_gadget_get_string':
/home/bigguiness/src/git/linux-next/drivers/usb/gadget/usbstring.c:41: multiple definition of `usb_gadget_get_string'
drivers/target/built-in.o:/home/bigguiness/src/git/linux-next/drivers/usb/gadget/usbstring.c:41: first defined here
drivers/usb/built-in.o: In function `usb_add_function':
/home/bigguiness/src/git/linux-next/drivers/usb/gadget/composite.c:209: multiple definition of `usb_add_function'
drivers/target/built-in.o:/home/bigguiness/src/git/linux-next/drivers/usb/gadget/composite.c:209: first defined here
drivers/usb/built-in.o: In function `usb_composite_probe':
/home/bigguiness/src/git/linux-next/drivers/usb/gadget/composite.c:1576: multiple definition of `usb_composite_probe'
drivers/target/built-in.o:/home/bigguiness/src/git/linux-next/drivers/usb/gadget/composite.c:1576: first defined here
drivers/usb/built-in.o: In function `usb_composite_setup_continue':
/home/bigguiness/src/git/linux-next/drivers/usb/gadget/composite.c:1619: multiple definition of `usb_composite_setup_continue'
drivers/target/built-in.o:/home/bigguiness/src/git/linux-next/drivers/usb/gadget/composite.c:1619: first defined here
drivers/usb/built-in.o: In function `usb_gadget_config_buf':
/home/bigguiness/src/git/linux-next/drivers/usb/gadget/config.c:84: multiple definition of `usb_gadget_config_buf'
drivers/target/built-in.o:/home/bigguiness/src/git/linux-next/drivers/usb/gadget/config.c:84: first defined here
drivers/usb/built-in.o: In function `usb_ep_autoconfig':
/home/bigguiness/src/git/linux-next/drivers/usb/gadget/epautoconf.c:367: multiple definition of `usb_ep_autoconfig'
drivers/target/built-in.o:/home/bigguiness/src/git/linux-next/drivers/usb/gadget/epautoconf.c:367: first defined here
drivers/usb/built-in.o: In function `usb_function_activate':
/home/bigguiness/src/git/linux-next/drivers/usb/gadget/composite.c:298: multiple definition of `usb_function_activate'
drivers/target/built-in.o:/home/bigguiness/src/git/linux-next/drivers/usb/gadget/composite.c:298: first defined here
drivers/usb/built-in.o: In function `usb_ep_autoconfig_reset':
/home/bigguiness/src/git/linux-next/drivers/usb/gadget/epautoconf.c:382: multiple definition of `usb_ep_autoconfig_reset'
drivers/target/built-in.o:/home/bigguiness/src/git/linux-next/drivers/usb/gadget/epautoconf.c:382: first defined here
drivers/usb/built-in.o: In function `usb_add_config':
/home/bigguiness/src/git/linux-next/drivers/usb/gadget/composite.c:713: multiple definition of `usb_add_config'
drivers/target/built-in.o:/home/bigguiness/src/git/linux-next/drivers/usb/gadget/composite.c:713: first defined here
drivers/usb/built-in.o: In function `usb_ep_autoconfig_ss':
/home/bigguiness/src/git/linux-next/drivers/usb/gadget/epautoconf.c:265: multiple definition of `usb_ep_autoconfig_ss'
drivers/target/built-in.o:/home/bigguiness/src/git/linux-next/drivers/usb/gadget/epautoconf.c:265: first defined here
drivers/usb/built-in.o: In function `usb_function_deactivate':
/home/bigguiness/src/git/linux-next/drivers/usb/gadget/composite.c:271: multiple definition of `usb_function_deactivate'
drivers/target/built-in.o:/home/bigguiness/src/git/linux-next/drivers/usb/gadget/composite.c:271: first defined here
make[1]: *** [drivers/built-in.o] Error 1
make: *** [drivers] Error 2

It appears config.c, composite.c, usbstring.c, and epautoconf.c are not
actually built separately during the make but are #include'd by various
other sources. All of these files have functions that are not marked static
so we end up with the 'multiple definition' errors.

Should these files be compiled separately and treated as a gadget library?

Regards,
Hartley
