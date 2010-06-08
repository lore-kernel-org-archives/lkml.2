Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752936Ab0FHPLF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jun 2010 11:11:05 -0400
Received: from cantor2.suse.de ([195.135.220.15]:54821 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752258Ab0FHPLC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jun 2010 11:11:02 -0400
Date: Tue, 8 Jun 2010 08:03:10 -0700
From: Greg KH <gregkh@suse.de>
To: naveen_jain@ti.com
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
       pavan_savoy@ti.com
Subject: Re: [PATCH] drivers:staging: ti-st: add version info to sysfs
Message-ID: <20100608150310.GA29618@suse.de>
References: <1276008885-30282-1-git-send-email-naveen_jain@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1276008885-30282-1-git-send-email-naveen_jain@ti.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 08, 2010 at 09:54:45AM -0500, naveen_jain@ti.com wrote:
> From: Naveen Jain <naveen_jain@ti.com>
> 
> Cleanup sysfs code, so that all the required sysfs entries
> are created under /sys/bus/platform/drivers/kim now.

Where were they ending up?

> Add version information to be available under the sysfs group
> for kim.

How about splitting this into two different patches, as they do
different things?

thanks,

greg k-h
