Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756431Ab1CMBHC (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Mar 2011 20:07:02 -0500
Received: from kroah.org ([198.145.64.141]:47464 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756368Ab1CMBGz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Mar 2011 20:06:55 -0500
Date: Sat, 12 Mar 2011 17:05:10 -0800
From: Greg KH <greg@kroah.com>
To: Andy Green <andy@warmcat.com>
Cc: linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
        linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        patches@linaro.org, Andy Green <andy.green@linaro.org>
Subject: Re: [RFC PATCH 1/5] OMAP2+: Panda introduce async platform data
 definition
Message-ID: <20110313010510.GC20396@kroah.com>
References: <20110312224440.27728.60593.stgit@otae.warmcat.com>
 <20110312225039.27728.24017.stgit@otae.warmcat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110312225039.27728.24017.stgit@otae.warmcat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Mar 12, 2011 at 10:50:39PM +0000, Andy Green wrote:
> This is part of an RFC patch series introducing asynchronous platform
> data, which may be attached to discovered bus devices at probe time
> based on the device path.
> 
> As part of the series, platform_data is enabled in usbnet layer.
> 
> This patch defines the usbnet platform data, allowing the panda board
> definition file to assert the naming of the usbnet network interface
> should be eth%d instead of usb%d.

Why is this?  If you want to do this, it should be done in userspace
today, no need to involve the kernel in this type of thing.

So I don't see the point of this patch.

thanks,

greg k-h
