Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752655Ab1CKTi7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Mar 2011 14:38:59 -0500
Received: from kroah.org ([198.145.64.141]:46968 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752256Ab1CKTi4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Mar 2011 14:38:56 -0500
Date: Fri, 11 Mar 2011 11:34:33 -0800
From: Greg KH <greg@kroah.com>
To: Nikolai Kondrashov <spbnick@gmail.com>
Cc: Matthew Garrett <mjg@redhat.com>, Randy Dunlap <rdunlap@xenotime.net>,
        linux-kernel@vger.kernel.org, platform-driver-x86@vger.kernel.org
Subject: Re: [PATCH] Platform: add Samsung Laptop platform driver
Message-ID: <20110311193433.GB14204@kroah.com>
References: <20110310170143.GA24559@kroah.com>
 <AANLkTinyqJx76=nzepa9fe5VDzqiXRGCQ=E1SsKm2npE@mail.gmail.com>
 <20110310171940.GA24972@kroah.com>
 <4D790A20.3050105@gmail.com>
 <20110310180959.GA26927@kroah.com>
 <4D793D05.3070908@gmail.com>
 <20110310211519.GA11862@kroah.com>
 <4D79CB47.2030405@gmail.com>
 <20110311170313.GA10202@kroah.com>
 <4D7A72E3.1050407@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D7A72E3.1050407@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 11, 2011 at 09:07:15PM +0200, Nikolai Kondrashov wrote:
> On 03/11/2011 07:03 PM, Greg KH wrote:
> >Are you sure this was the driver you just built that I sent you?  Can
> >you send the output of 'modinfo samsung-laptop'?
> Yes, I'm pretty sure. Here is the modinfo output:
> 
> filename: /lib/modules/2.6.37+/kernel/drivers/staging/samsung-laptop/samsung-laptop.ko
> license:        GPL
> description:    Samsung Backlight driver
> author:         Greg Kroah-Hartman <gregkh@suse.de>
> alias:          dmi*:svn*SAMSUNGELECTRONICSCO.,LTD.*:pn*N130*:rn*N130*:
> alias:          dmi*:svn*SAMSUNGELECTRONICSCO.,LTD.*:pn*N128*:rn*N128*:
> depends:        rfkill

Ok, this shows you are not loading the driver I sent to you, this is the
"original" one I sent, which will fail for your machine.

You need to build and install the one I sent you.

thanks,

greg k-h
