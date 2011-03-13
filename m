Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756113Ab1CMR6F (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Mar 2011 13:58:05 -0400
Received: from kroah.org ([198.145.64.141]:44758 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755980Ab1CMR6E (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Mar 2011 13:58:04 -0400
Date: Sun, 13 Mar 2011 10:58:13 -0700
From: Greg KH <greg@kroah.com>
To: Nikolai Kondrashov <spbnick@gmail.com>
Cc: Richard =?iso-8859-1?Q?Sch=FCtz?= <r.schtz@t-online.de>,
        Matthew Garrett <mjg@redhat.com>, Randy Dunlap <rdunlap@xenotime.net>,
        linux-kernel@vger.kernel.org, platform-driver-x86@vger.kernel.org
Subject: Re: [PATCH] Platform: add Samsung Laptop platform driver
Message-ID: <20110313175813.GA11702@kroah.com>
References: <20110311170313.GA10202@kroah.com>
 <4D7A72E3.1050407@gmail.com>
 <20110311193433.GB14204@kroah.com>
 <4D7A8419.6080107@gmail.com>
 <20110311203032.GA14384@kroah.com>
 <4D7C9668.3000902@gmail.com>
 <4D7CA2A8.4010700@t-online.de>
 <4D7CC048.805@gmail.com>
 <20110313161823.GD10718@kroah.com>
 <4D7D0390.3000108@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D7D0390.3000108@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Mar 13, 2011 at 07:49:04PM +0200, Nikolai Kondrashov wrote:
> On 03/13/2011 06:18 PM, Greg KH wrote:
> >I really don't know, sorry.  Try messing with the actual_brightness file
> >instead, that's the one to use.
> Sure, thank you :)
> 
> Still, what about the wireless on/off button? Is Gnome support required, or
> it should work as is? Because mine doesn't seem to do anything.

It should "just work", as it does on my machine, but I'm running a very
new Gnome, so it might have hooks to look at the rfkill stuff built in.

thanks,

greg k-h
