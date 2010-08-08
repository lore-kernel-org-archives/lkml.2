Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754809Ab0HHUzh (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Aug 2010 16:55:37 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:48480 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753799Ab0HHUzf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Aug 2010 16:55:35 -0400
Date: Sun, 8 Aug 2010 13:55:11 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Randy Dunlap <randy.dunlap@oracle.com>, linux-media@vger.kernel.org
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: linux-next: Tree for August 7 (IR)
Message-Id: <20100808135511.269f670c.randy.dunlap@oracle.com>
In-Reply-To: <20100807203920.83134a60.randy.dunlap@oracle.com>
References: <20100807160710.b7c8d838.sfr@canb.auug.org.au>
	<20100807203920.83134a60.randy.dunlap@oracle.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 7 Aug 2010 20:39:20 -0700 Randy Dunlap wrote:

[adding linux-media]

> On Sat, 7 Aug 2010 16:07:10 +1000 Stephen Rothwell wrote:
> 
> > Hi all,
> > 
> > As the merge window is open, please do not add 2.6.37 material to your
> > linux-next included trees until after 2.6.36-rc1.
> > 
> > Changes since 20100806:
> 
> 2 sets of IR build errors (2 .config files attached):
> 
> #5091:
> ERROR: "ir_keydown" [drivers/media/video/ir-kbd-i2c.ko] undefined!
> ERROR: "__ir_input_register" [drivers/media/video/ir-kbd-i2c.ko] undefined!
> ERROR: "get_rc_map" [drivers/media/video/ir-kbd-i2c.ko] undefined!
> ERROR: "ir_input_unregister" [drivers/media/video/ir-kbd-i2c.ko] undefined!
> ERROR: "get_rc_map" [drivers/media/video/cx88/cx88xx.ko] undefined!
> ERROR: "ir_repeat" [drivers/media/video/cx88/cx88xx.ko] undefined!
> ERROR: "ir_input_unregister" [drivers/media/video/cx88/cx88xx.ko] undefined!
> ERROR: "ir_keydown" [drivers/media/video/cx88/cx88xx.ko] undefined!
> ERROR: "__ir_input_register" [drivers/media/video/cx88/cx88xx.ko] undefined!
> ERROR: "get_rc_map" [drivers/media/video/bt8xx/bttv.ko] undefined!
> ERROR: "ir_input_unregister" [drivers/media/video/bt8xx/bttv.ko] undefined!
> ERROR: "__ir_input_register" [drivers/media/video/bt8xx/bttv.ko] undefined!
> ERROR: "ir_g_keycode_from_table" [drivers/media/IR/ir-common.ko] undefined!
> 
> 
> #5101:
> (.text+0x8306e2): undefined reference to `ir_core_debug'
> (.text+0x830729): undefined reference to `ir_core_debug'
> ir-functions.c:(.text+0x830906): undefined reference to `ir_core_debug'
> (.text+0x8309d8): undefined reference to `ir_g_keycode_from_table'
> (.text+0x830acf): undefined reference to `ir_core_debug'
> (.text+0x830b92): undefined reference to `ir_core_debug'
> (.text+0x830bef): undefined reference to `ir_core_debug'
> (.text+0x830c6a): undefined reference to `ir_core_debug'
> (.text+0x830cf7): undefined reference to `ir_core_debug'
> budget-ci.c:(.text+0x89f5c8): undefined reference to `ir_keydown'
> budget-ci.c:(.text+0x8a0c58): undefined reference to `get_rc_map'
> budget-ci.c:(.text+0x8a0c80): undefined reference to `__ir_input_register'
> budget-ci.c:(.text+0x8a0ee0): undefined reference to `get_rc_map'
> budget-ci.c:(.text+0x8a11cd): undefined reference to `ir_input_unregister'
> (.text+0x8a8adb): undefined reference to `ir_input_unregister'
> dvb-usb-remote.c:(.text+0x8a9188): undefined reference to `get_rc_map'
> dvb-usb-remote.c:(.text+0x8a91b1): undefined reference to `__ir_input_register'
> dvb-usb-remote.c:(.text+0x8a9238): undefined reference to `get_rc_map'
> dib0700_core.c:(.text+0x8b04ca): undefined reference to `ir_keydown'
> dib0700_devices.c:(.text+0x8b2ea8): undefined reference to `ir_keydown'
> dib0700_devices.c:(.text+0x8b2ef0): undefined reference to `ir_keydown'
> 
> 
> ---
> ~Randy
> *** Remember to use Documentation/SubmitChecklist when testing your code ***


---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
