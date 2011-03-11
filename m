Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753267Ab1CKTw5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Mar 2011 14:52:57 -0500
Received: from kroah.org ([198.145.64.141]:33460 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751677Ab1CKTwy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Mar 2011 14:52:54 -0500
Date: Fri, 11 Mar 2011 11:52:21 -0800
From: Greg KH <greg@kroah.com>
To: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: Randy Dunlap <rdunlap@xenotime.net>, linux-kernel@vger.kernel.org,
        platform-driver-x86@vger.kernel.org
Subject: Re: [PATCH] Platform: add Samsung Laptop platform driver
Message-ID: <20110311195221.GA14719@kroah.com>
References: <20110305042431.GA22840@kroah.com>
 <20110311174339.GJ16652@srcf.ucam.org>
 <20110311193512.GC14204@kroah.com>
 <20110311194422.GA20490@srcf.ucam.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110311194422.GA20490@srcf.ucam.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 11, 2011 at 07:44:22PM +0000, Matthew Garrett wrote:
> On Fri, Mar 11, 2011 at 11:35:12AM -0800, Greg KH wrote:
> > On Fri, Mar 11, 2011 at 05:43:39PM +0000, Matthew Garrett wrote:
> > > Applied, thanks.
> > 
> > Great, any pointers to where it was applied?  I think I need to send you
> > a few more 'add a new device id' patches and I want to make sure I get
> > the right version to patch against.
> 
> http://git.kernel.org/?p=linux/kernel/git/mjg59/platform-drivers-x86.git;a=shortlog;h=refs/heads/linux-next 

Thanks.

> - ideally we'd just have it id against all Samsung laptops and check for 
> SABI? Or are there machines where that might break?

I thought all samsung laptops had SABI, but as the other samsung laptop
driver shows, that's not true.

I don't know what happens if we try to check for SABI on those machines.
We are just rooting around in the BIOS rom and reading values,
_hopefully_ that wouldn't break any other machines, but I don't really
know.

I wouldn't mind just doing a DMI match on all Samsung laptops, it would
save me having to constantly send patch updates, so I'll let this be
your call :)

thanks,

greg k-h
