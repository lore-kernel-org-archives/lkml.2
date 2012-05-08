Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755299Ab2EHNWY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2012 09:22:24 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:61618 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755250Ab2EHNWV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2012 09:22:21 -0400
Date: Tue, 8 May 2012 06:22:14 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: joseph daniel <josephdanielwalter@gmail.com>
Cc: Felipe Balbi <balbi@ti.com>, linux-usb@vger.kernel.org,
        linux-omap@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: usb: Warnings with the make randconfig && make
Message-ID: <20120508132214.GA5569@kroah.com>
References: <CAFDqYy3tyDBLPFmGOSj_y92Tagsta21T=yLhkCft7GVj9a53Sg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAFDqYy3tyDBLPFmGOSj_y92Tagsta21T=yLhkCft7GVj9a53Sg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 08, 2012 at 04:19:46PM +0600, joseph daniel wrote:
> Hi all,
> 
> I am getting the following warnings while compiling the 3.4-rc6 kernel
> with the .config attached.
> 
> warning: (MOUSE_APPLETOUCH && MOUSE_BCM5974 && MOUSE_SYNAPTICS_USB &&
> JOYSTICK_XPAD && TABLET_USB_ACECAD && TABLET_USB_AIPTEK &&
> TABLET_USB_HANWANG && TABLET_USB_KBTAB && TABLET_USB_WACOM &&
> TOUCHSCREEN_USB_COMPOSITE && INPUT_ATI_REMOTE2 && INPUT_KEYSPAN_REMOTE
> && INPUT_POWERMATE && INPUT_YEALINK && INPUT_CM109 && RC_ATI_REMOTE &&
> IR_IMON && IR_MCEUSB && IR_REDRAT3 && IR_STREAMZAP && DRM_USB) selects
> USB which has unmet direct dependencies (USB_SUPPORT &&
> USB_ARCH_HAS_HCD)

This is a known problem, patches gladly accepted to try to resolve it
(hint, it's due to DRM_USB)

good luck,

greg k-h
