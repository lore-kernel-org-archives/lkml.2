Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753909Ab1GFIoO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jul 2011 04:44:14 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:57755 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753263Ab1GFIoN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jul 2011 04:44:13 -0400
Date: Wed, 6 Jul 2011 11:43:06 +0300
From: Dan Carpenter <error27@gmail.com>
To: Ravishankar <ravishankarkm32@gmail.com>
Cc: gregkh@suse.de, wfp5p@virginia.edu, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org,
        Ravishankar <ravi.shankar@greenturtles.in>
Subject: Re: [PATCH 3/3] Staging: comedi: fix warning: line over 80
 characters issue in usbduxfast.c
Message-ID: <20110706084306.GG18655@shale.localdomain>
References: <1309940810-2381-1-git-send-email-ravishankarkm32@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1309940810-2381-1-git-send-email-ravishankarkm32@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 06, 2011 at 01:56:50PM +0530, Ravishankar wrote:
> -	ret = request_firmware_nowait(THIS_MODULE,
> -				      FW_ACTION_HOTPLUG,
> -				      "usbduxfast_firmware.bin",
> -				      &udev->dev,
> -				      GFP_KERNEL,
> -				      usbduxfastsub + index,
> -				      usbduxfast_firmware_request_complete_handler);
> +	ret =
> +	request_firmware_nowait(THIS_MODULE,
> +				FW_ACTION_HOTPLUG,
> +				"usbduxfast_firmware.bin",
> +				&udev->dev,
> +				GFP_KERNEL,
> +				usbduxfastsub + index,
> +				usbduxfast_firmware_request_complete_handler);
> +

No.  Don't do this.  The "usbduxfast_firmware_request_complete_handler"
variable name is too long.  Rename it something shorter.

regards,
dan carpenter

