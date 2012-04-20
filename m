Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755140Ab2DTVsm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Apr 2012 17:48:42 -0400
Received: from oproxy7-pub.bluehost.com ([67.222.55.9]:45272 "HELO
	oproxy7-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754884Ab2DTVsk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Apr 2012 17:48:40 -0400
Message-ID: <4F91D9D9.6020609@xenotime.net>
Date: Fri, 20 Apr 2012 14:49:13 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110323 Thunderbird/3.1.9
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        linux-usb@vger.kernel.org, target-devel@vger.kernel.org
Subject: Re: linux-next: Tree for Apr 20 (usb & target)
References: <20120420155151.3fcac4c2d1002ade5ccf44ac@canb.auug.org.au>
In-Reply-To: <20120420155151.3fcac4c2d1002ade5ccf44ac@canb.auug.org.au>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Identified-User: {1807:box742.bluehost.com:xenotime:xenotime.net} {sentby:smtp auth 50.53.38.135 authed with rdunlap@xenotime.net}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/19/2012 10:51 PM, Stephen Rothwell wrote:

> Hi all,
> 
> Changes since 20120419:


CONFIG_MODULES is not enabled.
CONFIG_TCM_USB_GADGET=y
CONFIG_USB_GADGET=y



drivers/usb/built-in.o: In function `usb_descriptor_fillbuf':
(.text+0x53bb): multiple definition of `usb_descriptor_fillbuf'
drivers/target/built-in.o:(.text+0x1e605): first defined here
drivers/usb/built-in.o: In function `usb_string_ids_n':
(.text+0x4f1a): multiple definition of `usb_string_ids_n'
drivers/target/built-in.o:(.text+0x1f1ed): first defined here
drivers/usb/built-in.o: In function `usb_interface_id':
(.text+0x4ea8): multiple definition of `usb_interface_id'
drivers/target/built-in.o:(.text+0x1f0bc): first defined here
drivers/usb/built-in.o: In function `usb_string_id':
(.text+0x4ecc): multiple definition of `usb_string_id'
drivers/target/built-in.o:(.text+0x1f19f): first defined here
drivers/usb/built-in.o: In function `usb_string_ids_tab':
(.text+0x4ee8): multiple definition of `usb_string_ids_tab'
drivers/target/built-in.o:(.text+0x1f1bb): first defined here
drivers/usb/built-in.o: In function `usb_copy_descriptors':
(.text+0x5a01): multiple definition of `usb_copy_descriptors'
drivers/target/built-in.o:(.text+0x1ec48): first defined here
drivers/usb/built-in.o: In function `usb_composite_unregister':
(.text+0x4fe2): multiple definition of `usb_composite_unregister'
drivers/target/built-in.o:(.text+0x1f2b5): first defined here
drivers/usb/built-in.o: In function `config_ep_by_speed':
(.text+0x4bd7): multiple definition of `config_ep_by_speed'
drivers/target/built-in.o:(.text+0x1ecca): first defined here
drivers/usb/built-in.o: In function `usb_gadget_get_string':
(.text+0x5094): multiple definition of `usb_gadget_get_string'
drivers/target/built-in.o:(.text+0x1dd85): first defined here
drivers/usb/built-in.o: In function `usb_add_function':
(.text+0x4cfc): multiple definition of `usb_add_function'
drivers/target/built-in.o:(.text+0x1ee6c): first defined here
drivers/usb/built-in.o: In function `usb_composite_probe':
(.text+0x4f4a): multiple definition of `usb_composite_probe'
drivers/target/built-in.o:(.text+0x1f21d): first defined here
drivers/usb/built-in.o: In function `usb_composite_setup_continue':
(.text+0x4ffd): multiple definition of `usb_composite_setup_continue'
drivers/target/built-in.o:(.text+0x1f369): first defined here
drivers/usb/built-in.o: In function `usb_gadget_config_buf':
(.text+0x59ad): multiple definition of `usb_gadget_config_buf'
drivers/target/built-in.o:(.text+0x1ebf4): first defined here
drivers/usb/built-in.o: In function `usb_ep_autoconfig':
(.text+0x5bba): multiple definition of `usb_ep_autoconfig'
drivers/target/built-in.o:(.text+0x1e358): first defined here
drivers/usb/built-in.o: In function `usb_function_activate':
(.text+0x4e29): multiple definition of `usb_function_activate'
drivers/target/built-in.o:(.text+0x1f03b): first defined here
drivers/usb/built-in.o: In function `usb_ep_autoconfig_reset':
(.text+0x5bc7): multiple definition of `usb_ep_autoconfig_reset'
drivers/target/built-in.o:(.text+0x1e365): first defined here
drivers/usb/built-in.o: In function `usb_add_config':
(.text+0x5e6a): multiple definition of `usb_add_config'
drivers/target/built-in.o:(.text+0x1f0e0): first defined here
drivers/usb/built-in.o: In function `usb_ep_autoconfig_ss':
(.text+0x5a83): multiple definition of `usb_ep_autoconfig_ss'
drivers/target/built-in.o:(.text+0x1e0ab): first defined here
drivers/usb/built-in.o: In function `usb_function_deactivate':
(.text+0x4dc2): multiple definition of `usb_function_deactivate'
drivers/target/built-in.o:(.text+0x1efd4): first defined here



-- 
~Randy
