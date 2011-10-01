Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754198Ab1JAUBi (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Oct 2011 16:01:38 -0400
Received: from rcsinet15.oracle.com ([148.87.113.117]:26903 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751204Ab1JAUBa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Oct 2011 16:01:30 -0400
Date: Sat, 1 Oct 2011 22:58:35 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Mark Einon <mark.einon@gmail.com>
Cc: gregkh@suse.de, devel@driverdev.osuosl.org, alan@linux.intel.com,
        linux-kernel@vger.kernel.org, o.hartmann@telovital.com
Subject: Re: [PATCH 7/8] staging: et131x: Updating copyright statements and
 module authors
Message-ID: <20111001195835.GA2925@longonot.mountain>
References: <1317464057-18231-1-git-send-email-mark.einon@gmail.com>
 <1317464057-18231-7-git-send-email-mark.einon@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1317464057-18231-7-git-send-email-mark.einon@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: rtcsinet21.oracle.com [66.248.204.29]
X-CT-RefId: str=0001.0A090201.4E877191.001B,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Oct 01, 2011 at 11:14:16AM +0100, Mark Einon wrote:
> @@ -945,5 +947,6 @@ module_exit(et131x_cleanup_module);
>  
>  /* Modinfo parameters (filled out using defines from et131x_version.h) */
>  MODULE_AUTHOR(DRIVER_AUTHOR);
> +MODULE_AUTHOR(DRIVER_AUTHOR2);
>  MODULE_DESCRIPTION(DRIVER_INFO);
>  MODULE_LICENSE(DRIVER_LICENSE);

Both DRIVER_AUTHOR and DRIVER_AUTHOR2 are silly macros.  Put the name
in directly.  That way you won't need the comment explaining where to
find the definitions.  Also normally people use gt lt brackets for
emails:

MODULE_AUTHOR("Victor Soriano <vjsoriano@agere.com>");
MODULE_AUTHOR("Mark Einon <mark.einon@gmail.com>");

Go ahead and fix this in a later patch if you want.  All the macros
there should probably be replaced.

Btw, the problems with kernel.org have complicated things here, so
I can't tell if you have already fixed this, but the driver doesn't
compile any more.  The Kconfig file says it "depends on NETDEV_1000"
but NETDEV_1000 isn't around any more since f860b0522f65d3
"drivers/net: Kconfig and Makefile cleanup" was merged.

regards,
dan carpenter

