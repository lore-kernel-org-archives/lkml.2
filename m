Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759085Ab0JFONS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Oct 2010 10:13:18 -0400
Received: from kroah.org ([198.145.64.141]:54382 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759052Ab0JFONQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Oct 2010 10:13:16 -0400
Date: Wed, 6 Oct 2010 07:04:37 -0700
From: Greg KH <greg@kroah.com>
To: Micki Balanga <micki@n-trig.com>
Cc: Jiri Kosina <jkosina@suse.cz>, "gregkh@suse.de" <gregkh@suse.de>,
        "jim.collar@eqware.net" <jim.collar@eqware.net>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] USB: misc: Add N-trig firmware driver
Message-ID: <20101006140437.GD19470@kroah.com>
References: <6EF693376E00E2458E26FEC229232B128A8D39@Exchange2010-IL.n-trig.com>
 <20101004011949.GA23855@kroah.com>
 <alpine.LRH.2.00.1010041458010.12867@twin.jikos.cz>
 <6EF693376E00E2458E26FEC229232B128AAE23@Exchange2010-IL.n-trig.com>
 <20101005124637.GB2943@kroah.com>
 <6EF693376E00E2458E26FEC229232B128AB242@Exchange2010-IL.n-trig.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6EF693376E00E2458E26FEC229232B128AB242@Exchange2010-IL.n-trig.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 06, 2010 at 04:47:24AM +0000, Micki Balanga wrote:
> > Why does it have to be a driver at all?  Why can't you just use libusb
> > or usbfs to implement this?
> 
> The driver is used for several debug applications we use and libusb or
> usbfs caused us several problem.

What were those problems?  Did you report them so we can get them fixed?

> we also run on several platform. The user space application which
> communicate with the driver is common for several OS. 

Then it would make more sense to use libusb, which works on all
platforms, right?

thanks,

greg k-h
