Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754364Ab0JTQpf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Oct 2010 12:45:35 -0400
Received: from zone0.gcu-squad.org ([212.85.147.21]:34723 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754300Ab0JTQpd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Oct 2010 12:45:33 -0400
Date: Wed, 20 Oct 2010 18:45:15 +0200
From: Jean Delvare <khali@linux-fr.org>
To: Joe Perches <joe@perches.com>
Cc: Guenter Roeck <guenter.roeck@ericsson.com>,
        Hans de Goede <j.w.r.degoede@hhs.nl>,
        Alistair John Strachan <alistair@devzero.co.uk>,
        Henrik Rydberg <rydberg@euromail.se>,
        "Mark M. Hoffman" <mhoffman@lightlink.com>,
        Luca Tettamanti <kronos.it@gmail.com>,
        Fenghua Yu <fenghua.yu@intel.com>, Juerg Haefliger <juergh@gmail.com>,
        Eric Piel <eric.piel@tremplin-utc.net>,
        Jim Cromie <jim.cromie@gmail.com>,
        Roger Lucas <vt8231@hiddenengine.co.uk>,
        "lm-sensors@lm-sensors.org" <lm-sensors@lm-sensors.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] drivers/hwmon: Use pr_fmt and pr_<level>
Message-ID: <20101020184515.38512719@endymion.delvare>
In-Reply-To: <1287590890.1813.166.camel@Joe-Laptop>
References: <1287530020.10409.594.camel@Joe-Laptop>
	<20101020032938.GA20095@ericsson.com>
	<1287545658.10409.606.camel@Joe-Laptop>
	<20101020035346.GA20178@ericsson.com>
	<1287547662.10409.618.camel@Joe-Laptop>
	<20101020093438.07b129c8@endymion.delvare>
	<20101020144608.GA21937@ericsson.com>
	<1287590890.1813.166.camel@Joe-Laptop>
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.20.1; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Joe,

On Wed, 20 Oct 2010 09:08:10 -0700, Joe Perches wrote:
> On Wed, 2010-10-20 at 07:46 -0700, Guenter Roeck wrote:
> > > * That being said, now that the hwmon subsystem maintainer is a shared
> > >   duty between Guenter and myself, there's no single place where we can
> > >   keep a patch touching many drivers and ensure it doesn't conflict
> > >   with the changes in the other tree. But I would think   this is
> > >   something for Gunter and myself to sort out, not patch contributors.
> 
> Perhaps allow both maintainers read/write access to hwmon-next?

Guenter and myself are collaborating on the hwmon tree since a
relatively recent date. We still have to find the best method. For now
we have separate trees because it seemed easier that way, but we may
change our minds later.

> > > I currently have pending patches to the following hwmon drivers in my
> > > tree: adt7475, ams, asc7621, hdaps, it87, k8temp, lm75, lm85, lm90,
> > > pcf8591, s3c-hwmon, w83795. Two of these are affected by Joe's
> > > patch(es). Guenter, what about you?
> >
> > coretemp, pkgtemp, via-cputemp, ltc4261 (new), lis3, hp_accel
> 
> I did these against next which includes 'hwmon-staging/hwmon-next'.
> 
> Shouldn't these patches apply without modification or do I need
> to do something else?

If you based your patches on linux-next then you're all set. I was
asking Guenter about his affected drivers only to decide who, of him and
me, should take which patch.

-- 
Jean Delvare
