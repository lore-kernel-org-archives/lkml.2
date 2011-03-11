Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754042Ab1CKUbD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Mar 2011 15:31:03 -0500
Received: from kroah.org ([198.145.64.141]:37724 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752476Ab1CKUbA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Mar 2011 15:31:00 -0500
Date: Fri, 11 Mar 2011 12:30:32 -0800
From: Greg KH <greg@kroah.com>
To: Nikolai Kondrashov <spbnick@gmail.com>
Cc: Matthew Garrett <mjg@redhat.com>, Randy Dunlap <rdunlap@xenotime.net>,
        linux-kernel@vger.kernel.org, platform-driver-x86@vger.kernel.org
Subject: Re: [PATCH] Platform: add Samsung Laptop platform driver
Message-ID: <20110311203032.GA14384@kroah.com>
References: <20110310171940.GA24972@kroah.com>
 <4D790A20.3050105@gmail.com>
 <20110310180959.GA26927@kroah.com>
 <4D793D05.3070908@gmail.com>
 <20110310211519.GA11862@kroah.com>
 <4D79CB47.2030405@gmail.com>
 <20110311170313.GA10202@kroah.com>
 <4D7A72E3.1050407@gmail.com>
 <20110311193433.GB14204@kroah.com>
 <4D7A8419.6080107@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D7A8419.6080107@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 11, 2011 at 10:20:41PM +0200, Nikolai Kondrashov wrote:
> On 03/11/2011 09:34 PM, Greg KH wrote:
> >Ok, this shows you are not loading the driver I sent to you, this is the
> >"original" one I sent, which will fail for your machine.
> Sorry, I didn't know the old version was still there.
> For some reason until I removed the staging samsung-laptop from the
> Makefile, the new one didn't get installed.
> 
> >You need to build and install the one I sent you.
> Done. So far tested on n230 only.
> 
> It fails to insert without "force" with the same message. With force it
> installs, but doesn't seem to work, at least for brightness buttons.

The brightness button hookup is in userspace, and odds are that's not
working right, you need newer gnome to handle that.

But, when you insert this with "debug=1" does the screen turn off and
then on?

You can also go into the /sys/class/backlight/samsung/ directory and
mess with the backlight values in the files to see if it gets brighter
and dimmer.  If that works, then the driver is working properly.

I'll work on getting the "force" thing to work properly, as I think I'll
just enable this for all Samsung laptops as Matthew recommends.

thanks,

greg k-h
