Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756137Ab1CMMvw (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Mar 2011 08:51:52 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:54644 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755357Ab1CMMvu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Mar 2011 08:51:50 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: andy.green@linaro.org
Subject: Re: [RFC PATCH 1/4] PLATFORM: introduce structure to bind async platform data to a dev path name
Date: Sun, 13 Mar 2011 13:51:35 +0100
User-Agent: KMail/1.13.6 (Linux/2.6.38-rc8+; KDE/4.6.0; x86_64; ; )
Cc: Greg KH <greg@kroah.com>, linux-kernel@vger.kernel.org,
        linux-usb@vger.kernel.org, patches@linaro.org
References: <20110312222633.27020.19543.stgit@otae.warmcat.com> <20110313010329.GB20396@kroah.com> <4D7CA900.2070302@linaro.org>
In-Reply-To: <4D7CA900.2070302@linaro.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201103131351.36078.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday, March 13, 2011, Andy Green wrote:
> On 03/13/2011 01:03 AM, Somebody in the thread at some point said:
> 
> >>> Using device paths for this purpose seems to be very fragile to me.  Isn't
> >>> there any better solution?
> >>
> >> Given that this targets board definition files which commonly do the
> >> platform_add_device for the USB bus controller synchronously, and
> >> the bus-connected devices it is aimed at are soldered on to the
> >> board connected to specific bus controllers, the bus paths are
> >> completely deterministic.
> >
> > No they are not.
> >
> > The physical layout is deterministic, but the bus number, and device
> > number, is not.  You are using the bus number here in this path, so that
> > is not going to work, sorry.
> 
> Okay.  This is not a PC we are talking about.
> 
> If the platform / board definition file is registering the USB hosts 
> synchronously at boot time, the driver is composed into the monolithic 
> kernel, there are no PCI busses or whatever on the SoC, the bus indexing 
> is totally deterministic.  This is extremely common in the platform / 
> SoC case and is the case the patchset is targeted at.  Even further, the 
> only time you'd use it is to reach a USB asset that is wired up the same 
> board permanently as well.
> 
> Anyway this seems moot by now.

However, if you add a new infrastructure like this, it should be at least
usable on systems that you description doesn't apply to.

Thanks,
Rafael
