Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759695Ab2IFUCV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Sep 2012 16:02:21 -0400
Received: from ogre.sisk.pl ([193.178.161.156]:40404 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759593Ab2IFUCR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Sep 2012 16:02:17 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: sedat.dilek@gmail.com, Andre Przywara <andre.przywara@amd.com>
Subject: Re: linux-next: Tree for Sept 6 (does not boot on AMD64)
Date: Thu, 6 Sep 2012 22:08:34 +0200
User-Agent: KMail/1.13.6 (Linux/3.6.0-rc3+; KDE/4.6.0; x86_64; ; )
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>, Matthew Garrett <mjg@redhat.com>,
        Linux PM list <linux-pm@vger.kernel.org>,
        Thomas Renninger <trenn@suse.de>
References: <CA+icZUWgPV=RnXGT4hDsk3xDm8iBu8ShvFFrs=t3+3D3=-bP2Q@mail.gmail.com> <CA+icZUUQiPv=iwwC43f6kuU_ikDDKeRC5=QYN4R9OzccmpAEeA@mail.gmail.com>
In-Reply-To: <CA+icZUUQiPv=iwwC43f6kuU_ikDDKeRC5=QYN4R9OzccmpAEeA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Message-Id: <201209062208.34545.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, September 06, 2012, Sedat Dilek wrote:
> On Thu, Sep 6, 2012 at 1:48 PM, Sedat Dilek <sedat.dilek@gmail.com> wrote:
> > On Thu, Sep 6, 2012 at 9:23 AM, Stephen Rothwell <sfr@canb.auug.org.au> wrote:
> >> Hi all,
> >>
> >> Changes since 20120905:
> >>
> >> New tree: arm64
> >>
> >> The powerpc tree gained a build failure for which I reverted 3 commits.
> >>
> >> The net-next tree lost its build failure.
> >>
> >> The trivial tree gained a conflict against the powerpc tree.
> >>
> >> The spi-mb tree gained a build failure so I used the version from
> >> next-20120905.
> >>
> >> The driver-core tree gained a build failure (form an interaction with the
> >> workqueues tree) for which I applied a merge fix patch.
> >>
> >> The tty tree gained a build failure for which I applied a patch.
> >>
> >> The staging tree lost its build failure.
> >>
> >> The arm-soc tree gained a conflict against the usb tree.
> >>
> >> ----------------------------------------------------------------------------
> >>
> >
> > Hi,
> >
> > Unfortunately, today's linux-next does not boot here on Ubuntu/precise AMD64.
> > My yesterday's next-20120905 is fine.
> >
> > I throw out all my additional patches an rebuild again as "-2", but
> > this linux-image does not boot.
> > It's in very early stage.
> > I removed "quiet" etc. from kernel-command-line, but this reveals not much more.
> >
> > From the attached kernel-config.diff:
> > Dunno why the 2nd is disabled now and try to turn off the 1st one in a
> > "-3" build.
> >
> > +CONFIG_X86_ACPI_CPUFREQ_CPB=y
> > -CONFIG_USB_LIBUSUAL=y
> >
> 
> [ CC Rafael (cpufreq sub-maintainer) ]

Well, this is related to the AMD cpufreq patchset I've just added to
linux-next.  I'll drop it for now until the issue is resolved.

> I hacked to turn off CONFIG_X86_ACPI_CPUFREQ_CPB, but this is not the
> root cause.
> Not sure why this setting is default YES, Rafael?
> 
> To switch from upstart to systemd does not help.

Andre, care to have a look at this?

Rafael
