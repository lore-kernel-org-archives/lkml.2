Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757601Ab0KKAgW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Nov 2010 19:36:22 -0500
Received: from kroah.org ([198.145.64.141]:57972 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753586Ab0KKAgU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Nov 2010 19:36:20 -0500
Date: Wed, 10 Nov 2010 16:25:42 -0800
From: Greg KH <greg@kroah.com>
To: Wolfram Sang <w.sang@pengutronix.de>
Cc: linux-i2c@vger.kernel.org, devel@driverdev.osuosl.org,
        Hong Liu <hong.liu@intel.com>,
        Janusz Krzysztofik <jkrzyszt@tis.icnet.pl>,
        linux-kernel@vger.kernel.org, Greg Kroah-Hartman <gregkh@suse.de>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Anantha Narayanan <anantha.narayanan@intel.com>,
        Andres Salomon <dilinger@queued.net>,
        Andrew Morton <akpm@linux-foundation.org>, linux-media@vger.kernel.org,
        Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
        Alan Cox <alan@linux.intel.com>
Subject: Re: [PATCH] i2c: Remove obsolete cleanup for clientdata
Message-ID: <20101111002542.GA21393@kroah.com>
References: <1289392100-32668-1-git-send-email-w.sang@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1289392100-32668-1-git-send-email-w.sang@pengutronix.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 10, 2010 at 01:28:19PM +0100, Wolfram Sang wrote:
> A few new i2c-drivers came into the kernel which clear the clientdata-pointer
> on exit. This is obsolete meanwhile, so fix it and hope the word will spread.
> 
> Signed-off-by: Wolfram Sang <w.sang@pengutronix.de>
> ---
> 
> Like last time I suggest to collect acks from the driver authors and merge it
> vie Jean's i2c-tree.
> 
>  drivers/media/video/imx074.c          |    2 --
>  drivers/media/video/ov6650.c          |    2 --
>  drivers/misc/apds9802als.c            |    1 -
>  drivers/staging/olpc_dcon/olpc_dcon.c |    3 ---
>  4 files changed, 0 insertions(+), 8 deletions(-)

For the staging driver:
	Acked-by: Greg Kroah-Hartman <gregkh@suse.de>

thanks,

greg k-h
