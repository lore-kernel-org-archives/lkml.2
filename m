Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757078Ab2HYDcH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Aug 2012 23:32:07 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:38456 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754690Ab2HYDcE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Aug 2012 23:32:04 -0400
Message-ID: <50384732.9060304@nvidia.com>
Date: Fri, 24 Aug 2012 21:32:02 -0600
From: Stephen Warren <swarren@nvidia.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120714 Thunderbird/14.0
MIME-Version: 1.0
To: Tony Prisk <linux@prisktech.co.nz>
CC: vt8500-wm8505-linux-kernel@googlegroups.com,
        Russell King <linux@arm.linux.org.uk>,
        Alessandro Zummo <a.zummo@towertech.it>,
        Alan Cox <alan@linux.intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Florian Tobias Schandinat <FlorianSchandinat@gmx.de>,
        Arnd Bergmann <arnd@arndb.de>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>, Rob Landley <rob@landley.net>,
        Linus Walleij <linus.walleij@stericsson.com>,
        Mike Turquette <mturquette@ti.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-fbdev@vger.kernel.org, linux-usb@vger.kernel.org,
        linux-serial@vger.kernel.org, rtc-linux@googlegroups.com,
        devicetree-discuss@lists.ozlabs.org
Subject: Re: [PATCHv4 0/9] *** ARM: Update arch-vt8500 to Devicetree ***
References: <1345707346-9035-1-git-send-email-linux@prisktech.co.nz>
In-Reply-To: <1345707346-9035-1-git-send-email-linux@prisktech.co.nz>
X-Enigmail-Version: 1.5a1pre
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/23/2012 01:35 AM, Tony Prisk wrote:
> This patchset updates arch-vt8500 to devicetree and removes all the old-style
> code. Support for WM8650 has also been added.
> 
> Example dts/dtsi files are given for the three currently supported models.
> 
> Major changes:
> 
> GPIO code has been converted to a platform_device and rewritten as WM8505
> support was broken. Add support for WM8650 gpio controller.
> 
> UHCI support was missing. Added this as a generic non-pci uhci controller as
> it doesn't require anything special. Should be usable by any system that doesn't
> have special requirements to get the UHCI controller working.
> 
> Framebuffer code patched to support WM8650. The bindings for this are of concern
> but there doesn't seem to be a formalized binding yet. This patch is based off
> Sascha Hauer's current patch on the dri-devel mailing list and should be easily
> patched out when its finalized.
> 
> Patchset based on Arnd's arm-soc/for-next branch.

I believe all the issues I pointed out are fixed in this series. I'm not
sure I reviewed it in enough detail to ack it, but I'm fine with what I saw.
