Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759236Ab1DNRld (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Apr 2011 13:41:33 -0400
Received: from kroah.org ([198.145.64.141]:58907 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759050Ab1DNRlX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Apr 2011 13:41:23 -0400
Date: Thu, 14 Apr 2011 10:41:10 -0700
From: Greg KH <greg@kroah.com>
To: Tatyana Brokhman <tlinder@codeaurora.org>
Cc: gregkh@suse.de, linux-arm-msm@vger.kernel.org, ablay@codeaurora.org,
        balbi@ti.com,
        "open list:USB GADGET/PERIPH..." <linux-usb@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [RFC/PATCH v3 2/5] uas: MS UAS Gadget driver - Infrastructure
Message-ID: <20110414174110.GB11640@kroah.com>
References: <1302788176-27972-1-git-send-email-tlinder@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1302788176-27972-1-git-send-email-tlinder@codeaurora.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 14, 2011 at 04:36:15PM +0300, Tatyana Brokhman wrote:
> --- /dev/null
> +++ b/drivers/usb/gadget/f_uasp.c
> @@ -0,0 +1,2399 @@
> +/*
> + * f_uasp.c -- Mass Storage USB UASP Composite Function
> + *
> + * Copyright (C) 2003-2005 Alan Stern
> + * Copyright (C) 2011 Code Aurora Forum.
> + * All rights reserved.
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License version 2 and
> + * only version 2 as published by the Free Software Foundation.
> + *
> + * This program is distributed in the hope that it will be useful,
> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
> + * GNU General Public License for more details.
> + *
> + * You should have received a copy of the GNU General Public License
> + * along with this program; if not, write to the Free Software
> + * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA
> + * 02110-1301, USA.

Minor nit.  Never include this last paragraph in your code unless you
guarantee you are willing to keep up with the office moves of the FSF
for the next 40+ years and promise to update this file as well.

It's pointless and has nothing to do with kernel development stuff, just
leave it out please.

thanks,

greg k-h
