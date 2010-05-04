Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933516Ab0EDPlx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 May 2010 11:41:53 -0400
Received: from kroah.org ([198.145.64.141]:44276 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933068Ab0EDPlw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 May 2010 11:41:52 -0400
Date: Tue, 4 May 2010 08:29:49 -0700
From: Greg KH <greg@kroah.com>
To: Hank Janssen <hjanssen@sailtheuniverse.com>
Cc: hjanssen@microsoft.com, linux-kernel@vger.kernel.org,
       devel@driverdev.osuosl.org, virtualization@lists.osdl.org,
       gregkh@suse.de, haiyangz@microsoft.com
Subject: Re: [PATCH 1/1] hv: Added new hv_utils driver with shutdown as
 first functionality - NO OUTLOOK
Message-ID: <20100504152949.GA22850@kroah.com>
References: <4BE0A5C9.2020409@sailtheuniverse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4BE0A5C9.2020409@sailtheuniverse.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 04, 2010 at 03:55:05PM -0700, Hank Janssen wrote:
> 
> Resending this patch from my personal Linux server. Exchange server and
> outlook at Microsoft seems to badly munge my patch. :(
> 
> From: Hank Janssen <hjanssen@sailtheuniverse.com>

In the future, please put your microsoft email address here.

> Subject: [PATCH 1/1] hv: Added new hv_utils driver with shutdown as first functionality
> 
> Addition of new driver for Hyper-V called hv_utils.
> This driver is intended to support things like KVP, Timesync, Heartbeat etc.
> 
> This first release has support for Gracefull shutdown.
> e.g. Select shutdown from the Hyper-V main admin screen and the Linux VM
> will do a gracefull shutdown.
> 
> Signed-off-by: Hank Janssen <microsoft.com>

That's not a valid email address.

> Signed-off-by: Hank Janssen <sailtheuniverse.com>

Neither is that.

Also, you "signed-off" on a patch twice, not good.

Other than that, which I fixed up by hand, it looks good, and I've
applied it and added some clean-up patches on top of it to resolve some
issues.

thanks,

greg k-h
