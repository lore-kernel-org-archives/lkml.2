Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755983Ab2AJCCt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jan 2012 21:02:49 -0500
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:59603 "EHLO
	out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755947Ab2AJCCr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jan 2012 21:02:47 -0500
X-Sasl-enc: hj1JcuNJr8bf9fAgLnBQvYFS98idApz/nKesbNFmql0O 1326160966
Date: Mon, 9 Jan 2012 18:02:05 -0800
From: Greg KH <greg@kroah.com>
To: Ameya Palande <ameya.palande@ti.com>
Cc: arnd@arndb.de, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Texas Instruments DRV2665 Piezo Haptics Driver
Message-ID: <20120110020205.GA11831@kroah.com>
References: <1326159027-21185-1-git-send-email-ameya.palande@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1326159027-21185-1-git-send-email-ameya.palande@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 09, 2012 at 05:30:27PM -0800, Ameya Palande wrote:
> Texas Instruments's DRV2665 is a piezo haptic driver which is capable of
> driving both high-voltage and low-voltage piezo haptic actuators.
> 
> Signed-off-by: Ameya Palande <ameya.palande@ti.com>
> ---
>  MAINTAINERS               |    5 +
>  drivers/misc/Kconfig      |    7 +
>  drivers/misc/Makefile     |    1 +
>  drivers/misc/ti_drv2665.c |  448 +++++++++++++++++++++++++++++++++++++++++++++

Where is the Documentation/ABI/ entries for this driver?

And most importantly, why do you feel this is a "misc" driver and not an
iio driver instead?

thanks,

greg k-h
