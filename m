Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932484Ab1EZOPz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 May 2011 10:15:55 -0400
Received: from out3.smtp.messagingengine.com ([66.111.4.27]:34708 "EHLO
	out3.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757976Ab1EZOPx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 May 2011 10:15:53 -0400
X-Sasl-enc: AoPTMhRohXszrRh29RYcN3UdL44yozmhbNHUWiajvlYN 1306419352
Date: Thu, 26 May 2011 07:14:30 -0700
From: Greg KH <greg@kroah.com>
To: Xiangliang Yu <yuxiangl@marvell.com>
Cc: "James.Bottomley@suse.de" <James.Bottomley@suse.de>,
        "jslaby@suse.cz" <jslaby@suse.cz>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Jacky Feng <jfeng@marvell.com>
Subject: Re: [PATCH 3/9] [SCSI] mvsas: Add driver version and interrupt
 coalescing to device 	attributes in sysfs
Message-ID: <20110526141430.GD4164@kroah.com>
References: <mvsas-intr-coal>
 <1306247507-6136-1-git-send-email-yxlraid@gmail.com>
 <20110526021809.GA22496@kroah.com>
 <F766E4F80769BD478052FB6533FA745D19FAD846E0@SC-VEXCH4.marvell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <F766E4F80769BD478052FB6533FA745D19FAD846E0@SC-VEXCH4.marvell.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 26, 2011 at 02:00:21AM -0700, Xiangliang Yu wrote:
> 
> >Subject: Re: [PATCH 3/9] [SCSI] mvsas: Add driver version and interrupt >coalescing to device attributes in sysfs
> >> 
> >> -- Add support for driver version and interrupt coalescing device attributes.
> 
> >When you add a sysfs file, you must also add a Documentation/ABI file as
> >well.  Please do that here.
> 
> These device attributes are sysft class properties for the scsi host,
> and the sysfs files are within scsi host sysfs directory. so, do you
> think I need add a ABI file?  and , I can't find anything about scsi
> host sysfs file under directory Documentation/ABI.

Yes, again, if you add a sysfs file, you need to add documentation
explaining exactly what it is there for and what it does.

And if there isn't already a file for this device, then please add it.

thanks,

greg k-h
