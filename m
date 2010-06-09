Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757000Ab0FIPZo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jun 2010 11:25:44 -0400
Received: from cantor.suse.de ([195.135.220.2]:44916 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756152Ab0FIPZm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jun 2010 11:25:42 -0400
Date: Wed, 9 Jun 2010 08:20:21 -0700
From: Greg KH <gregkh@suse.de>
To: Naveen Jain <naveen_jain@ti.com>
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
       "Savoy, Pavan" <pavan_savoy@ti.com>
Subject: Re: [PATCH] drivers:staging: ti-st: add version info to sysfs
Message-ID: <20100609152021.GA21167@suse.de>
References: <1276008885-30282-1-git-send-email-naveen_jain@ti.com>
 <20100608150310.GA29618@suse.de>
 <00b801cb07b1$2cce1420$LocalHost@MINX0100354>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <00b801cb07b1$2cce1420$LocalHost@MINX0100354>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 09, 2010 at 02:23:02PM +0530, Naveen Jain wrote:
> From: "Greg KH" <gregkh@suse.de>
> To: "Jain, Naveen" <naveen_jain@ti.com>
> Cc: <devel@driverdev.osuosl.org>; <linux-kernel@vger.kernel.org>;
> "Savoy, Pavan" <pavan_savoy@ti.com>
> Sent: Tuesday, June 08, 2010 8:33 PM
> Subject: Re: [PATCH] drivers:staging: ti-st: add version info to sysfs
> 
> 
> On Tue, Jun 08, 2010 at 09:54:45AM -0500, naveen_jain@ti.com wrote:
> >>From: Naveen Jain <naveen_jain@ti.com>
> >>
> >>Cleanup sysfs code, so that all the required sysfs entries
> >>are created under /sys/bus/platform/drivers/kim now.
> 
> >Where were they ending up?
> 
> Earlier the kobject was created under /sys/, and the entries went
> under /sys/uim. The below patch cleans that up.

Ick, for some reason I thought that was fixed up previously.

> [PATCH 1/2] drivers:staging: ti-st: cleanup sysfs code
> 
> 
> 
> >>Add version information to be available under the sysfs group
> >>for kim.
> 
> >How about splitting this into two different patches, as they do
> >different things?
> 
> It is split into two diff patches now.

Thanks.

greg k-h
