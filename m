Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756243Ab0FYPeK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jun 2010 11:34:10 -0400
Received: from kroah.org ([198.145.64.141]:36442 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751248Ab0FYPeJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jun 2010 11:34:09 -0400
Date: Fri, 25 Jun 2010 08:27:27 -0700
From: Greg KH <greg@kroah.com>
To: Michal Nazarewicz <m.nazarewicz@samsung.com>
Cc: linux-usb@vger.kernel.org,
       David Brownell <dbrownell@users.sourceforge.net>,
       Kyungmin Park <kyungmin.park@samsung.com>,
       Marek Szyprowski <m.szyprowski@samsung.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] USB: gadget: g_fs: code cleanup
Message-ID: <20100625152727.GB11840@kroah.com>
References: <b51342e058f33dc9d78491c1209d0e86d09ed9db.1276170819.git.m.nazarewicz@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b51342e058f33dc9d78491c1209d0e86d09ed9db.1276170819.git.m.nazarewicz@samsung.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 25, 2010 at 04:29:27PM +0200, Michal Nazarewicz wrote:
> This commit cleans the g_fs gadget hopefully making it more
> readable.  This is achieved by usage of the usb_string_ids_tab()
> function for batch string IDs registration as well as
> generalising configuration so that a single routine is
> used to add each configuration and bind interfaces.  As an
> effect, the code is shorter and has fewer #ifdefs.
> 
> Moreover, in some circumstances previous code #defined
> CONFIG_USB_FUNCTIONFS_GENERIC macro to prevent a situation
> where gadget with no configurations is built.  This code removes
> the #define form source code and achieves the same effect using
> select in Kconfig.
> 
> This patch also changes wording and names of the Kconfig options.
> 
> Signed-off-by: Michal Nazarewicz <m.nazarewicz@samsung.com>
> Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
> ---
> I believe this was overlooked so I am resending this patch again.

Please always cc: me on patches you want applied, otherwise I very
easily overlook them due to the very large amount of email I get.

thanks,

greg k-h
