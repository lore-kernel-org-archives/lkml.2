Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933279Ab2CZSHp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Mar 2012 14:07:45 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:62512 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933231Ab2CZSHk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Mar 2012 14:07:40 -0400
Date: Mon, 26 Mar 2012 11:07:36 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Randy Dunlap <rdunlap@xenotime.net>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>, linux-usb@vger.kernel.org
Subject: Re: linux-next: Tree for Mar 26 (usbcore)
Message-ID: <20120326180736.GA2893@kroah.com>
References: <20120326152807.debdb1ec426b3c370c121178@canb.auug.org.au>
 <4F70A03C.2070400@xenotime.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4F70A03C.2070400@xenotime.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 26, 2012 at 09:58:36AM -0700, Randy Dunlap wrote:
> On 03/25/2012 09:28 PM, Stephen Rothwell wrote:
> 
> > Hi all,
> > 
> > Reminder: please do not add stuff destined for v3.5 to linux-next
> > included trees/branches until after v3.4-rc1 has been released.
> > 
> > Changes since 20120323:
> 
> 
> 
> on x86_64:
> 
> ERROR: "utf16s_to_utf8s" [drivers/usb/core/usbcore.ko] undefined!
> ERROR: "usb_speed_string" [drivers/usb/core/usbcore.ko] undefined!
> 
> Full randconfig file is attached.

Odd, nothing in the usb core has changed in a while in this area,
although we might have gotten some core dependancies mixed up for random
configurations like this.

Any patches would be greatly appreciated...

greg k-h
