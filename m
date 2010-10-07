Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752836Ab0JGPku (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Oct 2010 11:40:50 -0400
Received: from kroah.org ([198.145.64.141]:40109 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752699Ab0JGPks (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Oct 2010 11:40:48 -0400
Date: Thu, 7 Oct 2010 08:37:23 -0700
From: Greg KH <greg@kroah.com>
To: tlinder <tlinder@codeaurora.org>
Cc: linux-usb@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        David Brownell <dbrownell@users.sourceforge.net>,
        Greg Kroah-Hartman <gregkh@suse.de>,
        Michal Nazarewicz <m.nazarewicz@samsung.com>,
        Randy Dunlap <randy.dunlap@oracle.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Robert Lukassen <robert.lukassen@tomtom.com>,
        Fabien Chouteau <fabien.chouteau@barco.com>, Tejun Heo <tj@kernel.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC/PATCH v2 3/3] usb:gadget: Add SuperSpeed support to the
 Gadget Framework
Message-ID: <20101007153723.GC26129@kroah.com>
References: <1286465101-12539-1-git-send-email-tlinder@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1286465101-12539-1-git-send-email-tlinder@codeaurora.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 07, 2010 at 05:24:57PM +0200, tlinder wrote:
> +/** Default endpoint companion descriptor */

What's the '**' for?

> +static struct usb_ss_ep_comp_descriptor default_ep_comp_desc = {
> +		.bDescriptorType = USB_DT_SS_ENDPOINT_COMP,
> +		.bLength = 0x06,
> +		.bMaxBurst = 0, /* the default is we don't support bursting */
> +		.bmAttributes = 0, /* 2^0 streams supported */
> +		.wBytesPerInterval = 0,
> +};
> +
> +/**This function receives a pointer to usb_function and adds

Incorrect kerneldoc formatting, please fix this up.

thanks,

greg k-h
