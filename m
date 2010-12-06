Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753399Ab0LFBdq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Dec 2010 20:33:46 -0500
Received: from mga11.intel.com ([192.55.52.93]:29473 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752845Ab0LFBdp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Dec 2010 20:33:45 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.59,303,1288594800"; 
   d="scan'208";a="864794499"
Subject: Re: [Regression] 2.6.37-rc1: Lenovo T61 mute button does not work
From: Lin Ming <ming.m.lin@intel.com>
To: Lukas Hejtmanek <xhejtman@ics.muni.cz>
Cc: "Moore, Robert" <robert.moore@intel.com>,
        "Brown, Len" <len.brown@intel.com>,
        Calvin Walton <calvin.walton@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
In-Reply-To: <20101203141358.GA6936@ics.muni.cz>
References: <20101130185303.GI10354@ics.muni.cz>
	 <1291172324.14274.33.camel@nayuki>  <20101203141358.GA6936@ics.muni.cz>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 06 Dec 2010 09:37:04 +0800
Message-ID: <1291599424.3688.0.camel@minggr.sh.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-12-03 at 22:13 +0800, Lukas Hejtmanek wrote:
> Hi,
> 
> On Tue, Nov 30, 2010 at 09:58:44PM -0500, Calvin Walton wrote:
> > > in 2.6.36, mute button worked as expected on my ThinkPad T61 - it toggled
> > > mute with mixer applet notification. In 2.6.37-rc1, it only mutes without any
> > > event to any mixer applet.
> 
> [...]
> 
> > By default on this series of laptops, Linux runs with the ACPI
> > _OSI(Linux) exported - when the bios of this laptop model sees that it's
> > running on Linux, it disables the hardware mute functionality and the
> > mute button acts as a standard keyboard key.
> > 
> > Search your dmesg for lines containing '_OSI(Linux)' - it should say
> > that a BIOS query was honoured. Make sure you do not have 'acpi_osi="!
> > Linux"' on your kernel command line.
> 
> The breaking commit is this one: b0ed7a915abac309fcb5a51bccd3782e3daa7417
> 
> This changes 
> [    0.200241] ACPI: BIOS _OSI(Linux) query honored via DMI
> to
> [    0.200241] ACPI: BIOS _OSI(Linux) query honored via cmdline
> 
> which apparently does not work with Lenovo T61.

I'm looking at this regression.

Thanks,
Lin Ming


