Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932089Ab1CMQRj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Mar 2011 12:17:39 -0400
Received: from kroah.org ([198.145.64.141]:41502 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754784Ab1CMQRZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Mar 2011 12:17:25 -0400
Date: Sun, 13 Mar 2011 09:18:23 -0700
From: Greg KH <greg@kroah.com>
To: Nikolai Kondrashov <spbnick@gmail.com>
Cc: Richard =?iso-8859-1?Q?Sch=FCtz?= <r.schtz@t-online.de>,
        Matthew Garrett <mjg@redhat.com>, Randy Dunlap <rdunlap@xenotime.net>,
        linux-kernel@vger.kernel.org, platform-driver-x86@vger.kernel.org
Subject: Re: [PATCH] Platform: add Samsung Laptop platform driver
Message-ID: <20110313161823.GD10718@kroah.com>
References: <20110310211519.GA11862@kroah.com>
 <4D79CB47.2030405@gmail.com>
 <20110311170313.GA10202@kroah.com>
 <4D7A72E3.1050407@gmail.com>
 <20110311193433.GB14204@kroah.com>
 <4D7A8419.6080107@gmail.com>
 <20110311203032.GA14384@kroah.com>
 <4D7C9668.3000902@gmail.com>
 <4D7CA2A8.4010700@t-online.de>
 <4D7CC048.805@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <4D7CC048.805@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Mar 13, 2011 at 03:02:00PM +0200, Nikolai Kondrashov wrote:
> On 03/13/2011 12:55 PM, Richard Schütz wrote:
> >That sounds like the driver is interfering with the ACPI video driver.
> >Add "acpi_backlight=vendor" to your kernel boot parameters and try again.
> Thank you, this helped :)
> 
> Greg, is it OK that both 0 and 1 backlight values have the same effect on
> brightness?

I really don't know, sorry.  Try messing with the actual_brightness file
instead, that's the one to use.

thanks,

greg k-h
