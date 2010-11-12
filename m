Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754143Ab0KLDub (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Nov 2010 22:50:31 -0500
Received: from mx.logic.tuwien.ac.at ([128.130.175.19]:56621 "EHLO
	mx.logic.tuwien.ac.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753135Ab0KLDua (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Nov 2010 22:50:30 -0500
Date: Fri, 12 Nov 2010 12:50:27 +0900
From: Norbert Preining <preining@logic.at>
To: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: Mattia Dongili <malattia@linux.it>, linux-kernel@vger.kernel.org,
        ACPI Devel Mailing List <linux-acpi@vger.kernel.org>
Subject: Re: regression since 2.6.36: backlight in sony-laptop not working
Message-ID: <20101112035027.GD26742@gamma.logic.tuwien.ac.at>
References: <20101104142915.GC7650@gamma.logic.tuwien.ac.at> <20101110035833.GB3029@kamineko.org> <20101111235000.GA6651@gamma.logic.tuwien.ac.at> <20101112034423.GA7407@srcf.ucam.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101112034423.GA7407@srcf.ucam.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fr, 12 Nov 2010, Matthew Garrett wrote:
> > Seems so that the sys files have changed to new locations:
> > /sys/devices/virtual/backlight/acpi_video0/brightness
> > 
> > (mind the additional "virtual")
> > as well as thermal zone etc etc.
> > 
> > Could that explain the problem?
> 
> Only if you have some wonderfully badly written software. What are you 
> using to control the backlight? Also, I'd note that in this case your 
> backlight is controlled via ACPI, not sony-laptop.

Ah right, yes, so probabyl sony-laptopt has nothing to do with it.

THen the problem is simply that the acpi events are not coming through
when pressing the respective keys.

But *that* might be part of the sony-laptop kernel module?

Best wishes

Norbert
------------------------------------------------------------------------
Norbert Preining            preining@{jaist.ac.jp, logic.at, debian.org}
JAIST, Japan                                 TeX Live & Debian Developer
DSA: 0x09C5B094   fp: 14DF 2E6C 0307 BE6D AD76  A9C0 D2BF 4AA3 09C5 B094
------------------------------------------------------------------------
TREWOFFE (n.)
A very thick and heavy drift of snow balanced precariously on the
edge of a door porch waiting for what it judges to be the correct
moment to fall. From the ancient Greek legend 'The Treewofe of
Damocles'.
			--- Douglas Adams, The Meaning of Liff
