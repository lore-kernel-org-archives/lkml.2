Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751751Ab1CKRDs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Mar 2011 12:03:48 -0500
Received: from kroah.org ([198.145.64.141]:33451 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751072Ab1CKRDq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Mar 2011 12:03:46 -0500
Date: Fri, 11 Mar 2011 09:03:13 -0800
From: Greg KH <greg@kroah.com>
To: Nikolai Kondrashov <spbnick@gmail.com>
Cc: Matthew Garrett <mjg@redhat.com>, Randy Dunlap <rdunlap@xenotime.net>,
        linux-kernel@vger.kernel.org, platform-driver-x86@vger.kernel.org
Subject: Re: [PATCH] Platform: add Samsung Laptop platform driver
Message-ID: <20110311170313.GA10202@kroah.com>
References: <20110225225055.GA5931@kroah.com>
 <4D787714.6060405@gmail.com>
 <20110310170143.GA24559@kroah.com>
 <AANLkTinyqJx76=nzepa9fe5VDzqiXRGCQ=E1SsKm2npE@mail.gmail.com>
 <20110310171940.GA24972@kroah.com>
 <4D790A20.3050105@gmail.com>
 <20110310180959.GA26927@kroah.com>
 <4D793D05.3070908@gmail.com>
 <20110310211519.GA11862@kroah.com>
 <4D79CB47.2030405@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D79CB47.2030405@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 11, 2011 at 09:12:07AM +0200, Nikolai Kondrashov wrote:
> On 03/10/2011 11:15 PM, Greg KH wrote:
> >Are you sure the driver is loaded?
> It doesn't load - it fails on inserting.
> I should've probably reminded you that in my recent messages.
> 
> >What happens if you do:
> >	rmmod samsung-laptop
> >	dmesg -c
> >	modprobe samsung-laptop debug=1
> >
> >can you send me the output of 'dmesg' after doing the above as root?
> Sure:
> 
> nick@merry:~$ dmesg
> nick@merry:~$ sudo modprobe samsung-laptop debug=1
> FATAL: Error inserting samsung_laptop (/lib/modules/2.6.37+/kernel/drivers/staging/samsung-laptop/samsung-laptop.ko):
> No such device
> nick@merry:~$ dmesg
> [  179.689516] samsung_laptop: module is from the staging directory,
> the quality is unknown, you have been warned.
> nick@merry:~$ sudo modprobe samsung-laptop debug=1 force=1
> FATAL: Error inserting samsung_laptop (/lib/modules/2.6.37+/kernel/drivers/staging/samsung-laptop/samsung-laptop.ko):
> Invalid argument
> nick@merry:~$ dmesg
> [  179.689516] samsung_laptop: module is from the staging directory,
> the quality is unknown, you have been warned.
> [  190.474615] samsung_laptop: module is from the staging directory,
> the quality is unknown, you have been warned.
> [  190.479681] This computer does not support SABI

Are you sure this was the driver you just built that I sent you?  Can
you send the output of 'modinfo samsung-laptop'?

thanks,

greg k-h
