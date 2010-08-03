Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932404Ab0HCS1a (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Aug 2010 14:27:30 -0400
Received: from phil.doycomm.com ([66.219.128.249]:46560 "EHLO phil.doycomm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756665Ab0HCS13 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Aug 2010 14:27:29 -0400
Subject: Re: Linux 2.6.35
From: Donald Parsons <dparsons@brightdsl.net>
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
Cc: Randy Dunlap <rdunlap@xenotime.net>, Harald Hoyer <harald.hoyer@gmail.com>,
        Bjorn Helgaas <bjorn.helgaas@hp.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
In-Reply-To: <4C57EE60.2000601@s5r6.in-berlin.de>
References: <1280716262.5125.42.camel@falcon.homelinux.org>
	 <201008012138.39036.bjorn.helgaas@hp.com>
	 <1280722876.5125.83.camel@falcon.homelinux.org>
	 <AANLkTimK8sv5aWfcv_BAmipgVnukR5NJsZQOXYbb2LAH@mail.gmail.com>
	 <1280802701.5836.10.camel@falcon.homelinux.org>
	 <20100802214249.b0fee617.rdunlap@xenotime.net>
	 <4C57EE60.2000601@s5r6.in-berlin.de>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 03 Aug 2010 14:26:46 -0400
Message-ID: <1280860006.26472.11.camel@falcon.homelinux.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 (2.28.3-1.fc12) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-08-03 at 12:24 +0200, Stefan Richter wrote:
> Randy Dunlap wrote:
> > On Mon, 02 Aug 2010 22:31:41 -0400 Donald Parsons wrote:
> >>>>> On Sunday, August 01, 2010 08:31:02 pm Donald Parsons wrote:
> >>>>>> 2.6.35 still fails to boot for me, as first reported here:
> >>>>>>  http://lkml.indiana.edu/hypermail/linux/kernel/1007.3/01144.html
> >>>>>>
> >>>>>> I've manually bisected it down to around May 20 between
> >>>>>>   2.6.34-git4 (boots) and 2.6.34-git5 (boot fails)
> >>>>>> Also -git[23] boot, and -git8, -rc[126], rc6-git[136] all fail.
> [...]
> 
> To recap:  Donald uses ata_generic,pata_acpi,pata_jmicron,ahci for Asus
> P5B Deluxe which has
> 
> 00:1f.2 SATA controller: Intel Corporation 82801HB (ICH8) SATA AHCI
> Controller (rev 02)
> 03:00.0 SATA controller: JMicron Technologies, Inc. JMicron 20360/20363
> AHCI Controller (rev 02)
> 03:00.1 IDE interface: JMicron Technologies, Inc. JMicron 20360/20363
> AHCI Controller (rev 02)
> 
> On which interface is the disk with the root filesystem?

All drives hook to ICH8R, two Seagate SATA hard drives, and
a SATA CD/DVD drive.  JMicron has no drives so far.

Don


