Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934793Ab0GOVKC (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jul 2010 17:10:02 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:34704 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934660Ab0GOVKB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jul 2010 17:10:01 -0400
Date: Thu, 15 Jul 2010 22:09:36 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Greg KH <gregkh@suse.de>
Cc: Conke Hu <conke.hu@gmail.com>, CoffBeta <coffbeta@gmail.com>,
        David Brownell <dbrownell@users.sourceforge.net>,
        inux kernel <linux-kernel@vger.kernel.org>,
        ext-jani.1.nikula@nokia.com,
        Uwe Kleine-K?nig <u.kleine-koenig@pengutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: tq 2440
Message-ID: <20100715210936.GB6773@n2100.arm.linux.org.uk>
References: <AANLkTimyBHliUa62qmfja_ke6YTTysiVAtJcZfi8l2gG@mail.gmail.com> <AANLkTil8GE1OguyAfp3XgfJvEmH98yNrlvGAx684a-qL@mail.gmail.com> <20100715163526.GJ29322@n2100.arm.linux.org.uk> <20100715165141.GA21272@suse.de> <20100715171029.GK29322@n2100.arm.linux.org.uk> <20100715172218.GA22197@suse.de> <20100715173322.GL29322@n2100.arm.linux.org.uk> <20100715205153.GC24463@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100715205153.GC24463@suse.de>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 15, 2010 at 01:51:53PM -0700, Greg KH wrote:
> On Thu, Jul 15, 2010 at 06:33:22PM +0100, Russell King - ARM Linux wrote:
> > Another way to avoid the other complaints is to remove
> > the unregistration in platform_register_devices().
> 
> No, because you could have created a platform device with a call to
> platform_device_alloc() and then called platform_device_register() and
> then later, platform_device_unregister(), right?

No.  Sorry, platform_register_devices should've been platform_add_devices().
Please look at that function.

It's used to register an array of static platform devices from architecture
code, as I've said in this thread once already.
