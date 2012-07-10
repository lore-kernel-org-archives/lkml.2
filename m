Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754043Ab2GJWBP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jul 2012 18:01:15 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:58465 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752809Ab2GJWBN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jul 2012 18:01:13 -0400
Date: Tue, 10 Jul 2012 15:01:08 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Gustavo Padovan <gustavo@padovan.org>
Cc: linux-bluetooth@vger.kernel.org,
        Gustavo Padovan <gustavo.padovan@collabora.co.uk>,
        "open list:USB SUBSYSTEM" <linux-usb@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] USB: add USB_VENDOR_AND_INTERFACE_INFO() macro
Message-ID: <20120710220108.GA28387@kroah.com>
References: <1341957063-11989-1-git-send-email-gustavo@padovan.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1341957063-11989-1-git-send-email-gustavo@padovan.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 10, 2012 at 06:51:03PM -0300, Gustavo Padovan wrote:
> From: Gustavo Padovan <gustavo.padovan@collabora.co.uk>
> 
> A lot of Broadcom Bluetooth devices provides vendor specific interface
> class and we are getting flooded by patches adding new device support.
> This change will help us enable support for any other Broadcom with vendor
> specific device that arrives in the future.
> 
> Only the product id changes for those devices, so this macro would be
> perfect for us:
> 
> { USB_VENDOR_AND_INTERFACE_INFO(0x0a5c, 0xff, 0x01, 0x01) }

Two entries in the cdc_wdm driver can also be converted to use this
interface.  Do you want to send a patch doing that, or do you want me to
do it?

thanks,

greg k-h
