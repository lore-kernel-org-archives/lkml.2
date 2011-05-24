Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932308Ab1EXNnv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 May 2011 09:43:51 -0400
Received: from out3.smtp.messagingengine.com ([66.111.4.27]:45705 "EHLO
	out3.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756404Ab1EXNnu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 May 2011 09:43:50 -0400
X-Sasl-enc: U06YASW4WTbGhZPpr1o2cyTpMWjoWt65WMUCvcGuUepo 1306244629
Date: Tue, 24 May 2011 06:43:38 -0700
From: Greg KH <greg@kroah.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Subhasish Ghosh <subhasish@mistralsolutions.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        "Nori, Sekhar" <nsekhar@ti.com>, linux-arm-kernel@lists.infradead.org,
        davinci-linux-open-source@linux.davincidsp.com,
        sachi@mistralsolutions.com, Samuel Ortiz <sameo@linux.intel.com>,
        open list <linux-kernel@vger.kernel.org>,
        "Watkins, Melissa" <m-watkins@ti.com>
Subject: Re: [PATCH v4 01/11] mfd: add pruss mfd driver
Message-ID: <20110524134338.GA13491@kroah.com>
References: <1303474109-6212-1-git-send-email-subhasish@mistralsolutions.com>
 <201105231730.06564.arnd@arndb.de>
 <7E10264BABCB4C1788DCD9715461BDE8@subhasishg>
 <201105241440.34854.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201105241440.34854.arnd@arndb.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 24, 2011 at 02:40:34PM +0200, Arnd Bergmann wrote:
> On Tuesday 24 May 2011, Subhasish Ghosh wrote:
> > Would it be a good approach to first get a basic sensible
> > driver into the tree and then work towards improving and
> > adjusting for future compatibilities.
> 
> The main problem with that is that you cannot really change
> user-visible interfaces after the driver is merged. Anything
> regarding sysfs attributes and firmware file contents needs
> to be fixed. You can however still change in-kernel interfaces
> at a later point without problems.
> 
> > That way we can gradually build towards the perfect driver
> > in steps, rather than digressing far too off suddenly.
> > That would be some source of motivation for me too.
> 
> You can definitely add the driver to drivers/staging/pruss/,
> as the rules for staging drivers are different. I think that
> would indeed be helpful at this point. As soon as all
> interfaces have stabilized, you can then move the individual
> parts to their final location.
> 
> Greg maintains the staging drivers, and he can surely point
> you to a document describing what is required for a driver.

There really are only 3 rules:
	- proper license
	- self-contained in a drivers/staging/DRIVER_NAME/ directory
	- must properly build

> Mainly, this includes having a patch that adds a single
> directory with all the driver files under drivers/staging.
> The driver must be able to compile without errors and you need
> a TODO file listing the remaining issues that prevent you
> from having a non-staging driver.

Ah, forgot the TODO on the list of rules, I'll have to add that next
time.

Someone feel free to send me a patch :)

thanks,

greg k-h
