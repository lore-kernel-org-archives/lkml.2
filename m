Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753224Ab2KIMGZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Nov 2012 07:06:25 -0500
Received: from mail-pb0-f46.google.com ([209.85.160.46]:56893 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753099Ab2KIMGX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Nov 2012 07:06:23 -0500
MIME-Version: 1.0
In-Reply-To: <20121105232218.GA8284@atomide.com>
References: <CACxGe6vu8ek7-K-yDDMXyg9x-oKiFt_cSz+Pz-yZf5U5vwe=0g@mail.gmail.com>
 <6AE080B68D46FC4BA2D2769E68D765B708174B7D@039-SN2MPN1-023.039d.mgd.msft.net> <20121105232218.GA8284@atomide.com>
From: Grant Likely <grant.likely@secretlab.ca>
Date: Fri, 9 Nov 2012 12:06:02 +0000
X-Google-Sender-Auth: GZPmfxJpL-KOmsrjsO_1uZo6_Sk
Message-ID: <CACxGe6s1ksem-6=fxVMeCoGw=vLN8n_j1CmfNJMdPS0e3fUxWw@mail.gmail.com>
Subject: Re: [RFC] Device Tree Overlays Proposal (Was Re: capebus moving
 omap_devices to mach-omap2)
To: Tony Lindgren <tony@atomide.com>
Cc: Tabi Timur-B04825 <B04825@freescale.com>,
        Pantelis Antoniou <panto@antoniou-consulting.com>,
        Rob Herring <robherring2@gmail.com>,
        Deepak Saxena <dsaxena@linaro.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Wood Scott-B07421 <B07421@freescale.com>,
        Kevin Hilman <khilman@ti.com>, Matt Porter <mporter@ti.com>,
        Koen Kooi <koen@dominion.thruhere.net>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Felipe Balbi <balbi@ti.com>, Russ Dill <Russ.Dill@ti.com>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 5, 2012 at 11:22 PM, Tony Lindgren <tony@atomide.com> wrote:
> Hi,
>
> * Tabi Timur-B04825 <B04825@freescale.com> [121105 13:42]:
>> On Mon, Nov 5, 2012 at 2:40 PM, Grant Likely <grant.likely@secretlab.ca> wrote:
>>
>> > Jane is building custom BeagleBone expansion boards called 'capes'. She
>> > can boot the system with a stock BeagleBoard device tree, but additional
>> > data is needed before a cape can be used. She could replace the FDT file
>> > used by U-Boot with one that contains the extra data, but she uses the
>> > same Linux system image regardless of the cape, and it is inconvenient
>> > to have to select a different device tree at boot time depending on the
>> > cape.
>>
>> What's wrong with having the boot loader detect the presence of the
>> Cape and update the device tree accordingly?  We do this all the time
>> in U-Boot.  Doing stuff like reading EEPROMs and testing for the
>> presence of hardware is easier in U-Boot than in Linux.
>>
>> For configurations that can be determined by the boot loader, I'm not
>> sure overlays are practical.
>
> I guess the beaglebone capes could be stackable and hotpluggable if
> handled carefully enough.

And even if it can't on the beaglebone, it will happen somewhere else.
I don't want to exclude that use-case just because nobody thought
about it.

g.
