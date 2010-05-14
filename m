Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932140Ab0ENTRw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 May 2010 15:17:52 -0400
Received: from kroah.org ([198.145.64.141]:57269 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750899Ab0ENTRt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 May 2010 15:17:49 -0400
Date: Fri, 14 May 2010 12:11:12 -0700
From: Greg KH <greg@kroah.com>
To: Michal Nazarewicz <m.nazarewicz@samsung.com>
Cc: linux-usb@vger.kernel.org, Kyungmin Park <kyungmin.park@samsung.com>,
       Marek Szyprowski <m.szyprowski@samsung.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] usb: gadget: g_mass_storage: static data instead of
 dynamic allocation
Message-ID: <20100514191112.GF2505@kroah.com>
References: <e3abf3898ffa038852e8b3307d37927f886fb72c.1273772850.git.mina86@mina86.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e3abf3898ffa038852e8b3307d37927f886fb72c.1273772850.git.mina86@mina86.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 13, 2010 at 07:50:32PM +0200, Michal Nazarewicz wrote:
> This patch changes msg_do_config() function so that it uses
> a static object for a fsg_common structure instead of dynamically
> allocated.  This is a micro-optimisation.
> 
> Signed-off-by: Michal Nazarewicz <m.nazarewicz@samsung.com>
> ---
>  drivers/usb/gadget/mass_storage.c |   13 +++++++------

This patch doesn't apply.  Care to redo it against the linux-next tree?

thanks,

greg k-h
