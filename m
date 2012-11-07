Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754239Ab2KGWgB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Nov 2012 17:36:01 -0500
Received: from mail-pa0-f46.google.com ([209.85.220.46]:57322 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753515Ab2KGWf7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Nov 2012 17:35:59 -0500
Message-ID: <509AE247.3000404@gmail.com>
Date: Thu, 08 Nov 2012 09:35:51 +1100
From: Ryan Mallon <rmallon@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121011 Thunderbird/16.0.1
MIME-Version: 1.0
To: Tabi Timur-B04825 <B04825@freescale.com>
CC: Grant Likely <grant.likely@secretlab.ca>,
        Pantelis Antoniou <panto@antoniou-consulting.com>,
        Rob Herring <robherring2@gmail.com>,
        Deepak Saxena <dsaxena@linaro.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Wood Scott-B07421 <B07421@freescale.com>,
        Tony Lindgren <tony@atomide.com>, Kevin Hilman <khilman@ti.com>,
        Matt Porter <mporter@ti.com>, Koen Kooi <koen@dominion.thruhere.net>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Felipe Balbi <balbi@ti.com>, Russ Dill <Russ.Dill@ti.com>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>
Subject: Re: [RFC] Device Tree Overlays Proposal (Was Re: capebus moving omap_devices
 to mach-omap2)
References: <CACxGe6vu8ek7-K-yDDMXyg9x-oKiFt_cSz+Pz-yZf5U5vwe=0g@mail.gmail.com> <6AE080B68D46FC4BA2D2769E68D765B708174B7D@039-SN2MPN1-023.039d.mgd.msft.net>
In-Reply-To: <6AE080B68D46FC4BA2D2769E68D765B708174B7D@039-SN2MPN1-023.039d.mgd.msft.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/11/12 08:40, Tabi Timur-B04825 wrote:
> On Mon, Nov 5, 2012 at 2:40 PM, Grant Likely <grant.likely@secretlab.ca> wrote:
> 
>> Jane is building custom BeagleBone expansion boards called 'capes'. She
>> can boot the system with a stock BeagleBoard device tree, but additional
>> data is needed before a cape can be used. She could replace the FDT file
>> used by U-Boot with one that contains the extra data, but she uses the
>> same Linux system image regardless of the cape, and it is inconvenient
>> to have to select a different device tree at boot time depending on the
>> cape.
> 
> What's wrong with having the boot loader detect the presence of the
> Cape and update the device tree accordingly?  We do this all the time
> in U-Boot.  Doing stuff like reading EEPROMs and testing for the
> presence of hardware is easier in U-Boot than in Linux.

This is probably okay for some hardware, but doesn't work in the general
case. Not all hardware is detectable, for example a cape which just adds
a set of LEDs for GPIO pins. Also, some hardware might not easily be
detectable without adding additional complexity to the boot loader.

~Ryan

