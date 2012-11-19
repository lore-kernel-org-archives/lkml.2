Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754760Ab2KSU2G (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Nov 2012 15:28:06 -0500
Received: from mail-pa0-f46.google.com ([209.85.220.46]:53644 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754342Ab2KSU2E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Nov 2012 15:28:04 -0500
Date: Mon, 19 Nov 2012 12:28:00 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Bill Pemberton <wfp5p@virginia.edu>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 000/493] remove CONFIG_HOTPLUG as an option
Message-ID: <20121119202800.GA9083@kroah.com>
References: <1353112043-11800-1-git-send-email-wfp5p@virginia.edu>
 <20121119195555.GA21922@core.coreip.homeip.net>
 <20121119200149.GA31589@kroah.com>
 <2170877.01mKLSMGf6@vostro.rjw.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2170877.01mKLSMGf6@vostro.rjw.lan>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 19, 2012 at 09:27:09PM +0100, Rafael J. Wysocki wrote:
> On Monday, November 19, 2012 12:01:49 PM Greg KH wrote:
> > On Mon, Nov 19, 2012 at 11:55:56AM -0800, Dmitry Torokhov wrote:
> > > On Fri, Nov 16, 2012 at 07:19:10PM -0500, Bill Pemberton wrote:
> > > > CONFIG_HOTPLUG is no longer an optional setting.  In order to remove
> > > > it as on option code paths that check CONFIG_HOTPLUG will removed
> > > > along with the attributes __devexit_p, __devexit, __devinitconst, and
> > > > __devinitdata.
> > > > 
> > > > I'll save the list from the mailbomb of this huge patchset.  The
> > > > patches themselves are going to Greg KH for the driver core tree.
> > > > 
> > > 
> > > _iff_ we are going to do this I'd prefer pushing input pieces through my
> > > tree to limit clashes with other work.
> > 
> > That's fine with me.  I'll ignore any drivers/input/ patches then, is
> > that ok?
> 
> Please do the same for PM/ACPI.

Ok, will do.

> Do I need to pull anything for those patches to compile without problems?

Nope, it's just the removal of a symbol, that for 3.7, is defined away
to be an empty string anyway :)

thanks,

greg k-h
