Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756375Ab1KPQgR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Nov 2011 11:36:17 -0500
Received: from perches-mx.perches.com ([206.117.179.246]:44526 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755472Ab1KPQgQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Nov 2011 11:36:16 -0500
Message-ID: <1321461375.16820.7.camel@Joe-Laptop>
Subject: Re: [uclinux-dist-devel] [PATCH] MAINTAINERS: update maintainers
 for blackfin arch and drivers.
From: Joe Perches <joe@perches.com>
To: Mike Frysinger <vapier@gentoo.org>
Cc: uclinux-dist-devel@blackfin.uclinux.org, Sonic Zhang <sonic.adi@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>
Date: Wed, 16 Nov 2011 08:36:15 -0800
In-Reply-To: <201111161020.53989.vapier@gentoo.org>
References: <1321429708-13862-1-git-send-email-sonic.adi@gmail.com>
	 <1321449126.16478.2.camel@Joe-Laptop>
	 <201111161020.53989.vapier@gentoo.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.1- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-11-16 at 10:20 -0500, Mike Frysinger wrote:
> On Wednesday 16 November 2011 08:12:06 Joe Perches wrote:
> > On Wed, 2011-11-16 at 15:48 +0800, Sonic Zhang wrote:
> > > --- a/MAINTAINERS
> > > +++ b/MAINTAINERS
> > > 
> > >  BLACKFIN ARCHITECTURE
> > > +M:	Bob Liu <lliubbo@kernel.org>
> > >  M:	Mike Frysinger <vapier@gentoo.org>
> > >  L:	uclinux-dist-devel@blackfin.uclinux.org
> > >  W:	http://blackfin.uclinux.org
> > > 
> > >  BLACKFIN RTC DRIVER
> > > -M:	Mike Frysinger <vapier.adi@gmail.com>
> > >  L:	uclinux-dist-devel@blackfin.uclinux.org
> > >  W:	http://blackfin.uclinux.org
> > >  S:	Supported
> > >  F:	drivers/rtc/rtc-bfin.c
> > >  
> > >  BLACKFIN SDH DRIVER
> > > -M:	Cliff Cai <cliff.cai@analog.com>
> > >  L:	uclinux-dist-devel@blackfin.uclinux.org
> > >  W:	http://blackfin.uclinux.org
> > >  S:	Supported
> > > 
> > >  BLACKFIN WATCHDOG DRIVER
> > > -M:	Mike Frysinger <vapier.adi@gmail.com>
> > >  L:	uclinux-dist-devel@blackfin.uclinux.org
> > >  W:	http://blackfin.uclinux.org
> > >  S:	Supported
> > 
> > Drivers or arches without specific people to maintain
> > them really should not have "S: Supported".
> > These should really be "S: Orphan".
> 
> all the drivers are still maintained.  use the L: option to find the 
> maintainer.

I believe I know how the MAINTAINERS
entries work.

>From MAINTAINERS:
	M: Mail patches to: FullName <address@domain>
	L: Mailing list that is relevant to this area

Mailing lists aren't maintainers.

Maybe Analog Devices should create
an email address alias like
linux-devel@analog.com

btw, from blackfin.uclinux.org:

-----------------------
We are moving the open source help forums for u-boot, GNU Toolchain and
Linux for Blackfin to the Analog Devices' EngineerZone since Oct.24,
2011.

These old forums will turn to readonly after Nov.1st, 2011.  Please only
ask new questions in the new Engineer Zone communities after the
launching.
---------------------

So maybe the support links should be:
http://ez.analog.com/community/dsp/open-source/linux-blackfin


