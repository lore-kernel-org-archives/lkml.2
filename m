Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752512Ab0KYUPv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Nov 2010 15:15:51 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:56074 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751952Ab0KYUPu convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Nov 2010 15:15:50 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: sedat.dilek@gmail.com
Subject: Re: [PATCH 0/13] ACPI / PM: Rework power resources management
Date: Thu, 25 Nov 2010 21:15:01 +0100
User-Agent: KMail/1.13.5 (Linux/2.6.37-rc3+; KDE/4.4.4; x86_64; ; )
Cc: LKML <linux-kernel@vger.kernel.org>
References: <AANLkTimahUpEL3cV6pFhkN8KqrphfVMSOw8xAN2=9jPy@mail.gmail.com> <AANLkTin4r6-No01A_KNr8aNuYpyWTvmuA3LTDRZ5Lag6@mail.gmail.com> <AANLkTimLOeZ=sWLP=nM_vSqR1jPDXtR1Dp2Eor+Xfosf@mail.gmail.com>
In-Reply-To: <AANLkTimLOeZ=sWLP=nM_vSqR1jPDXtR1Dp2Eor+Xfosf@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-Id: <201011252115.02073.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, November 25, 2010, Sedat Dilek wrote:
> On Thu, Nov 25, 2010 at 10:41 AM, Sedat Dilek
> <sedat.dilek@googlemail.com> wrote:
> > On Thu, Nov 25, 2010 at 10:11 AM, Sedat Dilek
> > <sedat.dilek@googlemail.com> wrote:
> >> Hi Rafael,
> >>
> [ ... ]
> >> # grep "error:" build_linux-next_next20101124.dileks.2.log
> >> /home/sd/src/linux-2.6/linux-2.6.37-rc3/debian/build/source_i386_none/drivers/platform/x86/fujitsu-laptop.c:692:
> >> error: implicit declaration of function ‘acpi_bus_get_power’
> [ ... ]
> >
> > Guess this is conflicting with your patch
> > "12-13-ACPI-PM-Drop-acpi_bus_get_power.patch".
> >
> > - Sedat -
> >
> > P.S.: Note to myself, add the following snippet for testing purposes:
> >
> > [ debian/config/i386/none/config.686 ]
> > ...
> > ##
> > ## file: drivers/platform/x86/Kconfig
> > ##
> > # CONFIG_FUJITSU_LAPTOP is not set
> > - EOT -
> >
> 
> Applied on top of linux-next (next-20101125) and running.
> 
>      Tested-by: Sedat Dilek <sedat.dilek@gmail.com>

Great, thanks a lot!

I should have said the patchset is on top of the current Linus' tree.

Rafael
