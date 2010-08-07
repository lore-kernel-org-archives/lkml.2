Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760915Ab0HGAd4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Aug 2010 20:33:56 -0400
Received: from cantor2.suse.de ([195.135.220.15]:39012 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752142Ab0HGAdy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Aug 2010 20:33:54 -0400
Date: Fri, 6 Aug 2010 17:25:48 -0700
From: Greg KH <gregkh@suse.de>
To: Patrick Pannuto <ppannuto@codeaurora.org>
Cc: linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        Magnus Damm <damm@opensource.se>, Paul Mundt <lethal@linux-sh.org>,
        Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>,
        "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: [PATCH] platform: Use drv->driver.bus instead of assuming
 platform_bus_type
Message-ID: <20100807002548.GA22362@suse.de>
References: <1281139962-20538-1-git-send-email-ppannuto@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1281139962-20538-1-git-send-email-ppannuto@codeaurora.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 06, 2010 at 05:12:41PM -0700, Patrick Pannuto wrote:
> In theory (although not *yet* in practice), a driver being passed
> to platform_driver_probe might have driver.bus set to something
> other than platform_bus_type. Locking drv->driver.bus is always
> correct.
> 
> Signed-off-by: Patrick Pannuto <ppannuto@codeaurora.org>

Thanks, I'll queue this up after the .36 merge window is over in my
tree.

greg k-h
