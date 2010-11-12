Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755328Ab0KLHh2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Nov 2010 02:37:28 -0500
Received: from mga09.intel.com ([134.134.136.24]:53465 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753161Ab0KLHh1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Nov 2010 02:37:27 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.59,186,1288594800"; 
   d="scan'208";a="676791402"
Subject: Re: regression since 2.6.36: backlight in sony-laptop not working
From: Zhang Rui <rui.zhang@intel.com>
To: Norbert Preining <preining@logic.at>
Cc: Matthew Garrett <mjg59@srcf.ucam.org>, Mattia Dongili <malattia@linux.it>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        ACPI Devel Mailing List <linux-acpi@vger.kernel.org>
In-Reply-To: <20101112035027.GD26742@gamma.logic.tuwien.ac.at>
References: <20101104142915.GC7650@gamma.logic.tuwien.ac.at>
	 <20101110035833.GB3029@kamineko.org>
	 <20101111235000.GA6651@gamma.logic.tuwien.ac.at>
	 <20101112034423.GA7407@srcf.ucam.org>
	 <20101112035027.GD26742@gamma.logic.tuwien.ac.at>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 12 Nov 2010 15:38:39 +0800
Message-ID: <1289547519.8148.1795.camel@rui>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-11-12 at 11:50 +0800, Norbert Preining wrote:
> On Fr, 12 Nov 2010, Matthew Garrett wrote:
> > > Seems so that the sys files have changed to new locations:
> > > /sys/devices/virtual/backlight/acpi_video0/brightness
> > > 
> > > (mind the additional "virtual")
> > > as well as thermal zone etc etc.
> > > 
I think the /sys/class/thermal/ and /sys/class/backlight/acpi_video0
still exists, right?

we make ACPI video procfs I/F depend on CONFIG_ACPI_PROCFS, which is
cleared by default, in 2.6.36, and removed this I/F in 2.6.37-rc1.
perhaps the backlight control depends on the procfs I/F?

thanks,
rui

> > > Could that explain the problem?
> > 
> > Only if you have some wonderfully badly written software. What are you 
> > using to control the backlight? Also, I'd note that in this case your 
> > backlight is controlled via ACPI, not sony-laptop.
> 
> Ah right, yes, so probabyl sony-laptopt has nothing to do with it.
> 
> THen the problem is simply that the acpi events are not coming through
> when pressing the respective keys.
> 
> But *that* might be part of the sony-laptop kernel module?
> 
> Best wishes
> 
> Norbert
> ------------------------------------------------------------------------
> Norbert Preining            preining@{jaist.ac.jp, logic.at, debian.org}
> JAIST, Japan                                 TeX Live & Debian Developer
> DSA: 0x09C5B094   fp: 14DF 2E6C 0307 BE6D AD76  A9C0 D2BF 4AA3 09C5 B094
> ------------------------------------------------------------------------
> TREWOFFE (n.)
> A very thick and heavy drift of snow balanced precariously on the
> edge of a door porch waiting for what it judges to be the correct
> moment to fall. From the ancient Greek legend 'The Treewofe of
> Damocles'.
> 			--- Douglas Adams, The Meaning of Liff
> --
> To unsubscribe from this list: send the line "unsubscribe linux-acpi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


