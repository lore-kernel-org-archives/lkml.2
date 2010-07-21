Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758882Ab0GUTTP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jul 2010 15:19:15 -0400
Received: from kroah.org ([198.145.64.141]:35227 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756666Ab0GUTTN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jul 2010 15:19:13 -0400
Date: Wed, 21 Jul 2010 12:17:11 -0700
From: Greg KH <greg@kroah.com>
To: Andy Shevchenko <andy.shevchenko@gmail.com>
Cc: linux-kernel@vger.kernel.org,
        Andy Shevchenko <ext-andriy.shevchenko@nokia.com>,
        Denis Karpov <ext-denis.2.karpov@nokia.com>,
        Adrian Hunter <adrian.hunter@nokia.com>,
        Alan Stern <stern@rowland.harvard.edu>,
        David Brownell <dbrownell@users.sourceforge.net>,
        Greg Kroah-Hartman <gregkh@suse.de>, linux-usb@vger.kernel.org
Subject: Re: [PATCHv3 2/2] usb: gadget: storage: optional SCSI WRITE FUA bit
Message-ID: <20100721191711.GA28893@kroah.com>
References: <op.vft7mxqm7p4s8u@pikus>
 <1279184841-15097-1-git-send-email-ext-andriy.shevchenko@nokia.com>
 <1279184841-15097-2-git-send-email-ext-andriy.shevchenko@nokia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1279184841-15097-2-git-send-email-ext-andriy.shevchenko@nokia.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 15, 2010 at 12:07:21PM +0300, Andy Shevchenko wrote:
> MS Windows mounts removable storage in "Removal optimized mode" by
> default. All the writes to the media are synchronous which is achieved
> by setting FUA (Force Unit Access) bit in SCSI WRITE(10,12) commands.
> This prevents I/O requests aggregation in block layer dramatically
> decreasing performance.
> 
> This patch brings an option to accept or ignore mentioned bit
>  a) via specifying module parameter "nofua", or
>  b) through sysfs entry
> 	/sys/devices/platform/musb_hdrc/gadget/gadget-lun-N/nofua

Any new sysfs entry needs a matching documentation entry in the
Documentation/ABI/ directory.

Care to resend these two patches, with that documentation change added
as well?

thanks,

greg k-h
