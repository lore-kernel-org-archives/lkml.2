Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933491Ab0FCBYX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jun 2010 21:24:23 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:46039 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932756Ab0FCBYW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jun 2010 21:24:22 -0400
Date: Wed, 2 Jun 2010 18:22:01 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Marcelo Roberto Jimenez <mroberto@cetuc.puc-rio.br>,
       Alessandro Zummo <a.zummo@towertech.it>, linux@arm.linux.org.uk,
       jaswinderrajput@gmail.com, rtc-linux@googlegroups.com,
       mad_soft@inbox.ru, linux-pcmcia@lists.infradead.org,
       linux-kernel@vger.kernel.org,
       Dominik Brodowski <linux@dominikbrodowski.net>,
       Wolfram Sang <w.sang@pengutronix.de>, kristoffer.ericson@gmail.com,
       Russell King <rmk+kernel@arm.linux.org.uk>, rpjday@crashcourse.ca,
       linux-arm-kernel@lists.infradead.org
Subject: Re: Pull request for nanoengine
Message-Id: <20100602182201.4fcb3417.randy.dunlap@oracle.com>
In-Reply-To: <20100602163844.509e9953.akpm@linux-foundation.org>
References: <AANLkTilh4NtHS5p3tWbMtIU9MBBC-Md13Aw9_RdL3Ogp@mail.gmail.com>
	<20100602163844.509e9953.akpm@linux-foundation.org>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Auth-Type: Internal IP
X-Source-IP: acsinet15.oracle.com [141.146.126.227]
X-CT-RefId: str=0001.0A090207.4C0703CA.0004:SCFMA922111,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2 Jun 2010 16:38:44 -0700 Andrew Morton wrote:

> On Wed, 2 Jun 2010 20:19:01 -0300
> Marcelo Roberto Jimenez <mroberto@cetuc.puc-rio.br> wrote:
> 
> > The following is a compilation of all the patches I have done for the
> > nanoengine. Some of these are also valid for SA11xx based machines
> > like, e.g, sharp Zaurus.
> 
> Which other kernel developer were you hoping would merge this tree?
> 
> >  arch/arm/configs/nanoengine_defconfig          | 1396 ++++++++++++++++++++++++
> >  arch/arm/mach-sa1100/Kconfig                   |    8 +
> >  arch/arm/mach-sa1100/Makefile                  |    2 +
> >  arch/arm/mach-sa1100/cpu-sa1100.c              |   56 +-
> >  arch/arm/mach-sa1100/cpu-sa1110.c              |   51 +-
> >  arch/arm/mach-sa1100/include/mach/nanoengine.h |   30 +
> >  arch/arm/mach-sa1100/nanoengine.c              |  115 ++
> >  drivers/pcmcia/Makefile                        |    3 +-
> >  drivers/pcmcia/sa1100_generic.c                |    3 +
> >  drivers/pcmcia/sa1100_generic.h                |    1 +
> >  drivers/pcmcia/sa1100_nanoengine.c             |  219 ++++
> >  drivers/pcmcia/soc_common.c                    |  129 ++-
> >  drivers/rtc/rtc-sa1100.c                       |  153 ++-
> 
> I can only think it must have been Russell.
> 
> I've rather lost track of what's happening with ARM subtrees.  I
> _think_ it's now the case the relevant maintainers are putting their
> trees into linux-next directly and are asking Linus to pull them
> directly.  But maybe that's a misconception.
> 
> Can someone please explain the current state of play?


Check this from about 2 hours before your question:
  http://lkml.org/lkml/2010/6/2/472  (Linus)


---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
