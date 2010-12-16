Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756409Ab0LPU2c (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Dec 2010 15:28:32 -0500
Received: from kroah.org ([198.145.64.141]:47293 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756318Ab0LPU22 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Dec 2010 15:28:28 -0500
Date: Thu, 16 Dec 2010 12:24:33 -0800
From: Greg KH <greg@kroah.com>
To: pavan_savoy@ti.com
Cc: gregkh@suse.de, linux-kernel@vger.kernel.org, padovan@profusion.mobi,
        marcel@holtmann.org, linux-bluetooth@vger.kernel.org
Subject: Re: [PATCH 1/2] drivers:staging: ti-st: remove bt_drv
Message-ID: <20101216202433.GA25948@kroah.com>
References: <1292328400-7649-1-git-send-email-pavan_savoy@ti.com>
 <1292328400-7649-2-git-send-email-pavan_savoy@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1292328400-7649-2-git-send-email-pavan_savoy@ti.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 14, 2010 at 06:06:39AM -0600, pavan_savoy@ti.com wrote:
> From: Pavan Savoy <pavan_savoy@ti.com>
> 
> Remove the BT driver from the staging folder.
> This is to update the staging folder with the
> latest BT driver.
> 
> Signed-off-by: Pavan Savoy <pavan_savoy@ti.com>
> ---
>  drivers/staging/ti-st/Kconfig   |   14 -

Deleting this file will break the build at this patch, right?  Care to
just make it empty instead and then add the needed data to it in the
next patch?

thanks,

greg k-h
