Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758216Ab2DFVoa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Apr 2012 17:44:30 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:37092 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755281Ab2DFVo3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Apr 2012 17:44:29 -0400
X-Sasl-enc: winecMe8yvalE7ARdpmZPSHLuwuKfvHurNqSvsFXWegG 1333748668
Date: Fri, 6 Apr 2012 14:44:26 -0700
From: Greg KH <greg@kroah.com>
To: Asai Thambi S P <asamymuthupa@micron.com>
Cc: Jens Axboe <axboe@kernel.dk>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Sam Bradshaw <sbradshaw@micron.com>
Subject: Re: [PATCH 2/5] mtip32xx: Add new sysfs entry 'status' and fix
 restart port
Message-ID: <20120406214426.GA12772@kroah.com>
References: <4F7E07DC.50909@micron.com>
 <20120406011037.GA25892@kroah.com>
 <4F7F322B.6060805@micron.com>
 <4F7F615B.80305@micron.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4F7F615B.80305@micron.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 06, 2012 at 02:34:19PM -0700, Asai Thambi S P wrote:
> On 4/6/2012 11:12 AM, Asai Thambi S P wrote:
> 
> > On 4/5/2012 6:10 PM, Greg KH wrote:
> > 
> >> On Thu, Apr 05, 2012 at 02:00:12PM -0700, Asai Thambi S P wrote:
> >>>
> >>> * Add support for detecting the following device status
> >>> 	- write protect
> >>> 	- over temp (thermal shutdown)
> >>> * New sysfs entry 'status' created for this device,  possible values - online, write_protect, thermal_shutdown
> >>
> >> All new (and existing) sysfs files must be documented in
> >> Documentation/ABI/ please do so for these new ones when you add them to
> >> the kernel.
> > 
> > 
> > I was not aware of this. Thanks. I will a add new file for mtip32xx driver.
> > 
> 
> 
> Greg,
> 
> The sysfs entry for the disk is 
> /sys/block/rssda -> ../devices/pci0000:00/0000:00:01.0/0000:01:00.0/block/rssda
> 
> Should I use /sys/block/<disk>/<entry> or
> /sys/devices/.../block/<disk>/entry> in the doc file?

What do the existing api files show for block devices?

