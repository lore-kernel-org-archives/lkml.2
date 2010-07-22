Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756242Ab0GVPco (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jul 2010 11:32:44 -0400
Received: from cantor2.suse.de ([195.135.220.15]:35808 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752169Ab0GVPcm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jul 2010 11:32:42 -0400
Date: Thu, 22 Jul 2010 08:15:45 -0700
From: Greg KH <gregkh@suse.de>
To: Andy Shevchenko <andy.shevchenko@gmail.com>
Cc: linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org
Subject: Re: [PATCH] staging: clean up code a bit, use kernel native methods
Message-ID: <20100722151545.GA6696@suse.de>
References: <1279805042-9936-1-git-send-email-andy.shevchenko@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1279805042-9936-1-git-send-email-andy.shevchenko@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 22, 2010 at 04:24:02PM +0300, Andy Shevchenko wrote:
> Signed-off-by: Andy Shevchenko <andy.shevchenko@gmail.com>
> Cc: Greg Kroah-Hartman <gregkh@suse.de>
> Cc: devel@driverdev.osuosl.org
> ---
>  drivers/staging/otus/apdbg.c             |   22 -----------------
>  drivers/staging/panel/panel.c            |   19 +++++---------
>  drivers/staging/rtl8192su/r8192S_Efuse.c |   27 ++-------------------
>  drivers/staging/wlags49_h2/wl_util.c     |   37 +-----------------------------
>  drivers/staging/wlags49_h2/wl_util.h     |    2 -
>  drivers/staging/wlan-ng/prism2sta.c      |    6 +---

Can you break this up into 5 different patches, one per driver, and use
a better description of exactly what you did in each driver?

thanks,

greg k-h
