Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751533Ab1F1V0e (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jun 2011 17:26:34 -0400
Received: from out4.smtp.messagingengine.com ([66.111.4.28]:33387 "EHLO
	out4.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750854Ab1F1V02 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jun 2011 17:26:28 -0400
X-Sasl-enc: KePDyvKod04tbk/auyz3GQu+znNMHKC9CIIyCNV/MqjO 1309296388
Date: Tue, 28 Jun 2011 14:01:12 -0700
From: Greg KH <greg@kroah.com>
To: Subhasish Ghosh <subhasish@mistralsolutions.com>
Cc: davinci-linux-open-source@linux.davincidsp.com,
        "open list:STAGING SUBSYSTEM" <devel@driverdev.osuosl.org>,
        sachi@mistralsolutions.com, stalin.s@mistralsolutions.com,
        Greg Kroah-Hartman <gregkh@suse.de>,
        open list <linux-kernel@vger.kernel.org>, m-watkins@ti.com,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v5 1/1] drivers:staging:pruss: add pruss staging mfd
 driver.
Message-ID: <20110628210112.GA31081@kroah.com>
References: <1306827939-4133-1-git-send-email-subhasish@mistralsolutions.com>
 <1306827939-4133-2-git-send-email-subhasish@mistralsolutions.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1306827939-4133-2-git-send-email-subhasish@mistralsolutions.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 31, 2011 at 01:15:39PM +0530, Subhasish Ghosh wrote:
> This patch adds the pruss MFD driver and associated include files.
> For details regarding the PRUSS please refer the folowing link:
> http://processors.wiki.ti.com/index.php/Programmable_Realtime_Unit_Subsystem
> 
> The rational behind the MFD driver being the fact that multiple devices can
> be implemented on the cores independently. This is determined by the nature
> of the program which is loaded into the PRU's instruction memory.
> A device may be de-initialized and another loaded or two different devices
> can be run simultaneously on the two cores.
> It's also possible, as in our case, to implement a single device on both
> the PRU's resulting in improved load sharing.
> 
> Signed-off-by: Subhasish Ghosh <subhasish@mistralsolutions.com>

Please refresh my memory as to why this can't get merged into the
"normal" part of the kernel?

> --- /dev/null
> +++ b/drivers/staging/pruss/TODO
> @@ -0,0 +1,14 @@
> +TODO:
> +
> +0. Functionality wise, everything works.
> +
> +1. Currently the plan is to add sysfs attributes for
> +	a. prux/load
> +	b. prux/unload
> +	c. prux/run
> +	d. prux/halt
> +   These will add to a more dynamic firmware management for the PRU.

Why sysfs?


> +
> +2. But, not sure how the fdt will effect these entries.
> +
> +Please send patches to Greg Kroah-Hartman <greg@kroah.com>.

Don't you want people to Cc: you as well?

I'm not going to adopt this driver, I have enough as it is :)

thanks,

greg k-h
