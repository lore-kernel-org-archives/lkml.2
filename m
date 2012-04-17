Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752152Ab2DQUzz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Apr 2012 16:55:55 -0400
Received: from acsinet15.oracle.com ([141.146.126.227]:19476 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750851Ab2DQUzy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Apr 2012 16:55:54 -0400
Date: Tue, 17 Apr 2012 23:57:41 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Roland Stigge <stigge@antcom.de>
Cc: arm@kernel.org, linux-arm-kernel@lists.infradead.org,
        thierry.reding@avionic-design.de, gregkh@linuxfoundation.org,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-input@vger.kernel.org, dmitry.torokhov@gmail.com,
        axel.lin@gmail.com, broonie@opensource.wolfsonmicro.com,
        marek.vasut@gmail.com, devel@driverdev.osuosl.org, kevin.wells@nxp.com,
        srinivas.bakki@nxp.com
Subject: Re: [PATCH v2 1/8] ohci-nxp: Driver cleanup
Message-ID: <20120417205740.GI6498@mwanda>
References: <1334682507-15055-1-git-send-email-stigge@antcom.de>
 <1334682507-15055-2-git-send-email-stigge@antcom.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1334682507-15055-2-git-send-email-stigge@antcom.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090205.4F8DD8B9.002A,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 17, 2012 at 07:08:20PM +0200, Roland Stigge wrote:
> @@ -435,6 +436,7 @@ static int __devinit usb_hcd_nxp_probe(s
>  	}
>  
>  	__raw_writel(__raw_readl(USB_CTRL) | USB_HOST_NEED_CLK_EN, USB_CTRL);
> +	__raw_writel(__raw_readl(USB_CTRL) & ~USB_DEV_NEED_CLK_EN, USB_CTRL);
>  
>  	/* Set to enable all needed USB clocks */
>  	__raw_writel(USB_CLOCK_MASK, USB_OTG_CLK_CTRL);

What does this chunk do?  Is this part of the "* Fixed controller
initialization (bits)" bullet point?  How does it affect the user?
Should it be included in the 3.4 kernel?

Generally bug fixes, cleanups, and new features should go into
different patches.  If you use "git citool" then you can highlight
and right click on the lines you want to go into the patch.

regards,
dan carpenter

