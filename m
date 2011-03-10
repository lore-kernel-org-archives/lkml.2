Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751329Ab1CJVQA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Mar 2011 16:16:00 -0500
Received: from kroah.org ([198.145.64.141]:39498 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750819Ab1CJVP6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Mar 2011 16:15:58 -0500
Date: Thu, 10 Mar 2011 13:15:19 -0800
From: Greg KH <greg@kroah.com>
To: Nikolai Kondrashov <spbnick@gmail.com>
Cc: Matthew Garrett <mjg@redhat.com>, Randy Dunlap <rdunlap@xenotime.net>,
        linux-kernel@vger.kernel.org, platform-driver-x86@vger.kernel.org
Subject: Re: [PATCH] Platform: add Samsung Laptop platform driver
Message-ID: <20110310211519.GA11862@kroah.com>
References: <20110225210334.GB16860@kroah.com>
 <4D6823DD.6040809@gmail.com>
 <20110225225055.GA5931@kroah.com>
 <4D787714.6060405@gmail.com>
 <20110310170143.GA24559@kroah.com>
 <AANLkTinyqJx76=nzepa9fe5VDzqiXRGCQ=E1SsKm2npE@mail.gmail.com>
 <20110310171940.GA24972@kroah.com>
 <4D790A20.3050105@gmail.com>
 <20110310180959.GA26927@kroah.com>
 <4D793D05.3070908@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D793D05.3070908@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 10, 2011 at 11:05:09PM +0200, Nikolai Kondrashov wrote:
> On 03/10/2011 08:09 PM, Greg KH wrote:
> >Great, here's a new version of the samsung-laptop.c file, can you
> >replace it whereever you were building the previous one, rebuild it and
> >test it for this machine to see if it works?
> This is really strange.
> 
> It's all the same. I tried the new samsung-laptop.c on n230 and the previous
> version on n210 - the results are the same as before.
> 
> Could it be that samsung-laptop has some dependencies unspecified?
> 
> I'm using the stock 2.6.32 kernel configuration on 2.6.37 after running make
> menuconfig. I can' send it to you, if you wish.

Wierd.

Are you sure the driver is loaded?

What happens if you do:
	rmmod samsung-laptop
	dmesg -c
	modprobe samsung-laptop debug=1

can you send me the output of 'dmesg' after doing the above as root?

thanks,

greg k-h
