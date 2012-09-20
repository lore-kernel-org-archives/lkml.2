Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932487Ab2ITXNs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Sep 2012 19:13:48 -0400
Received: from mail-oa0-f46.google.com ([209.85.219.46]:50084 "EHLO
	mail-oa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932393Ab2ITXNq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Sep 2012 19:13:46 -0400
Message-ID: <505BA326.1030909@gmail.com>
Date: Thu, 20 Sep 2012 18:13:42 -0500
From: Rob Herring <robherring2@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120827 Thunderbird/15.0
MIME-Version: 1.0
To: Tony Prisk <linux@prisktech.co.nz>
CC: vt8500-wm8505-linux-kernel@googlegroups.com,
        Alessandro Zummo <a.zummo@towertech.it>, linux-fbdev@vger.kernel.org,
        Russell King <linux@arm.linux.org.uk>,
        Linus Walleij <linus.walleij@stericsson.com>,
        Florian Tobias Schandinat <FlorianSchandinat@gmx.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        devicetree-discuss@lists.ozlabs.org, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, Rob Herring <rob.herring@calxeda.com>,
        linux-serial@vger.kernel.org, rtc-linux@googlegroups.com,
        Stephen Warren <swarren@nvidia.com>,
        Mike Turquette <mturquette@ti.com>,
        linux-arm-kernel@lists.infradead.org, Alan Cox <alan@linux.intel.com>,
        Olof Johansson <olof@lixom.net>
Subject: Re: [PATCHv4 7/9] arm: vt8500: doc: Add device tree bindings for
 arch-vt8500 devices
References: <1345707346-9035-1-git-send-email-linux@prisktech.co.nz> <1345707346-9035-8-git-send-email-linux@prisktech.co.nz>
In-Reply-To: <1345707346-9035-8-git-send-email-linux@prisktech.co.nz>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/23/2012 02:35 AM, Tony Prisk wrote:
> Bindings for gpio, interrupt controller, power management controller,
> timer, realtime clock, serial uart, ehci and uhci controllers and
> framebuffer controllers used on the arch-vt8500 platform.
> 
> Framebuffer binding also specifies a 'display' node which is required
> for determining the lcd panel data.

Overall, these bindings look okay, but there is some effort to
standardize a binding for displays:

http://comments.gmane.org/gmane.linux.drivers.devicetree/21386

I would like to see that used rather than something custom.

Rob

